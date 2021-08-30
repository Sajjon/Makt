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


public protocol PlayerInfoDetails {
    var playableFactions: [Faction] { get }
    var isPlayableByHuman: Bool { get }
    var isPlayableByAI: Bool { get }
}

extension PlayerInfoDetails {
    

    var isPlayableBothByHumanAndAI: Bool { isPlayableByHuman && isPlayableByAI }
    var isPlayableOnlyByAI: Bool { !isPlayableByHuman && isPlayableByAI }
}


public extension Map.InformationAboutPlayers {
    struct PlayerInfo: Hashable, PlayerInfoDetails {
        public let color: PlayerColor
        private let info: PlayerInfoVersioned
        
        public init (color: PlayerColor, info: PlayerInfoVersioned) {
            self.color = color
            self.info = info
        }
    }

}

public extension Map.InformationAboutPlayers.PlayerInfo {
    var playableFactions: [Faction] {
        info.playableFactions
    }
    
    var isPlayableByHuman: Bool { info.isPlayableByHuman }
    var isPlayableByAI: Bool { info.isPlayableByAI }
}


public extension Map.InformationAboutPlayers {
    enum PlayerInfoVersioned: PlayerInfoDetails, Hashable {
        case roe(ROE)
        case ab(AB)
        case sod(SOD)
    }
}

public extension Map.InformationAboutPlayers.PlayerInfoVersioned {
    var playableFactions: [Faction] {
        switch self {
        case .ab: fatalError("todo")
        case .sod: fatalError("todo")
        case .roe(let roe):
            return roe.playableFactions
        }
    }
    
    var isPlayableByHuman: Bool {
        switch self {
        case .ab: fatalError("todo")
        case .sod: fatalError("todo")
        case .roe(let roe):
            return roe.isPlayableByHuman
        }
    }
    var isPlayableByAI: Bool {
        switch self {
        case .ab: fatalError("todo")
        case .sod: fatalError("todo")
        case .roe(let roe):
            return roe.isPlayableByAI
        }}
}

// MARK: ROE
public extension Map.InformationAboutPlayers {
    struct ROE: PlayerInfoDetails, Hashable {
        let basic: Basic
        let extra: Extra
    }
}

public extension Map.InformationAboutPlayers.ROE {
    
    struct Basic: Hashable, PlayerInfoDetails {

        
        public let isPlayableByHuman: Bool
        public let isPlayableByAI: Bool
        public let behavior: AITactic
        
        // ROE - no allowed_alignments uint here
        
        /// bitfield
        public let playableFactions: [Faction]
        
        // ROE - no town_conflux uint here
        
        public let unknown1: UInt8
        public let hasMainTown: Bool
    }
    
    
    enum Extra: Hashable {
        case `default`(Default)
        case withTown(WithTown)
        case withHero(WithHero)
        case withTownAndHero(WithTownAndHero)
    }
}

public extension Map.InformationAboutPlayers.ROE.Extra {
    
    /// Seen in The Mandate of Heaven (ROE)
    struct Default: Hashable {
        let startingHeroIsRandom: Bool

        /// MUST be 0xFF for this struct
        let startingHeroID: UInt8
        
        init(
            startingHeroIsRandom: Bool,
            startingHeroID: UInt8
        ) {
            precondition(startingHeroID == 0xff, "startingHeroID MUST be 0xFF for this struct")
            self.startingHeroIsRandom = startingHeroIsRandom
            self.startingHeroID = startingHeroID
        }
        
    }
    
    /// Seen in The Mandate of Heaven (ROE)
    struct WithTown: Hashable {
        
            // ROE - no starting_town_create_hero uint here
            // ROE - no starting_town_type uint here
        
        let startingTownPosition: Position
        let startingHeroIsRandom: Bool
        
        /// MUST be 0xFF for this struct
        let startingHeroID: UInt8
        
        
        init(
            startingTownPosition: Position,
            startingHeroIsRandom: Bool,
            startingHeroID: UInt8
        ) {
            precondition(startingHeroID == 0xff, "startingHeroID MUST be 0xFF for this struct")
            self.startingTownPosition = startingTownPosition
            self.startingHeroIsRandom = startingHeroIsRandom
            self.startingHeroID = startingHeroID
        }
    }
    
    /// Seen in The Mandate of Heaven (ROE)
    struct WithHero: Hashable {
        
        let startingHeroIsRandom: Bool
        
        /// CANNOT be 0xFF for this struct
        let startingHeroID: UInt8
        
        let startingHeroFace: UInt8
        
        let startingHeroName: String?
        
        
        init(
            startingHeroIsRandom: Bool,
            startingHeroID: UInt8,
            startingHeroFace: UInt8,
            startingHeroName: String?
        ) {
            precondition(startingHeroID != 0xff, "startingHeroID CANNOT be 0xFF for this struct")
            self.startingHeroIsRandom = startingHeroIsRandom
            self.startingHeroID = startingHeroID
            self.startingHeroFace = startingHeroFace
            self.startingHeroName = startingHeroName
        }
    }
    
    struct WithTownAndHero: Hashable {
        // ROE - no starting_town_create_hero uint here
        // ROE - no starting_town_type uint here
        let startingTownPosition: Position
        
        let startingHeroIsRandom: Bool
        
        /// CANNOT be 0xFF for this struct
        let startingHeroID: UInt8

        let startingHeroFace: UInt8
        let startingHeroName: String?
        
        init(
            startingTownPosition: Position,
            startingHeroIsRandom: Bool,
            startingHeroID: UInt8,
            startingHeroFace: UInt8,
            startingHeroName: String?
        ) {
            precondition(startingHeroID != 0xff, "startingHeroID CANNOT be 0xFF for this struct")
            self.startingTownPosition = startingTownPosition
            self.startingHeroIsRandom = startingHeroIsRandom
            self.startingHeroID = startingHeroID
            self.startingHeroFace = startingHeroFace
            self.startingHeroName = startingHeroName
        }
    }
}

public extension Map.InformationAboutPlayers.ROE {
    var playableFactions: [Faction] {
        basic.playableFactions
    }
    var isPlayableByHuman: Bool {
        basic.isPlayableByHuman
    }
    var isPlayableByAI: Bool {
        basic.isPlayableByAI
    }
}


// MARK: AB
public extension Map.InformationAboutPlayers {
    struct AB: PlayerInfoDetails, Hashable {
        let basic: Basic
        let extra: ExtraABSOD
    }
}



public extension Map.InformationAboutPlayers.AB {
    
    struct Basic: Hashable, PlayerInfoDetails {

        
        public let isPlayableByHuman: Bool
        public let isPlayableByAI: Bool
        public let behavior: AITactic
        
        // AB - no allowed_alignments uint here
        
        /// bitfield
        public let playableFactions: [Faction]
        public let isConfluxAllowed: Bool
        public let unknown1: UInt8 // "Whether the player owns Random Town" ??
        public let hasMainTown: Bool
        
    }
 
}

public extension Map.InformationAboutPlayers {
       enum ExtraABSOD: Hashable {
        case `default`(Default)
        case withTown(WithTown)
        case withHero(WithHero)
        case withTownAndHero(WithTownAndHero)
    }
}

public extension Map.InformationAboutPlayers.ExtraABSOD {
    
    /// Seen in War of the Mighty, Arrogance (AB, SOD)
    struct Default: Hashable {
        let startingHeroIsRandom: Bool

        /// MUST be 0xFF for this struct
        let startingHeroID: UInt8
        let startingHeroFace: UInt8

        let startingHeroName: String
        
        init(
            startingHeroIsRandom: Bool,
            startingHeroID: UInt8,
            startingHeroFace: UInt8,
            startingHeroName: String
        ) {
            precondition(startingHeroID == 0xff, "startingHeroID MUST be 0xFF for this struct")
            self.startingHeroIsRandom = startingHeroIsRandom
            self.startingHeroID = startingHeroID
            self.startingHeroFace = startingHeroFace
            self.startingHeroName = startingHeroName
        }
        
    }
    
    /// Seen in War of the Mighty, Arrogance (AB, SOD)
    struct WithTown: Hashable {
        let createHeroAtStartingTown: Bool
        let startingTownFaction: Faction
        
        let startingTownPosition: Position
        let startingHeroIsRandom: Bool
        
        /// MUST be 0xFF for this struct
        let startingHeroID: UInt8
        
        init(
            createHeroAtStartingTown: Bool,
            startingTownFaction: Faction,
            startingTownPosition: Position,
            startingHeroIsRandom: Bool,
            startingHeroID: UInt8
        ) {
            precondition(startingHeroID == 0xff, "startingHeroID MUST be 0xFF for this struct")
            self.createHeroAtStartingTown = createHeroAtStartingTown
            self.startingTownFaction = startingTownFaction
            self.startingTownPosition = startingTownPosition
            self.startingHeroIsRandom = startingHeroIsRandom
            self.startingHeroID = startingHeroID
        }
    }
    
    /// Seen in Pandora's Box (SOD)
    struct WithHero: Hashable {
        
        let startingHeroIsRandom: Bool
        
        /// CANNOT be 0xFF for this struct
        let startingHeroID: UInt8
        
        let startingHeroFace: UInt8
        
        let startingHeroName: String
        
        
        init(
            startingHeroIsRandom: Bool,
            startingHeroID: UInt8,
            startingHeroFace: UInt8,
            startingHeroName: String
        ) {
            precondition(startingHeroID != 0xff, "startingHeroID CANNOT be 0xFF for this struct")
            self.startingHeroIsRandom = startingHeroIsRandom
            self.startingHeroID = startingHeroID
            self.startingHeroFace = startingHeroFace
            self.startingHeroName = startingHeroName
        }
    }
    
    struct WithTownAndHero: Hashable {
           let createHeroAtStartingTown: Bool
        let startingTownFaction: Faction
        
        let startingTownPosition: Position
        let startingHeroIsRandom: Bool
        
        /// CANNOT be 0xFF for this struct
        let startingHeroID: UInt8

        let startingHeroFace: UInt8

        let startingHeroName: String
        
        
         init(
            createHeroAtStartingTown: Bool,
            startingTownFaction: Faction,
            startingTownPosition: Position,
            startingHeroIsRandom: Bool,
            startingHeroID: UInt8,
            startingHeroFace: UInt8,
            startingHeroName: String
        ) {
            precondition(startingHeroID != 0xff, "startingHeroID CANNOT be 0xFF for this struct")
            self.createHeroAtStartingTown = createHeroAtStartingTown
            self.startingTownFaction = startingTownFaction
            self.startingTownPosition = startingTownPosition
            self.startingHeroIsRandom = startingHeroIsRandom
            self.startingHeroID = startingHeroID
            self.startingHeroFace = startingHeroFace
            self.startingHeroName = startingHeroName
        }
    }
}








public extension Map.InformationAboutPlayers.AB {
    var playableFactions: [Faction] {
        fatalError()
    }
    
    var isPlayableByHuman: Bool {
        fatalError()
    }
    var isPlayableByAI: Bool {
        fatalError()
    }
}


















// MARK: SOD
public extension Map.InformationAboutPlayers {
    struct SOD: PlayerInfoDetails, Hashable {
    }
}



public extension Map.InformationAboutPlayers.SOD {
    var playableFactions: [Faction] {
        fatalError()
    }
    var isPlayableByHuman: Bool {
        fatalError()
    }
    var isPlayableByAI: Bool {
        fatalError()
    }
}

