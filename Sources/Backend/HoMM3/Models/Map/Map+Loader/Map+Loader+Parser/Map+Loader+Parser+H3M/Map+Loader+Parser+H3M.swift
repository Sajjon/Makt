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


public typealias Bitmask = BitArray

// MARK: Parse "Definitions
private extension Map.Loader.Parser.H3M {
    
    /// Parse object atributes
    /// Here are properties of all objects on the map including castles and heroes
    /// (but not land itself, roads and rivers) and Events, both placed on the map
    /// and global events (these are set in Map Specifications)
    func parseDefinitions() throws -> Map.Definitions {
        let definitionCount = try reader.readUInt32()
        let attributes: [Map.Object.Attributes] = try definitionCount.nTimes {
            /// aka "Sprite name"
            let animationFileName = try reader.readString()
            
            /// Which squares (of this object) are passable, counted from the bottom right corner
            /// (bit 1: passable, bit 0: impassable
            let passabilityBitmask = try reader.readBitArray(byteCount: Map.Object.Attributes.Pathfinding.rowCount)
            
            /// Active/visitable squares (overlaid on impassable squares)
            /// (bit 1: active, bit 0: passive
            let visitabilityBitmask = try reader.readBitArray(byteCount: Map.Object.Attributes.Pathfinding.rowCount)
            
            func boolPerPosition(bitmask: Bitmask) -> [Map.Object.Attributes.Pathfinding.RelativePosition: Bool] {
                precondition(bitmask.count == Map.Object.Attributes.Pathfinding.rowCount * Map.Object.Attributes.Pathfinding.columnCount)
                var index = 0
                var map: [Map.Object.Attributes.Pathfinding.RelativePosition: Bool] = [:]
                for row in 0..<Map.Object.Attributes.Pathfinding.rowCount {
                    for column in 0..<Map.Object.Attributes.Pathfinding.columnCount {
                        defer { index += 1 }
                        let relativePosition: Map.Object.Attributes.Pathfinding.RelativePosition = .init(column: .init(column), row: .init(row))
                        map[relativePosition] = bitmask[index]
                    }
                }
                return map
            }
            
            
            let pathfinding = Map.Object.Attributes.Pathfinding(
                visitability: .init(visitablilityPerTileRelativePositionMap: boolPerPosition(bitmask: visitabilityBitmask)),
                passability:  .init(passabilityPerTileRelativePositionMap: boolPerPosition(bitmask: passabilityBitmask))
            )
            
             ///   ├─ 2  bytes.
             ///   │      bit0 - water
             ///   │      bit1 - lava
             ///   │      bit2 - underground
             ///   │      bit3 - rocks
             ///   │      bit4 - swamp
             ///   │      bit5 - snow
             ///   │      bit6 - grass
             ///   │      bit7 - sand
             ///   │      bit8 - dirt
            func parseLandscapes() throws -> [Map.Tile.Terrain.Kind] {
                try reader.readBitArray(byteCount: 2).prefix(9).enumerated().compactMap { (bit, supported) in
                    guard supported else { return nil }
                    switch bit {
                    case 0: return .water
                    case 1: return .lava
                    case 2: return .subterranean
                    case 3: return .rock
                    case 4: return .swamp
                    case 5: return .snow
                    case 6: return .grass
                    case 7: return .sand
                    case 8: return .dirt
                    default: fatalError("Should never happen.")
                    }
                }
            }
            
            /// what kinds of landscape it can be put on
            let supportedLandscapes = try parseLandscapes()
            
            /// What landscape group the object will be in the editor
            let mapEditorLandscapeGroup = try parseLandscapes()
            
            
            
            let objectID = try Map.Object.ID(
                id: reader.readUInt32(),
                subId: reader.readUInt32()
            )


            /// used by editor
            let objectGroupRaw = try reader.readUInt8()
            let group: Map.Object.Attributes.Group? = .init(rawValue: objectGroupRaw)
            
            /// Antoshkiv: "whether the object will be over or below object"
            /// VCMI: `printPriority`
            let zRenderingPosition = try reader.readUInt8()
            
            /// Unknown
            let unknown16Bytes = try reader.read(byteCount: 16)
            
            let objectAttributes = Map.Object.Attributes(
                animationFileName: animationFileName,
                supportedLandscapes: supportedLandscapes,
                mapEditorLandscapeGroup: mapEditorLandscapeGroup,
                objectID: objectID,
                group: group,
                pathfinding: pathfinding,
                zRenderingPosition: zRenderingPosition,
                unknown16Bytes: unknown16Bytes
            )
    
            return objectAttributes

        }
        return .init(objectAttributes: attributes)
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
