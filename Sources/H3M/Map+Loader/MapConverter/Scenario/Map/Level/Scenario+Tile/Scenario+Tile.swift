//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Util
import Malm

public extension Scenario.Map.Level {
    struct Tile: Hashable {
        public let position: Position
        public let ground: Ground
        
        /// Map
        public let objects: [Scenario.Map.Object]
        
    }
    
    typealias Tiles = ArrayOf<Tile>
}
