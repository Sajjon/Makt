//
//  Map+PlayersInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Map {
    struct InformationAboutPlayers: Equatable {
        public let players: [PlayerInfo]
    }
}

public extension Map.InformationAboutPlayers {
    struct PlayerInfo: Hashable {
        public let basic: Basic
        public let additional: Additional
    }
}

public extension Map.InformationAboutPlayers.PlayerInfo {
    
    var color: PlayerColor { basic.color }

    struct Basic: Hashable {
        public let color: PlayerColor
        public let isPlayableByHuman: Bool
        public let isPlayableByAI: Bool
        public let aiTactic: AITactic
        
        /// SOD feature only
        public let allowedAlignments: [Alignment]
        public let playableFactions: [Faction]
    }
    
    struct Additional: Hashable {
        
        public enum StartingHeroType: Hashable {
            case random
            case specific(Map.InformationAboutPlayers.StartingHero)
        }
        
//        public struct StartingTown: Hashable {
//            public let position: Position
//            public let faction: Faction
//        }
        
//        public let startingTown: StartingTown?
        
        public let mainTown: MainTown?
        public let startingHero: StartingHeroType?
    }
}


public extension Map.InformationAboutPlayers.PlayerInfo.Additional {
    struct MainTown: Hashable {
        let position: Position
        let generateHeroInThisTown: Bool
//        let generateHeroClass: Hero.Class?
        let generateHeroID: Hero.ID?
    }
}
//
//extension Map.PlayersInfo.PlayerInfo: CustomDebugStringConvertible {
//
//    public var debugDescription: String {
//        let aiTacticString = aiTactic.map({ "ai tactic: \($0)" }) ?? ""
//        return """
//        ************************************************************
//        "color: \(color)",
//        isPlayableByHuman?: \(isPlayableByHuman)
//        faction choices: \(playableFactions.map({ String(describing: $0) }))
//        \(aiTacticString)
//        hasMainTown?: \(self.hasMainTown)
//        hasRandonHero?: \(self.hasRandomHero)
//        heroSeeds: \(String(describing: self.heroSeeds))
//        customMainHero: \(String(describing: self.customMainHero))
//        ************************************************************
//        """
//    }
//}
