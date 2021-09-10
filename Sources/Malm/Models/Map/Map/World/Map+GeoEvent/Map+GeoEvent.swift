//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

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


