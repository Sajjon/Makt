//
//  Map+PlayersInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Map {
    struct PlayersInfo: Equatable {
        public let players: [PlayerInfo]
        public struct PlayerInfo: Equatable {
            public let color: PlayerColor
            public let isPlayableByHuman: Bool
            public let aiTactic: AITactic?
            
            public let allowedFactionsForThisPlayer: [Faction]
            public let isRandomFaction: Bool
            
            public let generateHero: Bool
            public let mainTown: MainTown?
            public let hasRandomHero: Bool
            public let customMainHero: Hero.Custom?
            public let heroSeeds: [Hero.Seed]?
            
            public struct MainTown: Equatable {
                let position: Position
                let generateHeroInThisTown: Bool
            }
        }
        
    }
}

public extension Map.PlayersInfo.PlayerInfo {
    var isPlayableByAI: Bool { aiTactic != nil }
    var hasMainTown: Bool { mainTown != nil }
}
