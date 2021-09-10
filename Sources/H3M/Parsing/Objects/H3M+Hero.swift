//
//  Map+Loader+Parser+H3M+Object+Hero.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-23.
//

import Foundation
import Malm



internal extension Map.Loader.Parser.H3M {
    
    func parseHero(
        heroClass: Hero.Class,
        format: Map.Format
    ) throws -> Hero {
        try _parseHero(heroClass: heroClass, format: format)
    }
    
    func parsePrisonHero(
        format: Map.Format
    ) throws -> Hero {
        try _parseHero(heroClass: nil, format: format, isPrison: true)
    }
    
    func parseRandomHero(
        format: Map.Format
    ) throws -> Hero {
        try _parseHero(heroClass: nil, format: format)
    }

}

private extension Map.Loader.Parser.H3M {
    
    
    func _parseHero(
        heroClass maybeExpectedHeroClass: Hero.Class?,
        format: Map.Format,
        isPrison: Bool = false
    ) throws -> Hero {
        let questIdentifier: UInt32? = format > .restorationOfErathia ? try reader.readUInt32() : nil
        let owner: Player? = try parseOwner()
        
        let identifierKind: Hero.IdentifierKind = try {
            let heroIdThingyRaw = try reader.readUInt8()
            if let expectedHeroclass = maybeExpectedHeroClass {
                let heroID = try Hero.ID(integer: heroIdThingyRaw)
                assert(heroID.class == expectedHeroclass)

                return Hero.IdentifierKind.specificHeroWithID(heroID)
            } else if isPrison {
                let heroID = try Hero.ID(integer: heroIdThingyRaw)
                return Hero.IdentifierKind.specificHeroWithID(heroID)
            } else {
              
                let randomHeroID: Hero.ID? = try? Hero.ID.init(integer: heroIdThingyRaw)
                let randomHeroClass: Hero.Class? = try? Hero.Class.init(integer: heroIdThingyRaw)
                return .randomHero
            }
            
        }()
   
        let name: String? = try reader.readBool() ? reader.readString() : nil
        
        let experiencePoints: UInt32? = try {
            if format >= .shadowOfDeath {
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
        let formation = try CreatureStacks.Formation(integer: reader.readUInt8())
        let artifacts = try parseArtifactsOfHero(format: format)
        
        /// 0xff == do NOT patrol, 0x00 == "Patrol while Stand still" (weird...)
        let patrolRadiusRaw = try reader.readUInt8()
        let patrol: Hero.Patrol? = try patrolRadiusRaw != 0xff ? .init(integer: patrolRadiusRaw) : nil
        
        let customBiography: String? = try {
            guard format > .restorationOfErathia else { return nil }
            return try reader.readBool() ? reader.readString() : nil
        }() ?? nil
        
        let customGender: Hero.Gender? = try {
            guard format > .restorationOfErathia else { return nil }
            return try Hero.Gender(integer: reader.readUInt8())
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
                guard buff < 254 else { return nil } // 0xFE is default, 0xFF none
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
            patrol: patrol,
            startingExperiencePoints: experiencePoints ?? 0,
            startingSecondarySkills: startingSecondarySkills.map { .init(values: $0) },
            artifactsInSlots: artifacts.map { .init(values: $0) },
            biography: customBiography,
            gender: customGender,
            spells: customSpells.map { .init(values: $0) },
            primarySkills: customPrimarySkills.map { .init(values: $0) }
        )
    }
    
}

internal extension Map.Loader.Parser.H3M {
    func parseOwner() throws -> Player? {
        let raw = try reader.readUInt8()
        return raw != Player.neutralRawValue ? try Player(integer: raw) : nil
    }
    
    func parseSpellID() throws -> Spell.ID? {
        let raw = try reader.readUInt8()
        return raw != Spell.ID.noneRawValue ? try Spell.ID(integer: raw) : nil
    }
}
