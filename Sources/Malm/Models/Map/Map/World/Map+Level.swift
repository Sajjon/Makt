//
//  Map+Level.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation


public extension Map {
    
    struct Level: Hashable, CustomDebugStringConvertible {
        public let tiles: [Tile]
        public let isUnderworld: Bool
        
        public init(tiles: [Tile], isUnderworld: Bool = false) {
            self.tiles = tiles
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
