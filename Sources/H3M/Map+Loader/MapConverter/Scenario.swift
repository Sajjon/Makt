//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public typealias Model = Hashable & Codable
public typealias Ground = Map.Tile.Ground
public typealias Terrain = Map.Terrain
public typealias GuardedResource = Map.GuardedResource

/// NOT USED (yet)
/// Here follows some ides on how to more effectively represent a map, here called "Scenario"
/// in JSON format. The idea is that we want to avoid DUPLICATION of long arrays with sparse objects
/// in Map format parse from H3M (Malm.Map) we have store ObjectAttributes twice, and we store separate arrays for
/// World.Tiles and ObjectDetails. Down below we put the the ObjectDetails inside the tile(s). And of
/// course we use the very efficient optimization of not encoding position in tiles, but rather
/// derive it from the tile's index inside the tile array. The solution is just a POC but seems promising
/// and the model is more attractive than the Malm.Map one.
public struct Scenario: Model {
    
    /// All information relating to this scenario, e.g. name, description, map
    /// size, teams, player info and win/loss conditions.
    public let info: Info
    
    /// All information needed to render the map, as an array of tiles, with
    /// surface terrain ("ground"), river, road and object(s), if any. In case
    /// of large objects - covering multiple tiles - they are only stored in the
    /// origin tile (lower right if I'm correct, TBD if we change this to upper
    /// right instead, we probably wanna do that.)
    public let map: Map
}

public extension Scenario {
    
    /// All information relating to this scenario, e.g. name, description, map
    /// size, teams, player info and win/loss conditions.
    struct Info: Model {
        public let summary: Summary
        public let playersInfo: PlayersInfo
    }
    
    /// All information needed to render the map.
    struct Map: Model {
        public let upperLevel: Level
        public let lowerLevel: Level?
    }
}

public extension Scenario.Info {
    
    /// Summary of this playable scenario
    struct Summary: Model {
        public let name: String
        public let size: Size
    }
    
    /// All information about players, teams etc.
    struct PlayersInfo: Model {
        public let players: [Player]
    }
}

// MARK: Map Object
public extension Scenario.Map {
    
    /// An object on the map, might be interactive or not (passive). TBD if we
    /// wanna change to only have interactive objects here, and store passive
    /// ones differently. An interactive object is e.g. a `Gold mine` or `Sign`.
    /// or a "consumable" object such as a pile of `Wood` or a monster, e.g. a
    /// pack of `Imps`.
    enum Object: Model {
        case hero(Hero)
        case resource(GuardedResource)
        case unsupported(String?)
    }
}

// MARK: Map Level
public extension Scenario.Map {
    
    /// Representation of one level of a map, either underground or above ground.
    struct Level: Model {
        
        /// If this is underground level or not.
        public let isLowerLevel: Bool
        
        /// The tiles for this level.
        public let tiles: Tiles
        
        public init(
            isLowerLevel: Bool,
            tiles: Tiles
        ) {
            self.isLowerLevel = isLowerLevel
            self.tiles = tiles
        }
    }
}
extension Scenario.Map.Level {
    init(
        isLowerLevel: Bool,
        tiles: [Tile]
    ) {
        self.init(
            isLowerLevel: isLowerLevel,
            tiles: .init(values: tiles)
        )
    }
}

public extension Scenario.Map.Level {
    struct Tile: Hashable {
        public let position: Position
        public let ground: Ground
        public let objects: [Scenario.Map.Object]?
    }
    
    typealias Tiles = ArrayOf<Tile>
    
}


// MARK: Level Codable
public extension Scenario.Map.Level {
    
    enum CodingKeys: String, CodingKey {
        case isLowerLevel, tiles
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        let isLowerLevel = try container.decode(Bool.self, forKey: .isLowerLevel)
        
        let simpleTiles = try container.decode([SimpleTile].self, forKey: .tiles)
        let tileCount = simpleTiles.count
        let tiles: [Tile] = simpleTiles.enumerated().map { (tileIndex, simpleTile) in
            simpleTile.tile(at: tileIndex, of: tileCount, isLowerLevel: isLowerLevel)
        }
        
        self.isLowerLevel = isLowerLevel
        self.tiles = .init(values: tiles)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isLowerLevel, forKey: .isLowerLevel)
        
        try container.encode(
            tiles.values.map { SimpleTile(tile: $0, isLowerLevel: isLowerLevel) },
            forKey: .tiles
        )
    }
}

private extension Scenario.Map.Level {
    
    /// Coding helper struct, making it possible to only encode what is really
    /// necessary, so resulting JSON is as small as possible.
    struct SimpleTile: Codable {
        
        let ground: Ground?
        let objects: [Scenario.Map.Object]?
        
        init(tile: Tile, isLowerLevel: Bool) {
            self.objects = tile.objects
            // Only encode non default terrain
            let defaultGround = Ground.default(isLowerLevel: isLowerLevel)
            self.ground = tile.ground != defaultGround ? tile.ground : nil
            // Position is not encoded
        }
        
        func tile(
            at tileIndex: Int,
            of totalCount: Int,
            isLowerLevel: Bool
        ) -> Tile {
            
            let position = Position.fromTile(at: tileIndex, of: totalCount, inUnderworld: isLowerLevel)
            
            return Tile(
                position: position,
                ground: ground ?? .default(isLowerLevel: isLowerLevel),
                objects: objects
            )
        }
    }
}
