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
    struct TimedEvent: Hashable {
        
        public let name: String?
 
        public let message: String?
        
        /// Resources to be gained OR taken
        public let resources: Resources?
        
        public let occurrences: Occurrences
        
        public struct Occurrences: Hashable {
            public enum Subsequent: UInt8, Hashable, CaseIterable {
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
            }
            
            internal let first: UInt16
            internal let subsequent: Subsequent?
        }
        
 
        
        internal let availability: Availability
        
        public init(
            name: String? = nil,
            message: String? = nil,

            firstOccurence: UInt16,
            subsequentOccurence: Occurrences.Subsequent? = nil,
            
            affectedPlayers: [PlayerColor] = [],
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
        struct Availability: Hashable {
            
            /// MapEditor: "Players to which event applies"
            internal let affectedPlayers: [PlayerColor]
            
            /// MapEditor: "Apply event to computer players"
            internal let appliesToHumanPlayers: Bool
            
            /// MapEditor: "Apply event to computer players"
            internal let appliesToComputerPlayers: Bool
            
            public init(
                affectedPlayers: [PlayerColor],
                appliesToHumanPlayers: Bool,
                appliesToComputerPlayers: Bool
            ) {
                self.affectedPlayers = affectedPlayers
                self.appliesToHumanPlayers = appliesToHumanPlayers
                self.appliesToComputerPlayers = appliesToComputerPlayers
            }
        }
    }
}

public extension Map {
    
    /// An event that is positioned at a certain place and that will be trigger when you walk on that position with a hero.
    /// Not to be confused with time based global events (that has no location and is not triggered by the player).
    struct GeoEvent: Hashable {
        
        public let message: String?
        
        public let guardians: CreatureStacks?
        public let contents: Bounty?
        
        internal let cancelEventAfterFirstVisit: Bool
        internal let availability: Availability
        
        public init(
            message: String? = nil,
            guardians: CreatureStacks? = nil,
            contents: Bounty? = nil,
            
            playersAllowedToTriggerThisEvent: [PlayerColor] = [],
            canBeTriggeredByComputerOpponent: Bool,
            cancelEventAfterFirstVisit: Bool
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
    }
    
    // MARK: Availability
    struct Availability: Hashable {
        
        /// MapEditor: "Players allowed to trigger event"
        internal let playersAllowedToTriggerEvent: [PlayerColor]
        
        /// MapEditor: "Allow computer opponent to trigger event"
        internal let canBeTriggeredByComputerOpponent: Bool
        
        public init(
            playersAllowedToTriggerEvent: [PlayerColor],
            canBeTriggeredByComputerOpponent: Bool
        ) {
            self.playersAllowedToTriggerEvent = playersAllowedToTriggerEvent
            self.canBeTriggeredByComputerOpponent = canBeTriggeredByComputerOpponent
        }
    }

}


