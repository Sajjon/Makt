//
//  Map+Loader+Parser+H3M+Object+Hero.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-23.
//

import Foundation



internal extension Map.Loader.Parser.H3M {
    
    func parseHero(
        heroClass: Hero.Class,
        format: Map.Format
    ) throws -> Hero {
        try _parseHero(class: heroClass, format: format)
    }
    
    func parseRandomHero(
        format: Map.Format
    ) throws -> Hero {
        try _parseHero(class: nil, format: format)
    }
}

private extension Map.Loader.Parser.H3M {
    func _parseHero(
        class maybeExpectedHeroClass: Hero.Class?,
        format: Map.Format
    ) throws -> Hero {
        let questIdentifier: UInt32? = format > .restorationOfErathia ? try reader.readUInt32() : nil
        let ownerRawID = try reader.readUInt8()
        let owner: PlayerColor? = ownerRawID != PlayerColor.neutralRawValue ? try PlayerColor(integer: ownerRawID) : nil
        let heroClass: Hero.Class = try Hero.Class(integer: reader.readUInt8())
        if let expectedHeroClass = maybeExpectedHeroClass {
            assert(expectedHeroClass == heroClass)
        }
        
   
        let name: String? = try reader.readBool() ? reader.readString() : nil
        
        let experiencePoints: UInt32? = try {
            if format > .armageddonsBlade {
                return try reader.readBool() ? reader.readUInt32() : nil
            } else {
                let xp = try reader.readUInt32()
                guard xp > 0 else { return nil }
                return xp
            }
        }() ?? nil
        
        let portraitID: Hero.ID? = try reader.readBool() ? .init(integer: reader.readUInt8()) : nil
      
        let startingSecondarySkills: [Hero.SecondarySkill]? = try reader.readBool() ? try parseSecondarySkills() : nil
        
        let garrison: CreatureStacks? = try reader.readBool() ? parseCreatureStacks(format: format, count: 7) : nil
        let formation = try Army.Formation(integer: reader.readUInt8())
        let artifacts = try parseArtifactsOfHero(format: format)
        let patrolRadius = try reader.readUInt8()
        let isPatrolling = patrolRadius != 0xff
        
        let customBiography: String? = try {
            guard format > .restorationOfErathia else { return nil }
            return try reader.readBool() ? reader.readString() : nil
        }() ?? nil
        
        let customGender: Hero.Gender? = try {
            guard format > .restorationOfErathia else { return nil }
            guard try reader.readBool() else { /* does NOT have custom gender */ return nil }
            return Hero.Gender(rawValue: try reader.readUInt8())
        }() ?? nil
        
        let customSpells: [Spell.ID]? = try {
            guard format >= .armageddonsBlade else { return nil }
            if format > .armageddonsBlade {
                let hasCustomSpells = try reader.readBool()
                guard hasCustomSpells else { return nil }
                return try parseCustomSpellsOfHero()
            } else {
                assert(format == .armageddonsBlade, "Incorrect implementation")
                // In AB only a single spell can be specified here, 0xFE is default, 0xFF none
                let buff = try reader.readUInt8()
                guard buff < 255 else { return nil } //255 means no spells
                return [try Spell.ID(integer: buff)]
            }
        }() ?? nil
        
        let customPrimarySkills: [Hero.PrimarySkill]? = try {
            guard format > .armageddonsBlade else { return nil }
            guard try reader.readBool() else { return nil }
            return try parsePrimarySkills() // TODO replace primary skill with hero specialty if available. VCMI does it, but surely we can do better.
        }() ?? nil
        
        try reader.skip(byteCount: 16)
        return .init(
            class: heroClass,
            questIdentifier: questIdentifier,
            portraitID: portraitID,
            name: name,
            owner: owner,
            army: garrison,
            formation: formation,
            patrolRadius: .init(patrolRadius),
            isPatroling: isPatrolling,
            startingExperiencePoints: experiencePoints ?? 0,
            startingSecondarySkills: startingSecondarySkills,
            artifacts: artifacts,
            biography: customBiography, gender: customGender, spells: customSpells, primarySkills: customPrimarySkills)
    }
    
}
