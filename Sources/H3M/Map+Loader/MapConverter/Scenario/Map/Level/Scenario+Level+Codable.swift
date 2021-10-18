//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

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
            self.objects = tile.objects.isEmpty ? nil :  tile.objects
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
                objects: objects ?? []
            )
        }
    }
}
