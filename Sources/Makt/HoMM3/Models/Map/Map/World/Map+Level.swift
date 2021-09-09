//
//  Map+Level.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation


internal extension Array {
    func chunked(into size: Int, assertSameLength: Bool = true) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            let array = Array(self[$0 ..< Swift.min($0 + size, count)])
            if assertSameLength {
                assert(array.count == size)
            }
            return array
        }
    }
}


public extension Map {
    
    struct Level: Equatable, CustomDebugStringConvertible {
        public let isUnderworld: Bool
        public let tiles: [Tile]
    }
}

public extension Map.Level {
    var debugDescription: String {
        let width = Int(sqrt(Double(tiles.count)))
        let rows: [[Map.Tile]] = tiles.chunked(into: width)
        assert(rows.allSatisfy({ $0.count == width }))
        assert(rows.count == width)
        
        func printRow(_ row: [Map.Tile]) -> String {
            
            func printTile(_ tile: Map.Tile) -> String {
                let t: String
                switch tile.terrain.kind {
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
            
            return row.map(printTile).joined(separator: "")
        }
        
        return rows.map(printRow).joined(separator: "\n")
    }
}
