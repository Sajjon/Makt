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

extension Map.PlayersInfo: CustomDebugStringConvertible {
    public var debugDescription: String {
        players.map({ $0.debugDescription }).joined(separator: "\n\n")
    }
}

extension Map.PlayersInfo.PlayerInfo: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        let includeColor = true
        let colorString = includeColor ? "color: \(color)" : ""
        let aiTacticString = aiTactic.map({ "ai tactic: \($0)" }) ?? ""
        return """
        ************************************************************
        \(colorString)
        isPlayableByHuman?: \(isPlayableByHuman)
        faction choices: \(allowedFactionsForThisPlayer.map({ String(describing: $0) }))
        \(aiTacticString)
        hasMainTown?: \(self.hasMainTown)
        hasRandonHero?: \(self.hasRandomHero)
        heroSeeds: \(self.heroSeeds)
        customMainHero: \(self.customMainHero)
        ************************************************************
        """
    }
}
