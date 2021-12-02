//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public extension Scenario.Map.Object.Kind.Interactive.Mutable.Visitable {
    
    /// A once per hero visitable object which bonus will not accumulate to the
    /// next visit nor at a later point in time, but which will benefit every
    /// hero, disregarding if it has already been visited. e.g.
    /// `garden Of Relevation`
    enum OncePerHero: Model {
        case witchHut(Map.WitchHut)
        case gardenOfRelevation(Scenario.Map.GardenOfRelevation)
    }
}
