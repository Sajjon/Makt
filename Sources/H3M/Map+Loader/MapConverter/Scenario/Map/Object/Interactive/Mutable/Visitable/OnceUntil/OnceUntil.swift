//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

// MARK: - Visitable + OnceUntil
// MARK: -
public extension Scenario.Map.Object.Kind.Interactive.Mutable.Visitable {
    
    /// A revisitable object if some conditional (non time) been met:
    /// `Fountain of fortune`, `Seers hut`, `Faerie Ring`,
    enum OnceUntil: Model {
        case foughtBattle(FoughtBattle)
        case critteriaMet(CritteriaMet)
    }
}

// MARK: - OnceUntil+FoughtBattle
// MARK: -
public extension Scenario.Map.Object.Kind.Interactive.Mutable.Visitable.OnceUntil {
    
    /// A conditionally visitable object which might will not benefit the hero
    /// to revisit if she has not fought a fight since last visit.
    enum FoughtBattle: Model {
        case fountainOfFortune(Scenario.Map.FountainOfFortune)
    }
    
}


// MARK: - OnceUntil+CritteriaMet
// MARK: -
public extension Scenario.Map.Object.Kind.Interactive.Mutable.Visitable.OnceUntil {
    
    /// A conditionally visitable which is visitable once a quest
    enum CritteriaMet: Model {
        
        /// Crittieria met: Quest of Seershut must have been completed, after
        /// it has been, the seershuts bonus will never again be given to any
        /// subsequent hero visiting it.
        case seershut(Map.Seershut)
        
        /// Critteria met: Have to have spellbook and correct Wisdom level.
        case shrine(Map.Shrine)
    }
    
}
