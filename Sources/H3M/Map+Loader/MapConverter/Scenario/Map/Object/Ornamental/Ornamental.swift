//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation

public extension Scenario.Map.Object {

    /// A Non-interactive, purely ornamental object of the map, e.g. some trees or
    /// some rock that have no effect on game play. Purely aesthetic. This is
    /// basically just an image, but also "tooltip:able" info to user, i.e. if
    /// user hovers mouse over it we should display info dialog saying "trees".
    enum Ornamental: Model {
        case tree
    }
}
