//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation

public extension Scenario.Map.Object.Interactive.Mutable.Visitable {

    /// A *once* and only once per game visitable object, first come first served
    /// this game object, e.g. `lean to`.
    enum OncePerGame: Model {
        case leanTo(Scenario.Map.LeanTo)
    }
}
