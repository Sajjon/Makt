//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation


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

// MARK: Convenience Init
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
