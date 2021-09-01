//
//  Map+Event.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation
public extension Map {
    // TODO disambiguate between invisible events that might be triggered when walked on a certain tile (or also time based?) and visible event OBJECTs. One is parsed amongst objects in `parseObjects` the other is parsed in `parseEvents`. Should both really share the same struct?
    struct Event: Hashable {
        
        public let name: String?
 
        public let message: String?
        public let guards: CreatureStacks?
        public let bounty: Bounty?
        
        internal let firstOccurence: UInt16?
        internal let nextOccurence: UInt8?
        internal let shouldBeRemovedAfterVisit: Bool
        internal let availability: Availability
        
        public init(
            name: String? = nil,
            firstOccurence: UInt16? = nil,
            nextOccurence: UInt8? = nil,
            
            message: String? = nil,
            guards: CreatureStacks? = nil,
            bounty: Bounty? = nil,
            
            allowedPlayers: [PlayerColor] = [],
            canBeActivatedByComputer: Bool,
            shouldBeRemovedAfterVisit: Bool,
            canBeActivatedByHuman: Bool
        ) {
            self.name = name
            self.firstOccurence = firstOccurence
            self.nextOccurence = nextOccurence
        
            self.message = message
            self.guards = guards
            self.bounty = bounty
            
            self.availability = .init(
                allowedPlayers: allowedPlayers,
                canBeActivatedByComputer: canBeActivatedByComputer,
                canBeActivatedByHuman: canBeActivatedByHuman
            )
            self.shouldBeRemovedAfterVisit = shouldBeRemovedAfterVisit
        }
    }
}


// MARK: Availability
public extension Map.Event {
    
    
    struct Availability: Hashable {
        internal let allowedPlayers: [PlayerColor]
        internal let canBeActivatedByComputer: Bool
        internal let canBeActivatedByHuman: Bool
        
        public init(
            allowedPlayers: [PlayerColor],
            canBeActivatedByComputer: Bool,
            canBeActivatedByHuman: Bool
        ) {
            self.allowedPlayers = allowedPlayers
            self.canBeActivatedByComputer = canBeActivatedByComputer
            self.canBeActivatedByHuman = canBeActivatedByHuman
        }
    }
}
