//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation

// MARK: Visitable
public extension Scenario.Map.Object.Kind.Interactive.Mutable {
    enum Visitable: Model {
        
        /// E.g. `Lean to`
        case oncePerGame(OncePerGame)
        
        /// E.g. `water wheel`, `stables`
        case oncePerPeriod(OncePerPeriod)
        
        /// `Fountain of fortune`, `Faerie Ring`, `Fountain of Youth`
        case onceUntil(OnceUntil)
        
        /// E.g. `Garden of relevation`
        case oncePerHero(OncePerHero)
    }
}
