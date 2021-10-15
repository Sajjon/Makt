//
//  Map+Level.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    
    struct Level: Hashable, CustomDebugStringConvertible, Codable {
        public let tiles: [Tile]
        
        public let isUnderworld: Bool
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let tileRawValues = try container.decode([Tile].self, forKey: .tiles)
            
            let tileCount = tileRawValues.count
            let tiles: [Map.Tile] = tileRawValues.enumerated().map { (index, tile) in
                let position = Position.fromTile(at: index, of: tileCount, inUnderworld: false) // will be fixed in `Map.Level`
                let tileWithPosition = tile.withPosition(position)
                assert(tileWithPosition._position == position)
                assert(tileWithPosition.position == position)
                return tileWithPosition
            }
            
            
            self.tiles = tiles
            self.isUnderworld = try container.decode(Bool.self, forKey: .isUnderworld)
        }
        
        public init(tiles maybeWrongAboveOrUndergroundFlagTiles: [Tile], isUnderworld: Bool = false) {
            let tileElements: [Tile] = maybeWrongAboveOrUndergroundFlagTiles.map { incorrectLevelTile in
                let incorrectPosition = incorrectLevelTile.position
                let correctedPosition = Position(x: incorrectPosition.x, y: incorrectPosition.y, inUnderworld: isUnderworld)
                return incorrectLevelTile.withPosition(correctedPosition)
            }
            
            self.tiles = tileElements
            self.isUnderworld = isUnderworld
        }
    }
}

public extension Map.Level {
    
    var debugDescription: String {
        tileEmojiString
    }
    
    var tileEmojiString: String {

        let width = Int(sqrt(Double(tiles.count)))
        let rows: [[Map.Tile]] = tiles.chunked(into: width)
        assert(rows.allSatisfy({ $0.count == width }))
        assert(rows.count == width)
        
        func printRow(_ row: [Map.Tile]) -> String {
            return row.map { $0.emojiString }.joined(separator: "")
        }
        
        return rows.map(printRow).joined(separator: "\n")
    }
}

public extension Map.Tile {
    var emojiString: String {
        let t: String
        switch ground.terrain {
        case .dirt: t = "◻️"
        case .grass: t = "🟩" // "🍀" //
        case .lava: t = "🌋"
        case .rock: t = "⬛️"
        case .rough: t = "🟧"
        case .sand: t = "🟨"
        case .snow: t = "❄️"
        case .subterranean: t = "📔" // "🟫"
        case .swamp: t = "🍄"
        case .water: t = "💧"
        }
        return t
    }
}
