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
        public var availablePlayers: [Player] { players.map { $0.player } } 
    }
}

public extension Map.InformationAboutPlayers {
    struct PlayerInfo: Hashable {

       
        public let player: Player  // Not parsed, but set during for-loop

        public let isPlayableByHuman: Bool
        public let behaviour: Behaviour? // set if is playable by AI

        /// SOD only
        public enum AllowedAlignment: Hashable {
            case random
            case followingFactions([Faction])
        }
        /// SOD only
        public let allowedAlignments: AllowedAlignment?

        public let townTypes: [Faction] // "townTypes"
//        public let townConflux: Bool // ABSOD (removed because will be merged into townTypes)
        
        public let mainTown: MainTown? // if `"hasMainTown"`
        public let hasRandomHero: Bool
        
        public let mainHero: MainHero?

        /// when format > .roe && startingHero.heroID != nil
        public let additionalInfo: AdditionalInfo?
    }
}



public extension Map.InformationAboutPlayers.PlayerInfo {
    var isPlayableByAI: Bool { behaviour != nil }
    var isPlayableBothByHumanAndAI: Bool { isPlayableByHuman && isPlayableByAI }
    var isPlayableOnlyByAI: Bool { !isPlayableByHuman && isPlayableByAI }
    var isPlayableOnlyByHuman: Bool { isPlayableByHuman && !isPlayableByAI }
    
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
