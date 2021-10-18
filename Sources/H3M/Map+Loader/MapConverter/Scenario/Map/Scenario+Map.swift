//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public extension Scenario {

    /// All information needed to render the map.
    struct Map: Model {
        public let upperLevel: Level
        public let lowerLevel: Level?
    }
}
