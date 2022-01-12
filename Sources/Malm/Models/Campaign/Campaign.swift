//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-21.
//

import Foundation
import Common

public struct Campaign: Hashable, CustomDebugStringConvertible {
    public let header: Header
    public let scenarios: [Scenario]
    
    public init(
        header: Header,
        scenarios: [Scenario] = []
    ) {
        self.header = header
        self.scenarios = scenarios
    }
    
    public var debugDescription: String {
        implementMe()
    }
}

public extension Campaign {
    struct Header: Hashable, CustomDebugStringConvertible {
        public let format: Format
        
        /// VCMI comment "CampText.txt's format"
        /// We belive this to be an index to a map name in the CampText.txt file which is located in the archive H3bitmap.lod
        public let indexToMapName: UInt8
        public let name: String
        public let description: String
        public let difficultyChosenByPlayer: Difficulty
        
        ///VCMI comment "CmpMusic.txt, start from 0"
        ///We believe this to be an index to a music file in the CmpMusic.txt file which is located in the archive H3bitmap.lod
        public let indexToMusicFile: UInt8
        public let fileName: String
        
        public var debugDescription: String {
            implementMe()
        }
    }
    
}

public extension Campaign {
    /// Not to be confused with `Map.Format`
    enum Format: UInt8, Hashable, CustomDebugStringConvertible {
        case restorationOfErathia = 4
        case armageddonsBlade
        case shadowOfDeath
        
        public var debugDescription: String {
            implementMe()
        }
    }
}

public extension Campaign {
    
    struct Scenario: Hashable, CustomDebugStringConvertible {
        
        public let id: ID
        /// TODO: Replace `String` with `Malm.Scenario.Summary`?
        public let summary: String
        /// Collection of scenarios that we must have compelted in order to be able to play this one
        public let preConditionedScenarios: Set<ID>
        public let regionColor: RegionColor
        public let difficulty: Difficulty
        public let hasBeenCompleted: Bool
        public let prolog: Prolog?
        public let epilog: Epilog?
        
        
        
        public var debugDescription: String {
            implementMe()
        }
    }
}

public protocol StoryEpisode {
    var videoID: Campaign.Scenario.VideoID { get }
    var musicID: Campaign.Scenario.MusicID { get }
    var tale: String { get }
}

public extension Campaign.Scenario {
    struct Prolog: StoryEpisode, Hashable, Codable {
        public let videoID: VideoID
        public let musicID: MusicID
        public let tale: String
    }
}

public extension Campaign.Scenario {
    struct Epilog: StoryEpisode, Hashable, Codable {
        public let videoID: VideoID
        public let musicID: MusicID
        public let tale: String
    }
}

public extension Campaign.Scenario {
    /// This is the exact content of `CmpMusic.txt` from `h3bitmap.lod`
    enum VideoID: String, Hashable, Codable {
        case good1A = "Good1_a"
        case good1B = "Good1_b"
        case good1C = "Good1_c"
        case evil1A = "Evil1_a"
        case evil1B = "Evil1_b"
        case evil1C = "Evil1_c"
        case neutral1A = "Neutral1_a"
        case neutral1B = "Neutral1_b"
        case neutral1C = "Neutral1_c"
        case good2A = "Good2_a"
        case good2B = "Good2_b"
        case good2C = "Good2_c"
        case good2D = "Good2_d"
        case evil2A = "Evil2_a"
        case evil2ap1 = "Evil2ap1"
        case evil2B = "Evil2_b"
        case evil2C = "Evil2_c"
        case evil2D = "Evil2_d"
        case good3A = "Good3_a"
        case good3B = "Good3_b"
        case good3C = "Good3_c"
        case secretA = "Secret_a"
        case secretB = "Secret_b"
        case secretC = "Secret_c"
        case armageddonsBladeA = "ArmageddonsBlade_a"
        case armageddonsBladeB = "ArmageddonsBlade_b"
        case armageddonsBladeC = "ArmageddonsBlade_c"
        case armageddonsBladeD = "ArmageddonsBlade_d"
        case armageddonsBladeE = "ArmageddonsBlade_e"
        case armageddonsBladeF = "ArmageddonsBlade_f"
        case armageddonsBladeG = "ArmageddonsBlade_g"
        case armageddonsBladeH = "ArmageddonsBlade_h"
        case armageddonsBladeEnd = "ArmageddonsBlade_end"
        case dragonsBloodA = "DragonsBlood_a"
        case dragonsBloodB = "DragonsBlood_b"
        case dragonsBloodC = "DragonsBlood_c"
        case dragonsBloodD = "DragonsBlood_d"
        case dragonsBloodEnd = "DragonsBlood_end"
        case dragonSlayerA = "DragonSlayer_a"
        case dragonSlayerB = "DragonSlayer_b"
        case dragonSlayerC = "DragonSlayer_c"
        case dragonSlayerD = "DragonSlayer_d"
        case dragonSlayerEnd = "DragonSlayer_end"
        case festivalOfLifeA = "FestivalOfLife_a"
        case festivalOfLifeB = "FestivalOfLife_b"
        case festivalOfLifeC = "FestivalOfLife_c"
        case festivalOfLifeD = "FestivalOfLife_d"
        case festivalOfLifeEnd = "FestivalOfLife_end"
        case foolhardyWaywardnessA = "FoolhardyWaywardness_a"
        case foolhardyWaywardnessB = "FoolhardyWaywardness_b"
        case foolhardyWaywardnessC = "FoolhardyWaywardness_c"
        case foolhardyWaywardnessD = "FoolhardyWaywardness_d"
        case foolhardyWaywardnessEnd = "FoolhardyWaywardness_end"
        case playingWithFireA = "PlayingWithFire_a"
        case playingWithFireB = "PlayingWithFire_b"
        case playingWithFireC = "PlayingWithFire_c"
        case playingWithFireEnd = "PlayingWithFire_end"
    }
}

public extension Campaign.Scenario {
    /// This is the exact content of `CmpMusic.txt` from `h3bitmap.lod`
    enum MusicID: String, Hashable, Codable {
        case campaignMusic01 = "CampainMusic01"
        case campaignMusic02 = "CampainMusic02"
        case campaignMusic03 = "CampainMusic03"
        case campaignMusic04 = "CampainMusic04"
        case campaignMusic05 = "CampainMusic05"
        case campaignMusic06 = "CampainMusic06"
        case campaignMusic07 = "CampainMusic07"
        case campaignMusic08 = "CampainMusic08"
        case campaignMusic09 = "CampainMusic09"
        case aiTheme0 = "AiTheme0"
        case aiTheme1 = "AiTheme1"
        case aiTheme2 = "AiTheme2"
        case combat01 = "Combat01"
        case combat02 = "Combat02"
        case combat03 = "Combat03"
        case combat04 = "Combat04"
        case castle = "CstleTown"
        case tower = "TowerTown"
        case rampart = "Rampart"
        case inferno = "InfernoTown"
        case necropolis = "NecroTown"
        case dungeon = "Dungeon"
        case stronghold = "Stronghold"
        case fortress = "FortressTown"
        case conflux = "ElemTown"
        case dirt = "Dirt"
        case sand = "Sand"
        case grass = "Grass"
        case snow = "Snow"
        case swamp = "Swamp"
        case rough = "Rough"
        case underground = "Underground"
        case lava = "Lava"
        case water = "Water"
        case goodTheme = "GoodTheme"
        case neutralTheme = "NeutralTheme"
        case evilTheme = "EvilTheme"
        case secretTheme = "SecretTheme"
        case loopLepr = "LoopLepr"
        case mainMenu = "MainMenu"
        case winScenario = "Win Scenario"
        case campaignMusic10 = "CampainMusic10"
        case bladeABCampaign = "BladeABCampaign"
        case bladeDBCampaign = "BladeDBCampaign"
        case bladeDSCampaign = "BladeDSCampaign"
        case bladeFLCampaign = "BladeFLCampaign"
        case bladeFWCampaign = "BladeFWCampaign"
        case bladePFCampaign = "BladePFCampaign"
    }
    
}

public extension Campaign.Scenario {
    typealias ID = Map.ID
}

public extension Campaign.Scenario {
    enum RegionColor: UInt8, Hashable, Codable {
        case red, blue, green
    }
}
