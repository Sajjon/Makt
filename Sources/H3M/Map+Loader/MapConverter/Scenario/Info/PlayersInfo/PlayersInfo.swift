//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public extension Scenario.Info {
    
    /// All information about players, teams etc.
    struct PlayersInfo: Model {
        public let players: [Player]
    }
}
