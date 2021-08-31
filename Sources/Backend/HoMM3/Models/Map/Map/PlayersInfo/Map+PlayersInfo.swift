//
//  Map+PlayersInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Map {
    struct InformationAboutPlayers: Hashable {
        public let players: [PlayerInfo]
    }
}

public extension Map.InformationAboutPlayers {
    struct PlayerInfo: Hashable {

       
        public let color: PlayerColor  // Not parsed, but set during for-loop

        public let isPlayableByHuman: Bool
        public let aiTactic: AITactic? // set if is playable by AI

        /// SOD only
        public let allowedAlignments: UInt8?

        public let playableFactions: [Faction] // "townTypes"
//        public let townConflux: Bool // ABSOD (removed because will be merged into playableFactions)
        
        public let mainTown: MainTown? // if `"hasMainTown"`
        public let hasRandomHero: Bool
        
        public let mainHero: MainHero?

        /// when format > .roe && startingHero.heroID != nil
        public let additionalInfo: AdditionalInfo?
    }
}

public extension Map.InformationAboutPlayers.PlayerInfo {
    
    struct MainHero: Hashable {
        let heroID: Hero.ID?
        let portraitId: Hero.ID?
        let name: String?
    }
    
    struct MainTown: Hashable {
        let generateHeroInThisTown: Bool /// when format > .roe
        let faction: Faction? /// when format > .roe
        let position: Position
    }
    
    /// when format > .roe && startingHero.heroID != nil
    struct AdditionalInfo: Hashable {
        let heroes: [SimpleHero] // of UInt32 `heroesCount` just read before
    }
    
}

public extension Map.InformationAboutPlayers.PlayerInfo.AdditionalInfo {
    struct SimpleHero: Hashable {
//        let heroID: Hero.ID
        let faceID: Hero.ID
        let name: String
    }
}
