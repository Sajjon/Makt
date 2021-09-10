//
//  Map+PlayersInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

// MARK: InformationAboutPlayers
public extension Map {
    struct InformationAboutPlayers: Hashable {
        public let players: [PlayerInfo]
        
        public init(players: [PlayerInfo]) {
            self.players = players
        }
    }
}

public extension Map.InformationAboutPlayers {
    var availablePlayers: [Player] { players.map { $0.player } }
}

// MARK: PlayerInfo
public extension Map.InformationAboutPlayers {
    struct PlayerInfo: Hashable, CustomDebugStringConvertible {

        public let player: Player  // Not parsed, but set during for-loop

        public let isPlayableByHuman: Bool
        public let behaviour: Behaviour? // set if is playable by AI

        /// SOD only
        public let allowedAlignments: AllowedAlignment?

        public let townTypes: [Faction] // "townTypes"
        
        public let mainTown: MainTown? // if `"hasMainTown"`
        public let hasRandomHero: Bool
        
        public let mainHero: MainHero?

        /// when format > .roe && startingHero.heroID != nil
        public let additionalInfo: AdditionalInfo?
        
        public init(
            player: Player,
            isPlayableByHuman: Bool,
            behaviour: Behaviour? = nil,
            allowedAlignments: AllowedAlignment? = nil,
            townTypes: [Faction],
            mainTown: MainTown? = nil,
            hasRandomHero: Bool,
            mainHero: MainHero? = nil,
            additionalInfo: AdditionalInfo? = nil
        ) {
            self.player = player
            self.isPlayableByHuman = isPlayableByHuman
            self.behaviour = behaviour
            self.allowedAlignments = allowedAlignments
            self.townTypes = townTypes
            self.mainTown = mainTown
            self.hasRandomHero = hasRandomHero
            self.mainHero = mainHero
            self.additionalInfo = additionalInfo
        }
    }
}

// MARK: CustomDebugStringConvertible
public extension Map.InformationAboutPlayers.PlayerInfo {
    
    var debugDescription: String {
        let optionalStrings: [String?] = [
            "player: \(player)",
            "isPlayableByHuman: \(isPlayableByHuman)",
            behaviour.map { "behaviour: \($0)" },
            allowedAlignments.map { "allowedAlignments: \($0)" },
            "townTypes: \(townTypes)",
            mainTown.map { "mainTown: \($0)" },
            "hasRandomHero: \(hasRandomHero)",
            mainHero.map { "mainHero: \($0)" },
            additionalInfo.map { "additionalInfo: \($0)" }
        ]
        
        return optionalStrings.filterNils().joined(separator: "\n")
    }
}

// MARK: AllowedAlignment
public extension Map.InformationAboutPlayers.PlayerInfo {
    
    /// SOD only
    enum AllowedAlignment: Hashable {
        case random
        case followingFactions([Faction])
    }
}

// MARK: MainTown
public extension Map.InformationAboutPlayers.PlayerInfo {
    struct MainTown: Hashable {
        public let position: Position
        public let generateHeroInThisTown: Bool /// when format > .roe

        public let faction: Faction? /// when format > .roe
        
        public init(
            position: Position,
            
            /// when format > .roe
            generateHeroInThisTown: Bool,
            
            /// when format > .roe
            faction: Faction? = nil
        ) {
            self.position = position
            self.generateHeroInThisTown = generateHeroInThisTown
            self.faction = faction
        }
        
    }
}

// MARK: MainHero
public extension Map.InformationAboutPlayers.PlayerInfo {
    
    struct MainHero: Hashable {
        public let heroID: Hero.ID?
        public let portraitId: Hero.ID?
        public let name: String?
        
        public init(
            heroID: Hero.ID?,
            portraitId: Hero.ID?,
            name: String?
        ) {
            precondition(!(heroID == nil && portraitId == nil && name == nil), "All properites of this struct are nil, seems like a weird state.")
            self.heroID = heroID
            self.portraitId = portraitId
            self.name = name
        }
    }
}

// MARK: AdditionalInfo
public extension Map.InformationAboutPlayers.PlayerInfo {

    /// when format > .roe && startingHero.heroID != nil
    struct AdditionalInfo: Hashable {
        public let heroes: [SimpleHero] // of UInt32 `heroesCount` just read before
        
        public init(heroes: [SimpleHero]) {
            self.heroes = heroes
        }
    }
}

// MARK: Simple Hero
public extension Map.InformationAboutPlayers.PlayerInfo.AdditionalInfo {
    struct SimpleHero: Hashable {
        public let portraitId: Hero.ID
        public let name: String
        
        public init(
            portraitId: Hero.ID,
            name: String
        ) {
            self.portraitId = portraitId
            self.name = name
        }
    }
}

// MARK: Public
public extension Map.InformationAboutPlayers.PlayerInfo {
    var isPlayableByAI: Bool { behaviour != nil }
    var isPlayableBothByHumanAndAI: Bool { isPlayableByHuman && isPlayableByAI }
    var isPlayableOnlyByAI: Bool { !isPlayableByHuman && isPlayableByAI }
    var isPlayableOnlyByHuman: Bool { isPlayableByHuman && !isPlayableByAI }
}
