//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation

// MARK: Perishable
public extension Scenario.Map.Object.Interactive.Mutable {
    /// A perishable object that will disappear from the map after it has been
    /// consumed, e.g. a resource or a monster, a scholar or an artifact.
    enum Perishable: Model {
        
        /// An object which will always - unconditionally - perish, e.g.
        /// a `scholar` or a `treasure chest`.
        case immediately(Immediately)
        
        /// An object which might perish based on some condition, e.g. an artifact
        /// might be guarded and if player is prompted to avoid the fight the object
        /// will not be consumed.
        case conditional(Conditional)
    }
}
