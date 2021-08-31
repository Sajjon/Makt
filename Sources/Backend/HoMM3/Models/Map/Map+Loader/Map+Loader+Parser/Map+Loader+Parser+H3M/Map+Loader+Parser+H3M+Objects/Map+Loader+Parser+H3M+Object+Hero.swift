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
    
    func parseOwner() throws -> PlayerColor? {
        let raw = try reader.readUInt8()
        return raw != PlayerColor.neutralRawValue ? try PlayerColor(integer: raw) : nil
    }
    
    func parseSpellID() throws -> Spell.ID? {
        let raw = try reader.readUInt8()
        return raw != Spell.ID.noneRawValue ? try Spell.ID(integer: raw) : nil
    }
}

private extension Map.Loader.Parser.H3M {
    
    
    
    func _parseHero(
        class maybeExpectedHeroClass: Hero.Class?,
        format: Map.Format
    ) throws -> Hero {
        let questIdentifier: UInt32? = format > .restorationOfErathia ? try reader.readUInt32() : nil
        let owner: PlayerColor? = try parseOwner()
        
        let identifierKind: Hero.IdentifierKind = try {
            
            if let expectedHeroClass = maybeExpectedHeroClass {
                let heroID = try Hero.ID(integer: reader.readUInt8())
                assert(heroID.class == expectedHeroClass)
                return Hero.IdentifierKind.specificHeroWithID(heroID)
            } else {
                let heroClass = try Hero.Class(integer: reader.readUInt8())
                return Hero.IdentifierKind.randomHeroOfClass(heroClass)
            }
            
        }()
   
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
      
        let startingSecondarySkills: [Hero.SecondarySkill]? = try reader.readBool() ? try parseSecondarySkills(amount: reader.readUInt32()) : nil
        
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
            identifierKind: identifierKind,
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
