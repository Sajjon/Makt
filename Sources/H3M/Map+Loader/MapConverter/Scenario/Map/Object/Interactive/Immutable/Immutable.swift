//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public extension Map {
    struct AltarOfSacrifice: Model {}
}

// MARK: ImmutableObject
public extension Scenario.Map.Object.Interactive {
    
    /// An immutable interactive object on the map, e.g. a `sign`.
    enum Immutable: Model {
        case sign(Map.Sign)
        case altarOfSacrifice(Map.AltarOfSacrifice)
    }
}
