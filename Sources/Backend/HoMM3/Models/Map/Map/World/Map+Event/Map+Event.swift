//
//  Map+Event.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    
    /// A global event that occurs at a certain time.
    /// Not to be confused with geo event, that is trigger when a player walks on a certain tile with a hero.
    struct TimedEvent: Hashable, CustomDebugStringConvertible {
        
        public struct Occurrences: Hashable {
            public enum Subsequent: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
                static let neverRawValue = 0
                static let never: Self? = nil
                case everyDay = 1
                case everyTwoDays = 2
                case everyThreeDays = 3
                case everyFourDays = 4
                case everyFiveDays = 5
                case everySixDays = 6
                case everySevenDays = 7
                case every14Days = 14
                case every21Days = 21
                case every28Days = 28
                
                public var debugDescription: String {
                    switch self {
                    case .everyDay: return "everyDay"
                    case .everyTwoDays: return "everyTwoDays"
                    case .everyThreeDays: return "everyThreeDays"
                    case .everyFourDays: return "everyFourDays"
                    case .everyFiveDays: return "everyFiveDays"
                    case .everySixDays: return "everySixDays"
                    case .everySevenDays: return "everySevenDays"
                    case .every14Days: return "every14Days"
                    case .every21Days: return "every21Days"
                    case .every28Days: return "every28Days"
                    }
                }
            }
            
            internal let first: UInt16
            internal let subsequent: Subsequent?
        }
        
        public let name: String?
        public let message: String?
        
        /// Resources to be gained OR taken
        public let resources: Resources?
        
        public let occurrences: Occurrences
        public let availability: Availability
        
        public init(
            name: String? = nil,
            message: String? = nil,

            firstOccurence: UInt16,
            subsequentOccurence: Occurrences.Subsequent? = nil,
            
            affectedPlayers: [Player] = [],
            appliesToHumanPlayers: Bool,
            appliesToComputerPlayers: Bool,
            resources: Resources? = nil
        ) {
            self.name = name
            self.occurrences = .init(first: firstOccurence, subsequent: subsequentOccurence)
        
            self.message = message
            self.resources = resources
            
            self.availability = .init(
                affectedPlayers: affectedPlayers,
                appliesToHumanPlayers: appliesToHumanPlayers,
                appliesToComputerPlayers: appliesToComputerPlayers
            )
        }
        
        // MARK: Availability
        public struct Availability: Hashable, CustomDebugStringConvertible {
            
            /// MapEditor: "Players to which event applies"
            public let affectedPlayers: [Player]
            
            /// MapEditor: "Apply event to computer players"
            public let appliesToHumanPlayers: Bool
            
            /// MapEditor: "Apply event to computer players"
            public let appliesToComputerPlayers: Bool
            
            public init(
                affectedPlayers: [Player],
                appliesToHumanPlayers: Bool,
                appliesToComputerPlayers: Bool
            ) {
                self.affectedPlayers = affectedPlayers
                self.appliesToHumanPlayers = appliesToHumanPlayers
                self.appliesToComputerPlayers = appliesToComputerPlayers
            }
            
            public var debugDescription: String {
                """
                affectedPlayers: \(affectedPlayers)
                appliesToHumanPlayers: \(appliesToHumanPlayers)
                appliesToComputerPlayers: \(appliesToComputerPlayers)
                """
            }
        }
        
        public var debugDescription: String {
//            public let name: String?
//            public let message: String?
//
//            /// Resources to be gained OR taken
//            public let resources: Resources?
//
//            public let occurrences: Occurrences
//            public let availability: Availability
            """
            name: \(name)
            message: \(message)
            resources: \(resources)
            occurrences: \(occurrences)
            availability: \(availability)
            """
        }
    }
    
}

public extension Map {
    
    /// An event that is positioned at a certain place and that will be trigger when you walk on that position with a hero.
    /// Not to be confused with time based global events (that has no location and is not triggered by the player).
    struct GeoEvent: Hashable, CustomDebugStringConvertible {
        
        public let message: String?
        
        public let guardians: CreatureStacks?
        public let contents: Bounty?
        
        internal let cancelEventAfterFirstVisit: Bool
        internal let availability: Availability
        
        public init(
            message: String? = nil,
            guardians: CreatureStacks? = nil,
            contents: Bounty? = nil,
            
            playersAllowedToTriggerThisEvent: [Player] = [],
            canBeTriggeredByComputerOpponent: Bool = false,
            cancelEventAfterFirstVisit: Bool = true
        ) {
            self.message = message
            self.guardians = guardians
            self.contents = contents
            
            self.availability = .init(
                playersAllowedToTriggerEvent: playersAllowedToTriggerThisEvent,
                canBeTriggeredByComputerOpponent: canBeTriggeredByComputerOpponent
            )
            self.cancelEventAfterFirstVisit = cancelEventAfterFirstVisit
        }
        
        public var debugDescription: String {
           [
            message.map { "message: \($0)" } ?? nil,
            guardians.map { "guardians: \($0)" } ?? nil,
            contents.map { "contents: \($0)" } ?? nil,
            "cancelEventAfterFirstVisit: \(cancelEventAfterFirstVisit)",
            "availability: \(availability)",
           ].compactMap({ $0 }).joined(separator: "\n")
        }
    }
    
    // MARK: Availability
    struct Availability: Hashable, CustomDebugStringConvertible {
        
        /// MapEditor: "Players allowed to trigger event"
        internal let playersAllowedToTriggerEvent: [Player]
        
        /// MapEditor: "Allow computer opponent to trigger event"
        internal let canBeTriggeredByComputerOpponent: Bool
        
        public init(
            playersAllowedToTriggerEvent: [Player],
            canBeTriggeredByComputerOpponent: Bool
        ) {
            self.playersAllowedToTriggerEvent = playersAllowedToTriggerEvent
            self.canBeTriggeredByComputerOpponent = canBeTriggeredByComputerOpponent
        }
        
        public var debugDescription: String {
            """
            playersAllowedToTriggerEvent: \(playersAllowedToTriggerEvent)
            canBeTriggeredByComputerOpponent: \(canBeTriggeredByComputerOpponent)
            """
        }
    }

}


