//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

// MARK: FlaggableObject
public extension Scenario.Map.Object.Interactive.Mutable {
    enum Flaggable: Model {
        case town(Map.Town)
        case resourceGenerator(Map.ResourceGenerator)
        case abandonedMine(Map.AbandonedMine)
        case dwelling(Map.Dwelling)
        case garrison(Map.Garrison)
        case lighthouse(Map.Lighthouse)
        case shipyard(Map.Shipyard)
    }
}

