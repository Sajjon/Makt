//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation

public extension Scenario {
    
    /// All information relating to this scenario, e.g. name, description, map
    /// size, teams, player info and win/loss conditions.
    struct Info: Model {
        public let summary: Summary
        public let playersInfo: PlayersInfo
        public let teamsInfo: TeamsInfo
    }
}
