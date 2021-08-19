//
//  Map+Loader+Parser+H3M.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

// MARK: H3M Parser
public extension Map.Loader.Parser {
    final class H3M {
        internal let readMap: Map.Loader.ReadMap
        internal let reader: DataReader
        internal let fileSizeCompressed: Int?
        public init(readMap: Map.Loader.ReadMap, fileSizeCompressed: Int? = nil) {
            self.readMap = readMap
            self.reader = DataReader(data: readMap.data)
            self.fileSizeCompressed = fileSizeCompressed
        }
    }
}

// MARK: Parse Map
extension Map.Loader.Parser.H3M {
    func parse() throws -> Map {
        
        let checksum = CRC32.checksum(readMap.data)
        
        let about = try parseAbout()
        let format = about.summary.format
        
        let _ = try parseDisposedHeroes(format: format)
        let _ = try parseAllowedArtifacts(format: format)
        let _ = try parseAllowedSpells(format: format)
        let _ = try parseAllowedHeroAbilities(format: format)
        let _ = try parseRumors()
        let _ = try parsePredefinedHeroes(format: format)
        
        let _ = try parseTerrain(
            hasUnderworld: about.summary.hasTwoLevels,
            size: about.summary.size
        )
        
        let _ = try parseDefinitions()
        let _ = try parseObjects()
        let _ = try parseEvents()
        
        return .init(
            checksum: checksum,
            about: about
        )
    }
}

internal extension Map.Loader.Parser.H3M {
    func parseHeroID() throws -> Hero.ID? {
        try reader.readHeroID {
            Error.unrecognizedHeroID($0)
        }
    }
    func parseHeroPortraitID() throws -> Hero.ID? {
        try parseHeroID()
    }
}

// MARK: Parse Disposed Heros
private extension Map.Loader.Parser.H3M {
    func parseDisposedHeroes(format: Map.Format) throws -> [Hero.Disposed] {
        var disposed = [Hero.Disposed]()
        if format >= .shadowOfDeath {
            disposed = try reader.readUInt8().nTimes {
                let heroID = try parseHeroID()!
                let portraitID = try parseHeroPortraitID()
                let name = try reader.readString()
                
                let availableForPlayers: [PlayerColor] = try BitArray(
                    data: reader.read(byteCount: 1)
                )
                .enumerated()
                .compactMap { (colorIndex, isAvailable) -> PlayerColor? in
                    guard isAvailable else { return nil }
                    return PlayerColor.allCases[colorIndex]
                }
                
                return Hero.Disposed(
                    heroID: heroID,
                    portraitID: portraitID,
                    name: name,
                    availableForPlayers: availableForPlayers
                )
            }
        }
        try reader.skip(byteCount: 31) // skip `nil`s
        return disposed
    }
}

// MARK: Parse Artifacts
private extension Map.Loader.Parser.H3M {
    func parseAllowedArtifacts(format: Map.Format) throws -> [Artifact.ID] {
        
        let availableIDS = Artifact.ID.available(in: format)
        
        // All allowed by default.
        var allowedArtifactIDs = availableIDS
        
        if format != .restorationOfErathia {
            let bits = try reader.readBitArray(byteCount: format == .armageddonsBlade ? 17 : 18)
            
            allowedArtifactIDs = bits.prefix(availableIDS.count).enumerated().compactMap { (artifactIDIndex, available) in
                guard available else { return nil }
                return availableIDS[artifactIDIndex]
            }
            
        }
        // TODO VCMI manually bans combination artifacts according to some logic... needed?
        return allowedArtifactIDs
    }
}

// MARK: Parse Allowed Spells
private extension Map.Loader.Parser.H3M {
    func parseAllowedSpells(format: Map.Format) throws -> [Spell.ID] {
        
        let availableSpellIDs = Spell.ID.allCases
        var allowedSpellsIDS = availableSpellIDs
        

        if format >= .shadowOfDeath {
            allowedSpellsIDS = try Array(reader.readBitArray(byteCount: 9).prefix(availableSpellIDs.count)).enumerated().compactMap { (spellIDIndex, available) in
                guard available else { return nil }
                return availableSpellIDs[spellIDIndex]
            }
        }
        
        return allowedSpellsIDS
    }
}


// MARK: Parse Allowed Hero Abilities
private extension Map.Loader.Parser.H3M {
    func parseAllowedHeroAbilities(format: Map.Format) throws -> [Hero.SecondarySkill.Kind] {
        
        let availableSkillIDs = Hero.SecondarySkill.Kind.allCases
        var allowedSkillIDs = availableSkillIDs
        

        if format >= .shadowOfDeath {
            allowedSkillIDs = try Array(reader.readBitArray(byteCount: 4).prefix(availableSkillIDs.count)).enumerated().compactMap { (skillKindIDIndex, available) in
                guard available else { return nil }
                return availableSkillIDs[skillKindIDIndex]
            }
        }
        
        return allowedSkillIDs
    }
}


// MARK: Parsed Rumors
private extension Map.Loader.Parser.H3M {
    func parseRumors() throws -> [Map.Rumor] {
        try reader.readUInt32().nTimes {
            let name = try reader.readString()
            let text = try reader.readString()
            return .init(name: name, text: text)
        }
    }
}


// MARK: Parse "Definitions
private extension Map.Loader.Parser.H3M {
    func parseDefinitions() throws -> Map.Definitions {
        .init()
    }
}

// MARK: Parse Objects
private extension Map.Loader.Parser.H3M {
    func parseObjects() throws -> [Map.Object] {
        []
    }
}

// MARK: Parse Events
private extension Map.Loader.Parser.H3M {
    func parseEvents() throws -> [Map.Event] {
        []
    }
    
}
