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
        
        public let mainTown: MainTown?
        
    }
    
    struct Additional: Hashable {
        
        public enum StartingHeroType: Hashable {
            case random
            case specific(Map.InformationAboutPlayers.StartingHero)
        }
        
        public struct StartingTown: Hashable {
            public let position: Position
            public let faction: Faction
        }
        
        public let startingHero: StartingHeroType?
        public let startingTown: StartingTown?
    }
}


public extension Map.InformationAboutPlayers.PlayerInfo.Basic {
    struct MainTown: Hashable {
        let position: Position
        let generateHeroInThisTown: Bool
    }
}
//
//public extension Map.PlayersInfo.PlayerInfoBasic {
//    var isPlayableByAI: Bool { aiTactic != nil }
//    var hasMainTown: Bool { mainTown != nil }
//}
//
//extension Map.PlayersInfo: CustomDebugStringConvertible {
//    public var debugDescription: String {
//        playersBasicInfo.map({ $0.debugDescription }).joined(separator: "\n\n")
//    }
//}
//
//extension Map.PlayersInfo.PlayerInfo: CustomDebugStringConvertible {
//
//    public var debugDescription: String {
//        let aiTacticString = aiTactic.map({ "ai tactic: \($0)" }) ?? ""
//        return """
//        ************************************************************
//        "color: \(color)",
//        isPlayableByHuman?: \(isPlayableByHuman)
//        faction choices: \(allowedFactionsForThisPlayer.map({ String(describing: $0) }))
//        \(aiTacticString)
//        hasMainTown?: \(self.hasMainTown)
//        hasRandonHero?: \(self.hasRandomHero)
//        heroSeeds: \(String(describing: self.heroSeeds))
//        customMainHero: \(String(describing: self.customMainHero))
//        ************************************************************
//        """
//    }
//}
