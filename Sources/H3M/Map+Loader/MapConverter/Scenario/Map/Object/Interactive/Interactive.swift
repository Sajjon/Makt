//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation

public extension Scenario.Map.Object.Kind {
    /// An interactive object on the map is e.g. a `Gold mine` or `Sign` or a
    /// "consumable" object such as a pile of `Wood` or a monster, e.g. `Imps`.
    enum Interactive: Model {
        case `mutable`(Mutable)
        case immutable(Immutable)
    }
}
