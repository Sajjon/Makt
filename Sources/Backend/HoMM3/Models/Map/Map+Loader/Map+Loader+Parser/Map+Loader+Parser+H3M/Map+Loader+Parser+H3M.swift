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
    func parse(inspector: Map.Loader.Parser.Inspector? = nil) throws -> Map {
        
        let checksum = CRC32.checksum(readMap.data)
        
        let about = try parseAbout()
        inspector?.didParseAbout(about)
       
        let format = about.summary.format
        
        let disposedHeroes = try parseDisposedHeroes(format: format)
        inspector?.didParseDisposedHeroes(disposedHeroes)
        
        let allowedArtifacts = try parseAllowedArtifacts(format: format)
        inspector?.didParseAllowedArtifacts(allowedArtifacts)
        
        let allowedSpells = try parseAllowedSpells(format: format)
        inspector?.didParseAllowedSpells(allowedSpells)
        
        let allowedHeroAbilities = try parseAllowedHeroAbilities(format: format)
        inspector?.didParseAllowedHeroAbilities(allowedHeroAbilities)
        
        let rumors = try parseRumors()
        inspector?.didParseRumors(rumors)
        
        let predefinedHeroes = try parsePredefinedHeroes(format: format)
        inspector?.didParsePredefinedHeroes(predefinedHeroes)
        
        let world = try parseTerrain(
            hasUnderworld: about.summary.hasTwoLevels,
            size: about.summary.size
        )
        assert(world.above.tiles.count == about.summary.size.tileCount)
        inspector?.didParseWorld(world)
        
        let definitions = try parseDefinitions()
        assert(definitions.objectAttributes.count < (world.above.tiles.count + (world.belowGround?.tiles.count ?? 0)))
        inspector?.didParseDefinitions(definitions)
        
     
        let _ = try parseObjects(
            inspector: inspector,
            format: format,
            definitions: definitions,
            allowedSpellsOnMap: allowedSpells,
            predefinedHeroes: predefinedHeroes,
            disposedHeroes: disposedHeroes
        )
        
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
    
    func parseAvailableForPlayers() throws -> [PlayerColor] {
        try BitArray(
            data: reader.read(byteCount: 1)
        )
        .enumerated()
        .compactMap { (colorIndex, isAvailable) -> PlayerColor? in
            guard isAvailable else { return nil }
            return PlayerColor.allCases[colorIndex]
        }
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
                
                let availableForPlayers = try parseAvailableForPlayers()
                
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

internal extension Map.Loader.Parser.H3M {
    func parseSpellIDs(includeIfBitSet: Bool = true) throws -> [Spell.ID] {
        try Array(
            reader.readBitArray(byteCount: 9)
                .prefix(Spell.ID.allCases.count)
        ).enumerated()
        .compactMap { (spellIDIndex, available) in
            guard available == includeIfBitSet else { return nil }
            return Spell.ID.allCases[spellIDIndex]
        }
    }
}

// MARK: Parse Allowed Spells
private extension Map.Loader.Parser.H3M {
    
    func parseAllowedSpells(format: Map.Format) throws -> [Spell.ID] {
        guard format >= .shadowOfDeath else { return Spell.ID.allCases }
        return try parseSpellIDs()
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
        let attributes: [Map.Object.Attributes] = try (0..<definitionCount).compactMap { _ in
            /// aka "Sprite name"
            let animationFileName = try reader.readString()
            
            let offsetAfterAnimationName = reader.offset
            
            /// Which squares (of this object) are passable, counted from the bottom right corner
            /// (bit 1: passable, bit 0: impassable
            let passabilityBitmask = try reader.readBitArray(byteCount: Map.Object.Attributes.Pathfinding.rowCount)
            
            /// Active/visitable squares (overlaid on impassable squares)
            /// (bit 1: active, bit 0: passive
            let visitabilityBitmask = try reader.readBitArray(byteCount: Map.Object.Attributes.Pathfinding.rowCount)
            
            assert(reader.offset == offsetAfterAnimationName + 12)
            
            func allowedRelativePositions(bitmask: Bitmask) -> Set<Map.Object.Attributes.Pathfinding.RelativePosition> {
                precondition(bitmask.count == Map.Object.Attributes.Pathfinding.rowCount * Map.Object.Attributes.Pathfinding.columnCount)
                var index = 0
                var set = Set<Map.Object.Attributes.Pathfinding.RelativePosition>()
                for row in 0..<Map.Object.Attributes.Pathfinding.rowCount {
                    for column in 0..<Map.Object.Attributes.Pathfinding.columnCount {
                        defer { index += 1 }
                        let relativePosition: Map.Object.Attributes.Pathfinding.RelativePosition = .init(column: .init(column), row: .init(row))
                        let allowed = bitmask[index]
                        if allowed {
                            set.insert(relativePosition)
                        }
                    }
                }
//                return Array(set).sorted()
                return set
            }
            
            
            let pathfinding = Map.Object.Attributes.Pathfinding(
                visitability: .init(relativePositionsOfVisitableTiles: allowedRelativePositions(bitmask: visitabilityBitmask)),
                passability: .init(relativePositionsOfPassableTiles: allowedRelativePositions(bitmask: passabilityBitmask))
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
            let unknownBytes = try reader.read(byteCount: 16)
            guard unknownBytes.allSatisfy({ $0 == 0x00 }) else {
                fatalError("If we hit this fatalError we can probably remove this check. I THINK I've identified behaviour that these 16 unknown bytes are always 16 zeroes. This might not be the case for some custom maps. I've added this assertion as a kind of 'offset check', meaning that it is helpful that we expect these 16 bytes to all be zero as an indicator that we are reading the correct values before at the expected offset in the maps byte blob.")
            }
            
            let objectAttributes = Map.Object.Attributes(
                animationFileName: animationFileName,
                supportedLandscapes: supportedLandscapes,
                mapEditorLandscapeGroup: mapEditorLandscapeGroup,
                objectID: objectID,
                group: group,
                pathfinding: pathfinding,
                zRenderingPosition: zRenderingPosition
            )
            
            guard
                objectAttributes != .invisibleHardcodedIntoEveryMapAttribute_RandomMonster,
                objectAttributes != .invisibleHardcodedIntoEveryMapAttribute_Hole else {
                return nil
            }
    
            return objectAttributes

        }
        
        
   
        return .init(objectAttributes: attributes)
    }
}

private extension Map.Object.Attributes {
    static let invisibleHardcodedIntoEveryMapAttribute_RandomMonster: Self = .init(
        animationFileName: "AVWmrnd0.def",
        supportedLandscapes: [.water, .lava, .subterranean, .rock, .swamp, .snow, .grass, .sand],
        mapEditorLandscapeGroup: [.sand],
        objectID: .randomMonster,
        group: .monsters,
        pathfinding: Pathfinding(
            visitability: [(0, 5)],
            passability: [(0, 0), (0, 1), (1, 0), (2, 0), (3, 0), (0, 2), (0, 3), (0, 4), (4, 0), (5, 0), (6, 0), (7, 0), (1, 1), (1, 2), (2, 1), (2, 2), (3, 1), (4, 1), (5, 1), (6, 1), (3, 2), (4, 2), (1, 3), (7, 1), (2, 3), (3, 3), (4, 3), (5, 2), (6, 2), (7, 2), (5, 3), (1, 4), (6, 3), (7, 3), (1, 5), (2, 4), (2, 5), (3, 4), (4, 4), (5, 4), (3, 5), (4, 5), (5, 5), (6, 4), (6, 5), (7, 4), (7, 5)]
        )
        , zRenderingPosition: 0)
    
    static let invisibleHardcodedIntoEveryMapAttribute_Hole: Self = .init(
        animationFileName: "AVLholg0.def",
        supportedLandscapes: [.snow],
        mapEditorLandscapeGroup: [.snow],
        objectID: .hole,
        group: nil,
        pathfinding: Pathfinding(
            visitability: [],
            passability: [(0, 2), (7, 4), (0, 5), (2, 5), (0, 1), (7, 1), (6, 5), (7, 2), (5, 1), (4, 5), (4, 0), (4, 1), (6, 1), (5, 0), (1, 0), (2, 4), (6, 2), (5, 2), (0, 3), (2, 0), (3, 1), (0, 0), (3, 3), (4, 3), (1, 2), (2, 3), (0, 4), (3, 0), (1, 4), (6, 4), (4, 2), (3, 2), (1, 3), (6, 3), (4, 4), (3, 5), (1, 5), (1, 1), (5, 5), (2, 1), (7, 5), (7, 0), (6, 0), (5, 3), (3, 4), (5, 4), (7, 3), (2, 2)]
            )
        , zRenderingPosition: 1)
}


// MARK: Parse Events
private extension Map.Loader.Parser.H3M {
    func parseEvents() throws -> [Map.Event] {
        []
    }
    
}
