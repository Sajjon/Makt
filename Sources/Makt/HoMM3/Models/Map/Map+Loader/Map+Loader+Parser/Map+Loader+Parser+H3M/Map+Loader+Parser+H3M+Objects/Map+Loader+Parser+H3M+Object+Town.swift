//
//  Map+Loader+Parser+H3M+Object+Town.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation

public extension CaseIterable {
    static func random() -> Self {
        allCases.randomElement()!
    }
}

public extension Array where Element: Equatable {
    func all<S>(but exclusion: S) -> [Element] where S: Sequence, S.Element == Self.Element {
        filter({ element in !exclusion.contains(where: { $0 == element }) })
    }
    
    func all<S, Member>(
        but exclusion: S,
        map: (Element) -> Member
    ) -> [Element] where S: Sequence, S.Element == Member, Member: Equatable {
        filter({ element in
            let member = map(element)
            return !exclusion.contains(where: { $0 == member })
        })
    }
    
    func all<S, Member>(
        member keyPath: KeyPath<Element, Member>,
        but exclusion: S
    ) -> [Element] where S: Sequence, S.Element == Member, Member: Equatable {
        all(but: exclusion) { $0[keyPath: keyPath] }
    }
}

public extension RawRepresentable where Self: CaseIterable, Self.AllCases == [Self], Self: Equatable {
    static func all<S>(but exclusion: S) -> [Self] where S: Sequence, S.Element == Self {
        allCases.all(but: exclusion)
    }
}


public extension Map {
    struct Town: Hashable, CustomDebugStringConvertible {
        public enum ID: Hashable {
            
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
        
        public struct Spells: Hashable {
            
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
        
        public typealias Events = CollectionOf<Map.Town.Event>
        
        public let events: Events?
        
        public enum Alignment: Hashable {
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
            alignment: Alignment? = nil
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
    
    enum Buildings: Hashable {
        case simple(hasFort: Bool)
        case custom(CustomBuildings)
    }
    
    struct CustomBuildings: Hashable {
        public let built: [Building]
        public let forbidden: [Building]
        
        public init(
            built: [Building] = [.fort],
            forbidden: [Building] = []
        ) {
            self.built = built
            self.forbidden = forbidden
        }
    }
}
public extension Map.Town {
    enum Building: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
        
        public var debugDescription: String {
            switch self {
            case .townHall: return "townHall"
            case .cityHall: return "cityHall"
            case .capitol: return "capitol"
            case .fort: return "fort"
            case .citadel: return "citadel"
            case .castle: return "castle"
            case .tavern: return "tavern"
            case .blacksmith: return "blacksmith"
            case .marketplace: return "marketplace"
            case .resourceSilo: return "resourceSilo"
            case .artifactMerchants: return "artifactMerchants"
            case .mageGuildLevel1: return "mageGuildLevel1"
            case .mageGuildLevel2: return "mageGuildLevel2"
            case .mageGuildLevel3: return "mageGuildLevel3"
            case .mageGuildLevel4: return "mageGuildLevel4"
            case .mageGuildLevel5: return "mageGuildLevel5"
            case .shipyard: return "shipyard"
            case .grail: return "grail"
            case .special1: return "special1"
            case .special2: return "special2"
            case .special3: return "special3"
            case .special4: return "special4"
            case .dwelling1: return "dwelling1"
            case .upgradedDwelling1: return "upgradedDwelling1"
            case .horde1: return "horde1"
            case .dwelling2: return "dwelling2"
            case .upgradedDwelling2: return "upgradedDwelling2"
            case .horde2: return "horde2"
            case .dwelling3: return "dwelling3"
            case .upgradedDwelling3: return "upgradedDwelling3"
            case .horde3: return "horde3"
            case .dwelling4: return "dwelling4"
            case .upgradedDwelling4: return "upgradedDwelling4"
            case .horde4: return "horde4"
            case .dwelling5: return "dwelling5"
            case .upgradedDwelling5: return "upgradedDwelling5"
            case .horde5: return "horde5"
            case .dwelling6: return "dwelling6"
            case .upgradedDwelling6: return "upgradedDwelling6"
            case .dwelling7: return "dwelling7"
            case .upgradedDwelling7: return "upgradedDwelling7"
            }
        }
        
        case townHall
        case cityHall
        case capitol
        case fort
        case citadel
        case castle
        case tavern
        case blacksmith
        
        case marketplace
        case resourceSilo
        case artifactMerchants
        case mageGuildLevel1
        case mageGuildLevel2
        case mageGuildLevel3
        case mageGuildLevel4
        case mageGuildLevel5
        
        case shipyard
        case grail
        
        /// Fortress: `Blood obelisk` (? or special2 or special3)
        /// Stronghold: `Escape tunnel` (?)
        case special1
        
        /// Fortress: `Glyphs of fear` (? or special1 or special3)
        /// Stronghold: `Ballista Yard` (?)
        case special2
        
        /// Fortress: `Cage of warlords` (? or special2 or special1)
        /// Stronghold: `Freelancer's guild` (?)
        case special3
        
        /// Fortress: `Carnivorous Plant`
        /// Stronghold: `Hall of Valhalla` (?)
        case special4
        
        case dwelling1
        case upgradedDwelling1
        case horde1
        case dwelling2
        case upgradedDwelling2
        case horde2
        case dwelling3
        case upgradedDwelling3
        case horde3
        case dwelling4
        case upgradedDwelling4
        case horde4
        case dwelling5
        case upgradedDwelling5
        case horde5
        case dwelling6
        case upgradedDwelling6
        case dwelling7
        case upgradedDwelling7
    }
        
}

//public extension RandomNumberGenerator {
//    mutating func randomBool() -> Bool {
//        Int.random(in: 0...1, using: &self) == 0
//    }
//}

//public extension Map.Town.Building {
//
//    static func `default`(
//        includeFort: Bool = false,
//    ) -> [Self]  {
//        let maybeFort: Self? = includeFort ? .fort : nil
//        let maybeDwelling2: Self? = prng.randomBool() ? .dwelling2 : nil
//
//        return [
//            maybeFort,
////            .villageHall,
//            .tavern,
//            .dwelling1,
//            maybeDwelling2
//        ].compactMap({ $0 })
//    }
//
//}


// MARK: Parse Town
internal extension Map.Loader.Parser.H3M {
    
    
    func parseRandomTown(
        format: Map.Format,
        position: Position,
        allowedSpellsOnMap: [Spell.ID],
        availablePlayers: [Player]
    ) throws -> Map.Town {
        try parseTown(
            format: format,
            position: position,
            allowedSpellsOnMap: allowedSpellsOnMap,
            availablePlayers: availablePlayers
        )
    }
    
    func parseTown(
        format: Map.Format,
        faction: Faction? = nil,
        position: Position,
        allowedSpellsOnMap: [Spell.ID],
        availablePlayers: [Player]
    ) throws -> Map.Town {
        
        let townID: Map.Town.ID = try format > .restorationOfErathia ? .fromMapFile(reader.readUInt32()) : .position(position)
        
        let owner = try parseOwner()
        let hasName = try reader.readBool()
        let name: String? = try hasName ? reader.readString(maxByteCount: 32) : nil
        
        let hasGarrison = try reader.readBool()
        let garrison: CreatureStacks? = try hasGarrison ? parseCreatureStacks(format: format, count: 7) : nil
        let formation: CreatureStacks.Formation = try .init(integer: reader.readUInt8())
        let hasCustomBuildings = try reader.readBool()
        let buildings: Map.Town.Buildings = try hasCustomBuildings ? parseTownWithCustomBuildings() : parseSimpleTown()
        
        
        let obligatorySpells = try format >= .armageddonsBlade ? parseSpellIDs(includeIfBitSet: true) : []
        let possibleSpells = try parseSpellIDs(includeIfBitSet: false).filter({ allowedSpellsOnMap.contains($0) })
        
        // TODO add spells from mods.
        
        // Read castle events
        let eventCount = try reader.readUInt32()
        assert(eventCount <= 8192, "Cannot be more than 8192 town events... something is wrong. got: \(eventCount)")
        let events: [Map.Town.Event] = try eventCount.nTimes {
            let timedEvent = try parseTimedEvent(
                format: format,
                availablePlayers: availablePlayers
            )
            
            
            // New buildings
            let buildings = try parseBuildings()
            
            // Creatures added to generator
            let creatureQuantities = try CreatureStacks.Slot.allCases.count.nTimes {
                CreatureStack.Quantity(try reader.readUInt16())
            }
            
            try reader.skip(byteCount: 4)

            return Map.Town.Event(
                townID: townID,
                timedEvent: timedEvent,
                buildings: buildings,
                creaturesToBeGained: creatureQuantities
            )
        }
        
        var alignment: Map.Town.Alignment?
        if format >= .shadowOfDeath {
            let alignmentRaw = try reader.readUInt8()
            alignment = alignmentRaw == 0xff ? .sameAsOwnerOrRandom : .sameAs(player: try Player(integer: alignmentRaw))
        }
        
        try reader.skip(byteCount: 3)
        
        return Map.Town(
            id: townID,
            faction: faction,
            owner: owner,
            name: name,
            garrison: garrison,
            formation: formation,
            buildings: buildings,
            spells: .init(
                possible: .init(values: possibleSpells),
                obligatory: .init(values: obligatorySpells)
            ),
            events: events.isEmpty ? nil : .init(values: events),
            alignment: alignment
        )
    }
}

public extension Map.Town {
    struct Event: Hashable, CustomDebugStringConvertible {
        public let townID: Map.Town.ID
        
        /// private because ugly that we piggyback on this TownEvent having the same properties as a timed event. Make use of public computed properties to extract info from this private stored property.
        private let timedEvent: Map.TimedEvent
        
        public let buildings: [Building]
        
        /// MapEditor: "Note the specified creatures will be added to their respective generator building within the town. If the generator has not been built at that time the creatures cannot be added."
        public let creaturesToBeAddedToRespectiveGenerators: [CreatureStack.Quantity]
        
        public init(
            townID: Map.Town.ID,
            timedEvent: Map.TimedEvent,
            buildings: [Building] = [],
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

// MARK: Private
private extension Map.Loader.Parser.H3M {
    
    func parseBuildings() throws -> [Map.Town.Building] {
        let rawBytes = try reader.read(byteCount: 6)
        let bitmaskFlipped =  BitArray(data: Data(rawBytes.reversed()))
        let bitmask = BitArray(bitmaskFlipped.reversed())
        return try bitmask.enumerated().compactMap { (buildingID, isBuilt) in
           guard isBuilt else { return nil }
        return try Map.Town.Building(integer: buildingID)
       }
    }
    
    func parseTownWithCustomBuildings() throws -> Map.Town.Buildings {
        let built = try parseBuildings()
        let forbidden = try parseBuildings()
        return .custom(.init(built: built, forbidden: forbidden))
    }
    
    func parseSimpleTown() throws -> Map.Town.Buildings {
        let hasFort = try reader.readBool()
        return .simple(hasFort: hasFort)
    }
}
