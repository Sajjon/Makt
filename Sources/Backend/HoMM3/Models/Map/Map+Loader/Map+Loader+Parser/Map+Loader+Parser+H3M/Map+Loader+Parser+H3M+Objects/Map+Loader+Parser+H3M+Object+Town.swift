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

public extension RawRepresentable where Self: CaseIterable, Self.AllCases == [Self], Self: Equatable {
    static func all<S>(but exclusion: S) -> [Self] where S: Sequence, S.Element == Self {
        allCases.filter({ element in !exclusion.contains(where: { $0 == element }) })
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
        
        public let owner: PlayerColor?
        public let name: String?
        public let garrison: CreatureStacks?
        public let formation: Army.Formation
        public let buildings: Map.Town.Buildings
        
        public struct Spells: Hashable {
            
            /// Map Editor: "Spells which MAY appear in the mage guild"
            public let possible: SpellIDs
            
            
            /// Map Editor: "Spells which MUST appear in the mage guild"
            ///
            /// Only for SoD maps
            public let obligatory: SpellIDs?
            
            public init(
                possible: SpellIDs,
                obligatory: SpellIDs? = nil
            ) {
                self.possible = possible
                self.obligatory = obligatory?.isEmpty == true ? nil : obligatory
            }
        }
        public let spells: Spells
        
        public enum EventsTag: Hashable {}
        public typealias Events = CollectionOf<Map.Town.Event, EventsTag>
        
        public let events: Events?
        
        /// SOD feature
        public let alignment: Faction?
        
        public init(
            id: ID,
            faction: Faction? = nil,
            owner: PlayerColor? = nil,
            name: String? = nil,
            garrison: CreatureStacks? = nil,
            formation: Army.Formation = .spread,
            buildings: Map.Town.Buildings,
            spells: Spells,
            events: Events? = nil,
            alignment: Faction? = nil
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
            garrison.map { "garrison: \($0)" } ?? nil,
            "formation: \(formation)",
            "buildings: \(buildings)",
            "spells: \(spells)",
            events.map { "events: \($0)" } ?? nil,
            alignment.map { "alignment: \($0)" } ?? nil,
            
        ]
        
        return optionalStrings.compactMap({ $0 }).joined(separator: "\n")
    }
    
    struct Buildings: Hashable {
        public let built: [Building]
        public let forbidden: [Building]
    }
}
public extension Map.Town.Buildings {
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
        case special1
        case special2
        case special3
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
        
    enum BuildingDEPRECATED: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
        
        static let artifactMerchants: Self = .buildingId17
        
        static let dwelling1Horde: Self = .buildingId18
        static let dwelling1UpgradeHorde: Self = .buildingId19
        static let dwelling2Horde: Self = .buildingId24
        static let dwelling2UpgradeHorde: Self = .buildingId25
        static let dwelling3Horde: Self = .buildingId18
        static let dwelling3UpgradedHorde: Self = .buildingId19
        static let dwelling5Horde: Self = .buildingId24
        static let dwelling5UpgradedHorde: Self = .buildingId25
        
        case mageguildLevel1 = 0,
        mageguildLevel2,
        mageguildLevel3,
        mageguildLevel4,
        mageguildLevel5,
        
        tavern,
        shipyard,
        
        fort,
        citadel,
        castle,
        
        villageHall,
        townHall,
        cityHall,
        capitol,
        
        marketplace,
        resourceSilo,
        blacksmith
        
        
        /// Castle: Lighthouse
        /// Rampart: Mystic pind
        /// Tower: Artifact Merchant
        /// Inferno: N/A
        /// Necropolis: Veil of darkness
        /// Dungeon: Artifact Merchant
        /// Stornghold: Escape tunnel
        /// Fortress: Cage of warlords
        /// Conflux: Artifact Merchant
        case buildingId17
        
        /// Horde buildings for non upgraded creatures
        ///
        /// Castle: Grifins
        /// Rampart: Dwarfes
        /// Tower: Stone Gargoyles
        /// Inferno: Imps
        /// Necropolis: Skeletons
        /// Dungeon: Troglodytes
        /// Stornghold: Goblins
        /// Fortress: Gnolls
        /// Conflux: Pixies
        case buildingId18
        
        /// Horde buildings for upgraded creatures
        ///
        /// Castle: Royale Griffins
        /// Rampart: Battle Dwarfes
        /// Tower: Obsidian Gargoyles
        /// Inferno: Familars
        /// Necropolis: Skeleton Warrios
        /// Dungeon: Infernal Troglodytes
        /// Stornghold:Hobgoblins
        /// Fortress: Gnoll MArauders
        /// Conflux: Sprites
        case buildingId19
        
        case shipAtTheShipyard = 20

        /// Castle: Stables
        /// Rampart: Fountain of Fortune
        /// Tower: Lookout Tower
        /// Inferno: Brimstone Clouds
        /// Necropolis: Necromancy Amplifier
        /// Dungeon: Mana Vortex
        /// Stornghold: Freelancer's Guild
        /// Fortress: Glyphs Of Fear
        /// Conflux: Magic University
        case buildingId21
        
        /// Castle: Brotherhood of Sword
        /// Rampart: Dwarfen Treasure
        /// Tower: Library
        /// Inferno: Castle Gates
        /// Necropolis: Skeleton Transformer
        /// Dungeon: Portal Of Summoning
        /// Stornghold: Ballista Yard
        /// Fortress: Blood Obelisk
        /// Conflux: N/A
        case buildingId22
        
        /// Tower: Wall Of Knowledge
        /// Inferno: Order of fire
        /// Dungeon: Academy Of Battle Scholars
        /// Stornghold: Hall Of Valhalla
        /// Castle, Rampart, Necropolis, Fortress, Conflux: N/A
        case buildingId23
        
        /// Horde Buildings For Non-Upgraded Creatures:
        /// Rampart: Dendroid Guards
        /// Inferno: Hell Hounds
        /// REST: N/A
        case buildingId24
        
        /// Horde Buildings For Upgraded Creatures:
        /// Rampart: Dendroid Soldiers,
        /// Inferno: Cerberi
        /// REST: N/A
        case buildingId25
        
        case grail = 26,
        
        housesNearCityHall,
        housesNearMunicipal,
        housesNearCapitol,
        
        dwelling1,
        dwelling2,
        dwelling3,
        dwelling4,
        dwelling5,
        dwelling6,
        dwelling7,
        upgradedDwelling1,
        upgradedDwelling2,
        upgradedDwelling3,
        upgradedDwelling4,
        upgradedDwelling5,
        upgradedDwelling6,
        upgradedDwelling7
        
    }
}

public extension Map.Town.Buildings.BuildingDEPRECATED {
    var debugDescription: String {
        switch self {
        case .mageguildLevel1: return "Mage Guild level 1"
           case .mageguildLevel2: return "Mage Guild level 2"
           case .mageguildLevel3: return "Mage Guild level 3"
           case .mageguildLevel4: return "Mage Guild level 4"
           case .mageguildLevel5: return "Mage Guild level 5"
        
        case .tavern: return "Tavern"
        case .shipyard: return "Shipyard"
        
        case .fort: return "Fort"
        case .citadel: return "Citadel"
             case .castle: return "Castle"
        
        case .villageHall: return "Village hall"
        case .townHall: return "Town hall"
        case .cityHall: return "City hall"
        case .capitol: return "capitol"
        
        case .marketplace: return "Marketplace"
        case .resourceSilo: return "Resource Silo"
        case .blacksmith: return "Blacksmith"
        
        
        /// Castle: Lighthouse
        /// Rampart: Mystic pind
        /// Tower: Artifact Merchant
        /// Inferno: N/A
        /// Necropolis: Veil of darkness
        /// Dungeon: Artifact Merchant
        /// Stornghold: Escape tunnel
        /// Fortress: Cage of warlords
        /// Conflux: Artifact Merchant
        case .buildingId17: return """
                    Castle: Lighthouse
                    Rampart: Mystic pind
                    Tower: Artifact Merchant
                    Inferno: N/A
                    Necropolis: Veil of darkness
                    Dungeon: Artifact Merchant
                    Stornghold: Escape tunnel
                    Fortress: Cage of warlords
                    Conflux: Artifact Merchant
            """
        
        /// Horde buildings for non upgraded creatures
        ///
        /// Castle: Grifins
        /// Rampart: Dwarfes
        /// Tower: Stone Gargoyles
        /// Inferno: IMps
        /// Necropolis: Skeletons
        /// Dungeon: Troglodytes
        /// Stornghold: Goblins
        /// Fortress: Gnolls
        /// Conflux: Pixies
        case .buildingId18: return """
                    Horde buildings for non upgraded creatures
                    Castle: Grifins
                    Rampart: Dwarfes
                    Tower: Stone Gargoyles
                    Inferno: IMps
                    Necropolis: Skeletons
                    Dungeon: Troglodytes
                    Stornghold: Goblins
                    Fortress: Gnolls
                    Conflux: Pixies
            """
        
        /// Horde buildings for upgraded creatures
        ///
        /// Castle: Royale Griffins
        /// Rampart: Battle Dwarfes
        /// Tower: Obsidian Gargoyles
        /// Inferno: Familars
        /// Necropolis: Skeleton Warrios
        /// Dungeon: Infernal Troglodytes
        /// Stornghold:Hobgoblins
        /// Fortress: Gnoll MArauders
        /// Conflux: Sprites
        case .buildingId19: return """
                    Horde buildings for upgraded creatures
                    Castle: Royale Griffins
                    Rampart: Battle Dwarfes
                    Tower: Obsidian Gargoyles
                    Inferno: Familars
                    Necropolis: Skeleton Warrios
                    Dungeon: Infernal Troglodytes
                    Stornghold:Hobgoblins
                    Fortress: Gnoll MArauders
                    Conflux: Sprites
            """
        
        case .shipAtTheShipyard: return "Ship (at the shipyard)"

        /// Castle: Stables
        /// Rampart: Fountain of Fortune
        /// Tower: Lookout Tower
        /// Inferno: Brimstone Clouds
        /// Necropolis: Necromancy Amplifier
        /// Dungeon: Mana Vortex
        /// Stornghold: Freelancer's Guild
        /// Fortress: Glyphs Of Fear
        /// Conflux: Magic University
        case .buildingId21: return """
                    Castle: Stables
                    Rampart: Fountain of Fortune
                    Tower: Lookout Tower
                    Inferno: Brimstone Clouds
                    Necropolis: Necromancy Amplifier
                    Dungeon: Mana Vortex
                    Stornghold: Freelancer's Guild
                    Fortress: Glyphs Of Fear
                    Conflux: Magic University
            """
        
        /// Castle: Brotherhood of Sword
        /// Rampart: Dwarfen Treasure
        /// Tower: Library
        /// Inferno: Castle Gates
        /// Necropolis: Skeleton Transformer
        /// Dungeon: Portal Of Summoning
        /// Stornghold: Ballista Yard
        /// Fortress: Blood Obelisk
        /// Conflux: N/A
        case .buildingId22: return """
                    Castle: Brotherhood of Sword
                    Rampart: Dwarfen Treasure
                    Tower: Library
                    Inferno: Castle Gates
                    Necropolis: Skeleton Transformer
                    Dungeon: Portal Of Summoning
                    Stornghold: Ballista Yard
                    Fortress: Blood Obelisk
                    Conflux: N/A
            """
        
        /// Tower: Wall Of Knowledge
        /// Inferno: Order of fire
        /// Dungeon: Academy Of Battle Scholars
        /// Stornghold: Hall Of Valhalla
        /// Castle, Rampart, Necropolis, Fortress, Conflux: N/A
        case .buildingId23: return """
                    Tower: Wall Of Knowledge
                    Inferno: Order of fire
                    Dungeon: Academy Of Battle Scholars
                    Stornghold: Hall Of Valhalla
                    Castle, Rampart, Necropolis, Fortress, Conflux: N/A
            """
        
        /// Horde Buildings For Non-Upgraded Creatures:
        /// Rampart: Dendroid Guards
        /// Inferno: Hell Hounds
        /// REST: N/A
        case .buildingId24: return """
                    Horde Buildings For Non-Upgraded Creatures:
                    Rampart: Dendroid Guards
                    Inferno: Hell Hounds
                    REST: N/A
            """
        
        /// Horde Buildings For Upgraded Creatures:
        /// Rampart: Dendroid Soldiers,
        /// Inferno: Cerberi
        /// REST: N/A
        case .buildingId25: return """
                    Horde Buildings For Upgraded Creatures:
                    Rampart: Dendroid Soldiers,
                    Inferno: Cerberi
                    REST: N/A
            """
        
        case .grail: return "Grail"
        
        case .housesNearCityHall: return "Houses near city hall"
        case .housesNearMunicipal: return "Houses near municipal"
        case .housesNearCapitol: return "Houses near capitol"
        
        case .dwelling1: return "Dwelling level 1"
        case .dwelling2: return "Dwelling level 2"
        case .dwelling3: return "Dwelling level 3"
        case .dwelling4: return "Dwelling level 4"
        case .dwelling5: return "Dwelling level 5"
        case .dwelling6: return "Dwelling level 6"
        case .dwelling7: return "Dwelling level 7"
        case .upgradedDwelling1: return "Upgraded dwelling level 1"
        case .upgradedDwelling2: return "Upgraded dwelling level 2"
        case .upgradedDwelling3: return "Upgraded dwelling level 3"
        case .upgradedDwelling4: return "Upgraded dwelling level 4"
        case .upgradedDwelling5: return "Upgraded dwelling level 5"
        case .upgradedDwelling6: return "Upgraded dwelling level 6"
        case .upgradedDwelling7: return "Upgraded dwelling level 7"
        }
    }
}

public extension RandomNumberGenerator {
    mutating func randomBool() -> Bool {
        Int.random(in: 0...1, using: &self) == 0
    }
}

public extension Map.Town.Buildings.Building {

    static func `default`(
        includeFort: Bool = false,
        randomNumberGenerator: RandomNumberGenerator? = nil
    ) -> [Self]  {
        var prng = randomNumberGenerator ?? SystemRandomNumberGenerator()
        let maybeFort: Self? = includeFort ? .fort : nil
        let maybeDwelling2: Self? = prng.randomBool() ? .dwelling2 : nil
        
        return [
            maybeFort,
//            .villageHall,
            .tavern,
            .dwelling1,
            maybeDwelling2
        ].compactMap({ $0 })
    }
    
}


// MARK: Parse Town
internal extension Map.Loader.Parser.H3M {
    
    
    func parseRandomTown(
        format: Map.Format,
        position: Position,
        allowedSpellsOnMap: [Spell.ID],
        availablePlayers: [PlayerColor]
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
        availablePlayers: [PlayerColor]
    ) throws -> Map.Town {
        
        let townID: Map.Town.ID = try format > .restorationOfErathia ? .fromMapFile(reader.readUInt32()) : .position(position)
        
        let owner = try parseOwner()
        let hasName = try reader.readBool()
        let name: String? = try hasName ? reader.readString(maxByteCount: 32) : nil
        
        let hasGarrison = try reader.readBool()
        let garrison: CreatureStacks? = try hasGarrison ? parseCreatureStacks(format: format, count: 7) : nil
        let formation: Army.Formation = try .init(integer: reader.readUInt8())
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
        
        var alignment: Faction?
        if format >= .shadowOfDeath {
            alignment = try Faction(integer: reader.readUInt8())
            if let f = faction, alignment != f {
                fatalError("What?! Different faction parsed and provided...?")
            }
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

public enum Alignment: UInt8, Hashable, CaseIterable {
    case good, evil, neutral
}

public extension Map.Town {
    struct Event: Hashable, CustomDebugStringConvertible {
        public let townID: Map.Town.ID
        
        /// private because ugly that we piggyback on this TownEvent having the same properties as a timed event. Make use of public computed properties to extract info from this private stored property.
        private let timedEvent: Map.TimedEvent
        
        public let buildings: [Buildings.Building]
        
        /// MapEditor: "Note the specified creatures will be added to their respective generator building within the town. If the generator has not been built at that time the creatures cannot be added."
        public let creaturesToBeAddedToRespectiveGenerators: [CreatureStack.Quantity]
        
        public init(
            townID: Map.Town.ID,
            timedEvent: Map.TimedEvent,
            buildings: [Buildings.Building] = [],
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
    
    func parseBuildings() throws -> [Map.Town.Buildings.Building] {
        let rawBytes = try reader.read(byteCount: 6)
        
        let bitmaskFlipped =  BitArray(data: Data(rawBytes.reversed()))
        let bitmask = BitArray(bitmaskFlipped.reversed())
        return try bitmask.enumerated().compactMap { (buildingID, isBuilt) in
           guard isBuilt else { return nil }
        return try Map.Town.Buildings.Building(integer: buildingID)
       }
    }
    
    func parseTownWithCustomBuildings() throws -> Map.Town.Buildings {
        let built = try parseBuildings()
        let forbidden = try parseBuildings()
        return .init(built: built, forbidden: forbidden)
    }
    
    func parseSimpleTown() throws -> Map.Town.Buildings {
        let hasFort = try reader.readBool()
        let built = Map.Town.Buildings.Building.default(includeFort: hasFort)
        return .init(built: built, forbidden: [])
    }
}
