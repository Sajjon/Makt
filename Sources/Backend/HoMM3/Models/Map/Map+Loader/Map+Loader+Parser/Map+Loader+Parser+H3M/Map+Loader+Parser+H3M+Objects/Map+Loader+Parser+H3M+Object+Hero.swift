//
//  Map+Loader+Parser+H3M+Object+Hero.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-23.
//

import Foundation


internal extension Map.Loader.Parser.H3M {
    
    func parseHero(
        format: Map.Format,
        predefinedHeroes: [Hero.Predefined],
        disposedHeroes: [Hero.Disposed],
        heroID: Hero.ID
    ) throws -> Hero {
        let predefined: Hero.Predefined? = predefinedHeroes.first(where: { $0.heroID == heroID })
        let disposed: Hero.Disposed? = disposedHeroes.first(where: { $0.heroID == heroID })
        
        return try _parseHero(format: format, predefinedHero: predefined, disposedHero: disposed)
    }
    
    func parseRandomHero(
        format: Map.Format
    ) throws -> Hero {
        try _parseHero(format: format)
    }
}

private extension Map.Loader.Parser.H3M {
    
    func _parseHero(
        format: Map.Format,
        predefinedHero: Hero.Predefined? = nil,
        disposedHero: Hero.Disposed? = nil
    ) throws -> Hero {
        let questIdentifier: UInt32? = format > .restorationOfErathia ? try reader.readUInt32() : nil
        let owner = try PlayerColor(integer: reader.readUInt8())
        let heroClass = try Hero.Class(integer: reader.readUInt8())
        
   
        let name: String = try {
            let maybeCustomName: String? = try reader.readBool() ? reader.readString() : nil
            let name = maybeCustomName ?? disposedHero?.name
            guard let heroName = name else {
                fatalError("Expected a name!")
            }
            return heroName
        }()
        
        let experiencePoints: UInt32? = try {
            if format > .armageddonsBlade {
                return try reader.readBool() ? reader.readUInt32() : nil
            } else {
                let xp = try reader.readUInt32()
                guard xp > 0 else { return nil }
                return xp
            }
        }() ?? predefinedHero?.startingExperiencePoints
        
        let portraitID: Hero.ID = try {
            let maybeCustomPortrait: Hero.ID? = try reader.readBool() ? .init(integer: reader.readUInt8()) : nil
            let portraitID = maybeCustomPortrait ?? disposedHero?.portraitID
            
            guard let heroPortraitID = portraitID else {
                fatalError("Expected a portrait!")
            }
            return heroPortraitID
            
        }()
        
      
        let startingSecondarySkills: [Hero.SecondarySkill]? = try reader.readBool() ? try parseSecondarySkills() :  predefinedHero?.startingSecondarySkills
        
        let garrison: Army? = try reader.readBool() ? parseArmyOf(parseFormation: false) : nil
        let artifacts = try parseArtifactsOfHero(format: format)
        let patrolRadius = try reader.readUInt8()
        let isPatrolling = patrolRadius != 0xff
        
        
        let customBiography: String? = try {
            guard format > .restorationOfErathia else { return nil }
            return try !reader.readBool() ? nil : reader.readString()
        }() ?? predefinedHero?.biography
        
        
        let customGender: Hero.Gender? = try {
            guard format > .restorationOfErathia else { return nil }
            guard try reader.readBool() else { /* does NOT have custom gender */ return nil }
            return Hero.Gender(rawValue: try reader.readUInt8())
        }() ?? predefinedHero?.customGender
        
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
        }() ?? predefinedHero?.customSpells
        
        let customPrimarySkills: [Hero.PrimarySkill]? = try {
            guard format > .armageddonsBlade else { return nil }
            guard try reader.readBool() else { return nil }
            return try parsePrimarySkills() // TODO replace primary skill with hero specialty if available. VCMI does it, but surely we can do better.
        }() ?? predefinedHero?.customPrimarySkills
        
        try reader.skip(byteCount: 16)
        
        return .init(
            class: heroClass,
            questIdentifier: questIdentifier,
            portraitID: portraitID,
            name: name,
            owner: owner,
            garrison: garrison,
            patrolRadius: .init(patrolRadius),
            isPatroling: isPatrolling,
            startingExperiencePoints: experiencePoints ?? 0,
            startingSecondarySkills: startingSecondarySkills,
            artifacts: artifacts,
            biography: customBiography, gender: customGender, spells: customSpells, primarySkills: customPrimarySkills)
    }
    
}
