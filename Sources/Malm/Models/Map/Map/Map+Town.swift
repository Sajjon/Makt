//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Util

public extension Map {
    struct Town: Hashable, CustomDebugStringConvertible, Codable {
        public enum ID: Hashable, Codable {
            
            /// Parsed from h3m map file
            /// Only present in version later than ROE
            case fromMapFile(UInt32)
            
            /// Use position as ID.
            case position(Position)
        }
        
        public let id: ID
        
        /// nil if random town
        public let faction: Faction?
        
        public let owner: Player?
        public let name: String?
        public let garrison: CreatureStacks?
        public let formation: CreatureStacks.Formation
        public let buildings: Map.Town.Buildings
        
        public struct Spells: Hashable, Codable {
            
            /// Map Editor: "Spells which MAY appear in the mage guild"
            public let possible: SpellIDs
            
            
            /// Map Editor: "Spells which MUST appear in the mage guild"
            ///
            /// Only for SoD maps
            public let obligatory: SpellIDs?
            
            public init(
                possible: SpellIDs = .init(values: Spell.ID.allCases),
                obligatory: SpellIDs? = nil
            ) {
                self.possible = possible
                self.obligatory = obligatory?.isEmpty == true ? nil : obligatory
            }
        }
        public let spells: Spells
        
        public typealias Events = ArrayOf<Map.Town.Event>
        
        public let events: Events?
        
        public enum Alignment: Hashable, Codable {
            case sameAsOwnerOrRandom
            case sameAs(player: Player)
        }
        
        /// SOD feature
        public let alignment: Alignment?
        
        public init(
            id: ID,
            faction: Faction? = nil,
            owner: Player? = nil,
            name: String? = nil,
            garrison: CreatureStacks? = nil,
            formation: CreatureStacks.Formation = .spread,
            buildings: Map.Town.Buildings = .simple(hasFort: true),
            spells: Spells = .init(),
            events: Events? = nil,
            alignment: Alignment? = .sameAsOwnerOrRandom
        ) {
            self.id = id
            self.faction = faction
            self.owner = owner
            self.name = name
            self.garrison = garrison
            self.formation = formation
            self.buildings = buildings
            self.spells = spells
            self.events = events
            self.alignment = alignment
        }
    }
}

public extension Map.Town {
    
    var debugDescription: String {
        let optionalStrings: [String?] = [
            "id: \(id)",
            faction.map { "faction: \($0)" } ?? nil,
            owner.map { "owner: \($0)" } ?? nil,
            name.map { "name: \($0)" } ?? nil,
            garrison.map { "\ngarrison: \($0)\n" } ?? nil,
            "formation: \(formation)",
            
            "buildings: \(buildings)",
            
            "spells: \(spells)",
            
            events.map { "events: \($0)\n" } ?? nil,
            alignment.map { "alignment: \($0)" } ?? nil,
            
        ]
        
        return optionalStrings.compactMap({ $0 }).joined(separator: "\n")
    }
    
    enum Buildings: Hashable, Codable {
        case simple(hasFort: Bool)
        case custom(CustomBuildings)
    }
    
    struct CustomBuildings: Hashable, Codable {
        public let built: [Building.ID.Common]
        public let forbidden: [Building.ID.Common]
        
        public init(
            built: [Building.ID.Common] = [.fort],
            forbidden: [Building.ID.Common] = []
        ) {
            self.built = built
            self.forbidden = forbidden
        }
    }
}

// MARK: Town Event
public extension Map.Town {
    
    struct Event: Hashable, CustomDebugStringConvertible, Codable {
        public let townID: Map.Town.ID
        
        /// private because ugly that we piggyback on this TownEvent having the same properties as a timed event. Make use of public computed properties to extract info from this private stored property.
        private let timedEvent: Map.TimedEvent
        
        public let buildings: [Building.ID.Common]
        
        /// MapEditor: "Note the specified creatures will be added to their respective generator building within the town. If the generator has not been built at that time the creatures cannot be added."
        public let creaturesToBeAddedToRespectiveGenerators: [CreatureStack.Quantity]
        
        public init(
            townID: Map.Town.ID,
            timedEvent: Map.TimedEvent,
            buildings: [Building.ID.Common] = [],
            creaturesToBeGained: [CreatureStack.Quantity] = .noCreatures
        ) {
            precondition(creaturesToBeGained.count == CreatureStacks.Slot.allCases.count)
            self.townID = townID
            self.timedEvent = timedEvent
            self.buildings = buildings
            self.creaturesToBeAddedToRespectiveGenerators = creaturesToBeGained
        }
        
        public var debugDescription: String {
            """
            id: \(townID),
            \(timedEvent.debugDescription)
            buildings: \(buildings)
            creaturesToBeAddedToRespectiveGenerators: \(creaturesToBeAddedToRespectiveGenerators)
            """
        }
    }
}

public extension Array where Element == CreatureStack.Quantity {
    static let noCreatures = Self(repeating: 0, count: CreatureStacks.Slot.allCases.count)
}


public extension Map.Town.Event {
    var name: String? { timedEvent.name }
    var message: String? { timedEvent.message }
    var resources: Resources? { timedEvent.resources }
    var occurrences: Map.TimedEvent.Occurrences { timedEvent.occurrences }
    var availability: Map.TimedEvent.Availability { timedEvent.availability }
}
