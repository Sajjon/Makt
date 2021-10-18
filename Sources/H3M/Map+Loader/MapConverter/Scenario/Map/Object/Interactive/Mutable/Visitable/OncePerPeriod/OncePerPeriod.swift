//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation


// MARK: - Visitable + OncePerPeriod
// MARK: -
public extension Scenario.Map.Object.Interactive.Mutable.Visitable {
    
    /// A periodically (game date) visitable object.
    enum OncePerPeriod: Model {
        
        /// A once per period `first come first served` vistiable object, e.g. `Water wheel`
        case firstVisitorOnly(FirstVisitorOnly)
        
        /// A once per period *per hero* visitable object beneficial to a hero, `stables`
        case perHero(PerHero)
    }
}

// MARK: - OncePerPeriod + FirstVisitorOnly
// MARK: -
public extension Scenario.Map.Object.Interactive.Mutable.Visitable.OncePerPeriod {
    
    /// A periodically visitable object which will only benefit the first visiting
    /// hero during the given period.
    enum FirstVisitorOnly: Model {
        case waterWheel(Scenario.Map.WaterWheel)
    }
}

// MARK: - OncePerPeriod + PerHero
// MARK: -
public extension Scenario.Map.Object.Interactive.Mutable.Visitable.OncePerPeriod {

    /// A periodically visitable object which will benefit every hero once per
    /// period, disregarding if it has already been visited by another hero this
    /// period, e.g. `stables`
    enum PerHero: Model {
        case stables(Scenario.Map.Stables)
    }
}
