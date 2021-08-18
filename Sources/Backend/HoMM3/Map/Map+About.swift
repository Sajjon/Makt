//
//  Map.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map {
    struct About: Equatable, Identifiable {
        public let summary: Summary
        public let playersInfo: PlayersInfo
        public let victoryLossConditions: VictoryLossConditions
        public let teamInfo: TeamInfo
        public let allowedHeroes: AllowedHeroes
    }
}

// MARK: Identifiable
public extension Map.About {
    typealias ID = Map.ID
    var id: ID { summary.id }
}

