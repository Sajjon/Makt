//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-21.
//

import Foundation
import Common

public struct Campaign: Hashable, CustomDebugStringConvertible {
//    public let header: Header
    public let scenarios: [Scenario]
    
    public init() {}
    
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
        public
        
        public var debugDescription: String {
            implementMe()
        }
        
    }
    
}


public extension Campaign.Scenario {
    typealias ID = Map.ID
}
