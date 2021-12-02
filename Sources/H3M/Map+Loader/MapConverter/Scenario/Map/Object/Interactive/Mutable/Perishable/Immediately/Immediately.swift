//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public extension Scenario.Map.Object.Kind.Interactive.Mutable.Perishable {
    
    /// An object which will always - unconditionally - perish, e.g.
    /// a `scholar` or a `treasure chest`.
    enum Immediately: Model {
        case scholar(Map.Scholar)
        case treasureChest(Scenario.Map.TreasureChest)
        case seaChest(Scenario.Map.SeaChest)
        case grail(Map.Grail)
        case oceanBottle(Map.OceanBottle)
        case spellScroll(Map.SpellScroll)
        case pandorasBox(Map.PandorasBox)
    }
}
