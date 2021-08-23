//
//  Map+Loader+Parser+H3M+ParsePredefinedHeroes.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

// MARK: Parse PreDefined Heroes
internal extension Map.Loader.Parser.H3M {
    func parsePredefinedHeroes(format: Map.Format) throws -> [Hero.Predefined] {
      
        
        switch format {
        #if WOG
        case .wakeOfGods: fallthrough
        #endif // WOG
        case .armageddonsBlade: return []
        case .shadowOfDeath:
            let availableHeroIDs = Hero.ID.playable(in: format)
            assert(availableHeroIDs.count == 156)
            return try (0..<availableHeroIDs.count).compactMap { heroIDIndex in
                
                // Hero is custom?
                guard try reader.readBool() else { return nil }
          
                
                let heroID: Hero.ID = availableHeroIDs[heroIDIndex]
                let startsWithExperiencePoints = try reader.readBool()
                let startingExperiencePoints = try startsWithExperiencePoints ? reader.readUInt32() : 0
                let startsWithSecondarySkills = try reader.readBool()
                let startingSecondarySkills: [Hero.SecondarySkill]? = !startsWithSecondarySkills ? nil : try parseSecondarySkills()
                
                let artifactsForHero = try parseArtifactsOfHero(format: format)
                
                let hasCustomBiographyText = try reader.readBool()
                let biography: String? = try hasCustomBiographyText ? reader.readString() : nil
                
                let genderRaw = try reader.readUInt8()
                let customGender: Hero.Gender? = Hero.Gender(rawValue: genderRaw)
            
                let hasCustomSpells = try reader.readBool()
                let customSpells: [Spell.ID]? = !hasCustomSpells ? nil : try parseCustomSpellsOfHero()
                
                let hasCustomPrimarySkills = try reader.readBool()
                let customPrimarySkills: [Hero.PrimarySkill]? = !hasCustomPrimarySkills ? nil : try parsePrimarySkills()
                
                let predefinedHero = Hero.Predefined(
                    heroID: heroID,
                    startingExperiencePoints: startingExperiencePoints,
                    startingSecondarySkills: startingSecondarySkills,
                    artifacts: artifactsForHero,
                    biography: biography,
                    customGender: customGender,
                    customSpells: customSpells,
                    customPrimarySkills: customPrimarySkills
                )
                
                return predefinedHero
                
            }
        case .restorationOfErathia:
            return []
        }
    }
}
internal extension Map.Loader.Parser.H3M {
    
    func parseSecondarySkills() throws -> [Hero.SecondarySkill] {
        let secondarySkillStartAmount = try reader.readUInt32()
        return try secondarySkillStartAmount.nTimes {
            let kindRaw = try reader.readUInt8()
            guard let kind = Hero.SecondarySkill.Kind(rawValue: kindRaw) else {
                throw Error.unrecognizedSecondarySkillKind(kindRaw)
            }
            let levelRaw = try reader.readUInt8()
            guard let level = Hero.SecondarySkill.Level(rawValue: levelRaw) else {
                throw Error.unrecognizedSecondarySkillLevel(levelRaw)
            }
            return Hero.SecondarySkill(kind: kind, level: level)
        }
    }
    
    func parsePrimarySkills() throws -> [Hero.PrimarySkill] {
        try Hero.PrimarySkill.Kind.allCases.map { kind in
            try Hero.PrimarySkill.init(kind: kind, level: .init(reader.readUInt8()))
        }
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
    
    func parseCustomSpellsOfHero() throws -> [Spell.ID] {
        return try Array(
            reader
                .readBitArray(byteCount: 9)
                .prefix(Spell.ID.allCases.count)
        )
        .enumerated()
        .compactMap { (spellIDIndex, available) in
            guard available else { return nil }
            return Spell.ID.allCases[spellIDIndex]
        }
        
    }
}

internal extension Map.Loader.Parser.H3M {
    func parseArtifactID(format: Map.Format) throws -> Artifact.ID? {
        let artifactIDRaw: UInt16 = try format == .restorationOfErathia ? UInt16(reader.readUInt8()) : reader.readUInt16()
        let isArtifactSet: Bool = format == .restorationOfErathia ? artifactIDRaw == 0xff : artifactIDRaw == 0xffff

        guard isArtifactSet else { return nil }
        return try Artifact.ID(integer: artifactIDRaw)
    }
}

private extension  Map.Loader.Parser.H3M {
    func parseArtifact(in slot: Artifact.Slot, format: Map.Format) throws -> Hero.ArtifactInSlot? {
        guard let artifactId = try parseArtifactID(format: format) else { return nil }
        guard !(artifactId.isWarMachine && slot.isBackpack) else {
            throw Error.warmachineFoundInBackback
        }
                if artifactId == .spellBook && slot == .body(.misc5) {
            fatalError("Spellbook found in misc5. Invalid! Maybe we should just put it in spellbook slot? (and remove this fatalError..)")
        }

        return .init(slot: slot, artifactID: artifactId)
    }
}
