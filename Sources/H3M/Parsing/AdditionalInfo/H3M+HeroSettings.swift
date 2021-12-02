//
//  Map+Loader+Parser+H3M+SettingsForHero.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation
import Malm

// MARK: Parse Hero Settings
internal extension H3M {
    func parseHeroSettings(format: Map.Format) throws -> Map.AdditionalInformation.SettingsForHeroes? {
      
        switch format {
        #if WOG
        case .wakeOfGods: fallthrough
        #endif // WOG
        case .armageddonsBlade: return nil
        case .shadowOfDeath:
            let availableHeroIDs = Hero.ID.playable(in: format)
            let settingsForHeroes: [Map.AdditionalInformation.SettingsForHero] = try (0..<availableHeroIDs.count).compactMap { heroIDIndex in
                // Hero is custom?
                guard try reader.readBool() else { return nil }
                
                let heroID: Hero.ID = availableHeroIDs[heroIDIndex]
                let startsWithExperiencePoints = try reader.readBool()
                let startingExperiencePoints = try startsWithExperiencePoints ? reader.readUInt32() : 0
                let startsWithSecondarySkills = try reader.readBool()
                let startingSecondarySkills: [Hero.SecondarySkill]? = !startsWithSecondarySkills ? nil : try parseSecondarySkills(amount: reader.readUInt32())
                
                let artifactsForHero = try parseArtifactsOfHero(format: format)
                
                let hasCustomBiographyText = try reader.readBool()
                let biography: String? = try hasCustomBiographyText ? reader.readLengthOfStringAndString(assertingMaxLength: 1000) : nil // arbitrarily chosen 
                
                let genderRaw = try reader.readUInt8()
                let customGender: Hero.Gender? = Hero.Gender(rawValue: genderRaw)
            
                let hasCustomSpells = try reader.readBool()
                let customSpells: SpellIDs? = !hasCustomSpells ? nil : try parseSpellIDs()
                
                let hasCustomPrimarySkills = try reader.readBool()
                let customPrimarySkills = !hasCustomPrimarySkills ? nil : try parsePrimarySkills()
                
                return .init(
                    heroID: heroID,
                    startingExperiencePoints: startingExperiencePoints,
                    startingSecondarySkills: startingSecondarySkills.map { .init(values: $0) },
                    artifacts: artifactsForHero,
                    biography: biography,
                    customGender: customGender,
                    customSpells: customSpells,
                    customPrimarySkills: customPrimarySkills
                )
            }
            guard !settingsForHeroes.isEmpty else {
                return nil
            }
            return .init(values: settingsForHeroes)
        case .restorationOfErathia:
            return nil
        }
    }
}
internal extension H3M {
    
    /// Sometimes life is hard... for `Map.PandorasBox` and `Map.Event` just 1 byte (a UInt8) is read from reader as "secondarySkillStartAmount", but for
    /// HeroSettings (SOD) in Map.AdditinalInformation and Hero object on map 4 bytes (a UInt32) is used.
    func parseSecondarySkills<U>(amount secondarySkillStartAmount: U) throws -> [Hero.SecondarySkill] where U: UnsignedInteger & FixedWidthInteger {
        return try secondarySkillStartAmount.nTimes {
            let kindRaw = try reader.readUInt8()
            guard let kind = Hero.SecondarySkill.Kind(rawValue: kindRaw) else {
                throw H3MError.unrecognizedSecondarySkillKind(kindRaw)
            }
            let levelRaw = try reader.readUInt8()
            guard let level = Hero.SecondarySkill.Level(rawValue: levelRaw) else {
                throw H3MError.unrecognizedSecondarySkillLevel(levelRaw)
            }
            return Hero.SecondarySkill(kind: kind, level: level)
        }
    }
    
    func parsePrimarySkills() throws -> Hero.PrimarySkills? {
        let skills: [Hero.PrimarySkill] = try Hero.PrimarySkill.Kind.allCases.map { kind in
            try Hero.PrimarySkill(kind: kind, level: .init(reader.readUInt8()))
        }
        
        return try .init(skills: skills)
    }
    
    func parseArtifactsOfHero(format: Map.Format) throws -> [Hero.ArtifactInSlot]? {
        /// True if artifact set is not default (hero has some artifacts)
        let isArtifactSet = try reader.readBool()
        guard isArtifactSet else { return nil }
        
        var artifactInSlots = [Hero.ArtifactInSlot?]()
        
        let artifactsInNonBackpackSlots: [Hero.ArtifactInSlot?] = try (0..<Artifact.Slot.Body.warMachine4.rawValue).map { slotId in
            let slot = Artifact.Slot.Body(rawValue: slotId)!
            return try parseArtifact(in: .body(slot), format: format)
        }
        artifactInSlots.append(contentsOf: artifactsInNonBackpackSlots)

        if format >= .shadowOfDeath {
            if let catapultArtifact = try parseArtifact(
                in: .catapultSlot,
                format: format
            ) {
                artifactInSlots.append(catapultArtifact)
            } else {
                // ALL heroes starts with a catapult.
                artifactInSlots.append(.init(slot: .catapultSlot, artifactID: .catapult))
            }
        }

        // Maybe start with spellbook
            artifactInSlots.append( try parseArtifact(
                in: .body(.spellbook),
                format: format
            ))

        // VCMI: "19 //???what is that? gap in file or what? - it's probably fifth slot.."
        if format > .restorationOfErathia {
            if let artifactInMisc5 = try parseArtifact(
                in: .body(.misc5),
                format: format
            ) {
                artifactInSlots.append(artifactInMisc5)
            }
        } else {
            try reader.skip(byteCount: 1)
        }

        // artifacts in bag
        let numberOfArtifactsInBackpack = try UInt8(clamping: reader.readUInt16())
        
        let artifactsInBackpack: [Hero.ArtifactInSlot?] = try (0..<numberOfArtifactsInBackpack).map { backpackSlotRawValue in
            guard let backpackSlot = Artifact.Slot.BackpackSlot(backpackSlotRawValue) else {
               fatalError("expected valid slot")
            }
            guard let artifact = try parseArtifact(
                in: .backpack(backpackSlot),
                format: format
            ) else {
                return nil
            }
            
            return artifact
        }
        
        artifactInSlots.append(contentsOf: artifactsInBackpack)
        
        let nonNils = artifactInSlots.compactMap({ $0 })
        guard !nonNils.isEmpty else { return nil }
        return nonNils
    }
    
}

internal extension H3M {
    
    func parseIDBasedOn<RR>(format: Map.Format) throws -> RR? where RR: RawRepresentable, RR.RawValue == UInt8 {
        let idRaw: UInt16 = try format == .restorationOfErathia ? UInt16(reader.readUInt8()) : reader.readUInt16()
        let hasValue: Bool = format == .restorationOfErathia ? idRaw != 0xff : idRaw != 0xffff

        guard hasValue else { return nil }
        return try RR.init(integer: idRaw)
    }
    
    func parseArtifactID(format: Map.Format) throws -> Artifact.ID? {
        try parseIDBasedOn(format: format)
    }
    
    func parseCreatureID(format: Map.Format) throws -> Creature.ID? {
        try parseIDBasedOn(format: format)
    }
    
    func parseArtifactIDs(format: Map.Format) throws -> [Artifact.ID] {
        try reader.readUInt8().nTimes {
            try parseArtifactID(format: format)!
        }
    }
}

private extension  H3M {
    func parseArtifact(in slot: Artifact.Slot, format: Map.Format) throws -> Hero.ArtifactInSlot? {
        var slot = slot
        guard let artifactId = try parseArtifactID(format: format) else { return nil }
        guard !(artifactId.isWarMachine && slot.isBackpack) else {
            throw H3MError.warmachineFoundInBackback
        }
        
        // This is seen in bundled Armageddons Blade map `Freedom`
        if artifactId == .spellBook && slot == .body(.misc5) {
            slot = .body(.spellbook)
//            logger.debug("Warning: Spellbook found in misc5. We will put it in the 'spellbook slot' instead. This strange state has been observed in the following bundled maps: \"Freedom\", \"Faeries!\" and \"Pandora's Box\".")
        }
        
        return .init(slot: slot, artifactID: artifactId)
    }
}
