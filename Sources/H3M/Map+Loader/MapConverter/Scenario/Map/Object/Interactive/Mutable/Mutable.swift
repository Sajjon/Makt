//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

// MARK: MutableObject
public extension Scenario.Map.Object.Kind.Interactive {
    
    enum Mutable: Model {
        
        /// A Hero owned by some player.
        case hero(Hero)
        
        /// A Town, a creature generator or resource generator.
        case flaggable(Flaggable)
        
        /// An object which can be visted, but not flagged and is not consumed.
        /// e.g. a `Water wheel` or `Stables` (which can be periodically visited),
        /// `Keymasters tent`, `Library of Enlightment`,
        /// `Lean to` or `Idol of fortune` or `Hut of the magi`.
        case visitable(Visitable)
        
        /// A single visit object which will perish from the map after it is
        /// consumed. e.g. `artifact`, `resource` or `monster`, `sea chest`, `scholar`
        case perishable(Perishable)
    }
}
