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
        
        private let name: String?
        private let firstOccurence: UInt16?
        private let nextOccurence: UInt8?

        private let shouldBeRemovedAfterVisit: Bool
        private let availability: Availability
        
        public init(
            name: String? = nil,
            firstOccurence: UInt16? = nil,
            nextOccurence: UInt8? = nil,
            
            pandorasBox: PandorasBox,
            
            availableForPlayers: [PlayerColor] = [],
            canBeActivatedByComputer: Bool,
            shouldBeRemovedAfterVisit: Bool,
            canBeActivatedByHuman: Bool
        ) {
            self.name = name
            self.firstOccurence = firstOccurence
            self.nextOccurence = nextOccurence
        
            self.availability = .init(
                availableForPlayers: availableForPlayers,
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
        private let availableForPlayers: [PlayerColor]
        private let canBeActivatedByComputer: Bool
        private let canBeActivatedByHuman: Bool
        
        public init(
            availableForPlayers: [PlayerColor],
            canBeActivatedByComputer: Bool,
            canBeActivatedByHuman: Bool
        ) {
            self.availableForPlayers = availableForPlayers
            self.canBeActivatedByComputer = canBeActivatedByComputer
            self.canBeActivatedByHuman = canBeActivatedByHuman
        }
    }
}
