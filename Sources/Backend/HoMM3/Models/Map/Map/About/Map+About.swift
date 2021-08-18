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
        
        public init(
            summary: Summary,
            playersInfo: PlayersInfo,
            victoryLossConditions: VictoryLossConditions,
            teamInfo: TeamInfo,
            allowedHeroes: AllowedHeroes
        ) {
            
            precondition(
                (teamInfo.teams?.count ?? 0) <= playersInfo.players.count,
                "Cannot have more teams than players"
            )
            
            func fitsInMap(_ position: Position) {
                precondition(position.fitsInMapDescribed(by: summary), "A position must fit inside the map.")
            }
            
            playersInfo.players.compactMap({ $0.mainTown }).map({ $0.position }).forEach(fitsInMap)
            victoryLossConditions.positions.forEach(fitsInMap)
            
            self.summary = summary
            self.playersInfo = playersInfo
            self.victoryLossConditions = victoryLossConditions
            self.teamInfo = teamInfo
            self.allowedHeroes = allowedHeroes
        }
    }
}

// MARK: Identifiable
public extension Map.About {
    typealias ID = Map.ID
    var id: ID { summary.id }
}

