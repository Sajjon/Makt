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
        
        let _ = try parseDefInfo()
        let _ = try parseObjects()
        let _ = try parseEvents()
        
        return .init(
            checksum: checksum,
            about: about
        )
    }
}


public extension Map {
    struct DefInfo: Equatable {}
}


public extension Map {
    struct Rumor: Equatable {
        public let name: String
        public let text: String
    }
}
public extension Map {
    
    struct World: Equatable {
        public let above: Level
        /// Underworld
        public let belowGround: Level?
    }
    
    struct Level: Equatable {
        public let isUnderworld: Bool
        public let tiles: [Tile]
    }
}
public extension Map.Level {
    struct Tile: Equatable, CustomDebugStringConvertible {
        public let position: Position
        public let terrain: Terrain
        
        public let river: River?
        public let road: Road?
        
        /// Whether tile is coastal (allows disembarking if land or block movement if water)
        public let isCoastal: Bool
        
        /// If water tile, then we might have greater speed with our boats thanks to favourable winds.
        public let hasFavourableWindEffect: Bool
    }
}

public extension Map.Level.Tile {
    var debugDescription: String {
        let riverString = river.map({ "river: \($0)" }) ?? ""
        let roadString = road.map({ "road: \($0)" }) ?? ""
        let isCoastalString = isCoastal ? "isCostal: true" : ""
        let hasFavourableWindString = hasFavourableWindEffect ? "hasFavourableWindString: true" : ""
        return """
        position: \(position)
        terrain: \(terrain)
        \(riverString)\(roadString)\(isCoastalString)\(hasFavourableWindString)
        """
    }
}

public extension Map.Level.Tile {
    struct Terrain: Equatable, CustomDebugStringConvertible {
        public let kind: Kind
        public let viewID: ViewID
        public let rotation: Rotation
    }
}


public extension Map.Level.Tile.Terrain {
    var debugDescription: String {
        """
        kind: \(kind)
        viewID: \(viewID.view)
        rotation: \(rotation)
        """
    }
}

public extension Map.Level.Tile.Terrain {
    var isBlocked: Bool { kind == .rock }
}

public extension Map.Level.Tile.Terrain {
    enum Kind: UInt8, Equatable, CustomDebugStringConvertible {
        case dirt, sand, grass, snow, swamp, rough, subterranean, lava, water, rock
    }
    
    struct ViewID: Equatable {
        public let view: UInt8
    }
}

public extension Map.Level.Tile.Terrain.Kind {
    var debugDescription: String {
        switch self {
        case .dirt: return "dirt"
        case .sand: return "sand"
        case .grass: return "grass"
        case .snow: return "snow"
        case .swamp: return "swamp"
        case .rough: return "rough"
        case .subterranean: return "subterranean"
        case .lava: return "lava"
        case .water: return "water"
        case .rock: return "rock"
        }
    }
}

public extension Map.Level.Tile {
    
    struct River: Equatable, CustomDebugStringConvertible {
        public let kind: Kind
        
        /// The direction of the river's "mouth" (three split smaller rivers). Not to be confused with `rotation` of image.
        public let direction: Direction
        
        /// Rotation of the image
        public let rotation: Rotation
    }
    
    struct Road: Equatable, CustomDebugStringConvertible {
        public let kind: Kind
        
        /// The direction of the the road. Not to be confused with `rotation` of image.
        public let direction: Direction
        
        /// Rotation of the image
        public let rotation: Rotation
    }
    
    /// Not to be confused with `Rotation`
    ///
    /// TODO figure out what these mean, maybe 2 (underworld/above) * 8 [north, northEast, east, southEast, souuth, southWest, west, northWest] ?
    enum Direction: UInt8, Equatable, CaseIterable, CustomDebugStringConvertible {
//        case north, south, east, west
        
        case unknown0 = 0
        case unknown1 = 1
        case unknown2 = 2
        case unknown3 = 3
        case unknown4 = 4
        case unknown5 = 5
        case unknown6 = 6
        case unknown7 = 7
        case unknown8 = 8
        case unknown9 = 9
        case unknown10 = 10
        case unknown11 = 11
        case unknown12 = 12
        case unknown13 = 13
        case unknown14 = 14
        case unknown15 = 15
        case unknown16 = 16
    }
    
    /// Not to be confused with `Direction`.
    /// TODO ASSERT CORRECT rawValue. this is A GUESS from Cyons cide
    enum Rotation: UInt8, Equatable, CaseIterable, CustomDebugStringConvertible {
        case identity, clockwise90, rotation180, counterClockwise90
    }
   
}

public extension Map.Level.Tile.Road {
    var debugDescription: String {
        """
        kind: \(kind)
        direction: \(direction)
        rotation: \(rotation)
        """
    }
}


public extension Map.Level.Tile.River {
    var debugDescription: String {
        """
        kind: \(kind)
        direction: \(direction)
        rotation: \(rotation)
        """
    }
}

public extension Map.Level.Tile.Direction {
    var debugDescription: String {
        return "unknownDirection: \(rawValue)"
    }
}

public extension Map.Level.Tile.Rotation {
    var debugDescription: String {
        switch self {
        case .identity: return "identity"
        case .clockwise90: return "clockwise90"
        case .rotation180: return "rotation180"
        case .counterClockwise90: return "counterClockwise90"
        }
    }
}


public extension Map.Level.Tile.River {
    enum Kind: UInt8, Equatable, CaseIterable, CustomDebugStringConvertible {
        // 0 means "no river", but we model it as `Optional<River>.none` instead of River.Kind having a specific case for it...
        case clear = 1, icy, muddy, lava
    }
}

public extension Map.Level.Tile.River.Kind {
    var debugDescription: String {
        switch self {
        case .clear: return "clear"
        case .icy: return "icy"
        case .muddy: return "muddy"
        case .lava: return "lava"
        }
    }
}

public extension Map.Level.Tile.Road {
    enum Kind: UInt8, Equatable, CaseIterable, CustomDebugStringConvertible {
        // 0 means "no road", but we model it as `Optional<Road>.none` instead of Road.Kind having a specific case for it...
        case dirt = 1, gravel, cobbelStone
    }
}

public extension Map.Level.Tile.Road.Kind {
    var debugDescription: String {
        switch self {
        case .dirt: return "dirt"
        case .gravel: return "gravel"
        case .cobbelStone: return "cobbelStone"
        }
    }
}

public extension Map {
    enum Object: Equatable {}
}

public extension Map {
    struct Event: Equatable {}
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


// MARK: Parse "Def" info
private extension Map.Loader.Parser.H3M {
    func parseDefInfo() throws -> Map.DefInfo {
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
