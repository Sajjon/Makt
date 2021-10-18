//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public extension Scenario.Map.Object.Interactive.Mutable.Perishable {
    
    /// An object which might perish based on some condition, e.g. an artifact
    /// might be guarded and if player is prompted to avoid the fight the object
    /// will not be consumed.
    enum Conditional: Model {
        
        /// Will perish once player has either defeated the monster or it has
        /// joined attacking heros army.
        case monster(Map.Monster)
        
        /// Might be guarded, if so player have to defeat guards.
        case artifact(Map.GuardedArtifact)
        
        /// Might perish on first visit or not depending on the value of
        /// the property `cancelEventAfterFirstVisit` of the event.
        case geoEvent(Map.GeoEvent)
        
        /// Might perish if the quest (if any) has been completed.
        case questGuard(Quest?)
        
        /// Might be guarded, if so player have to defeat guards.
        case resource(Map.GuardedResource)
    }
}
