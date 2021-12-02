//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public extension Scenario.Info {
    
    /// Summary of this playable scenario
    struct Summary: Model, Identifiable {
        public let id: Map.ID
        public let version: Version
        public let name: String
        public let size: Size
        public let difficulty: Difficulty
        public let numberOfPlayersThatCanBeHuman: Int
        public let numberOfPlayers: Int
        public let victoryLossConditions: Map.VictoryLossConditions
    }
}
