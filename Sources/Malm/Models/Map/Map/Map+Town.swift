//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

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
        
        public typealias Events = ArrayOf<Map.Town.Event>
        
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

// MARK: Building
public extension Map.Town {
    enum Building: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
        
        public var debugDescription: String {
            name
        }
        
        public var name: String {
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
        
        
        /// Castle: lighthouse
        /// [Conflux, Dungeon, Tower]: artifactMerchant
        /// Fortress: cageOfWarlords
        /// Necropolis: coverOfDarkness
        /// Rampart: mysticPond
        /// Stronghold: escapeTunnel
        ///
        /// NOTE that Inferno lacks `special1`.
        case special1
        
        /// Special1 for towns: [Castle]
        static let lighthouse: Self = .special1
        
        /// Special1 for towns: [Conflux, Dungeon, Tower]
        static let artifactMerchant: Self = .special1
        
        /// Special1 for towns: [Fortress]
        static let cageOfWarlords: Self = .special1
        
        /// Special1 for towns: [Necropolis]
        static let coverOfDarkness: Self = .special1
        
        /// Special1 for towns: [Rampart]
        static let mysticPond: Self = .special1
        
        /// Special1 for towns: [Stronghold]
        static let escapeTunnel: Self = .special1
        
        /// Castle: stables
        /// Conflux: magicUniversity
        /// Dungeon: manaVortex
        /// Fortress: bloodObelisk
        /// Inferno: brimstoneStormclouds
        /// Necropolis: necromancyAmplifier
        /// Rampart: fountainOfFortune
        /// Stronghold: freelancersGuild
        /// Tower: lookoutTower
        case special2
        
        /// Special2 for towns: [Castle]
        static let stables: Self = .special2
        
        /// Special2 for towns: [Conflux]
        static let magicUniversity: Self = .special2
        
        /// Special2 for towns: [Dungeon]
        static let manaVortex: Self = .special2
        
        /// Special2 for towns: [Fortress]
        static let bloodObelisk: Self = .special2
        
        /// Special2 for towns: [Inferno]
        static let brimstoneStormclouds: Self = .special2
        
        /// Special2 for towns: [Necropolis]
        static let necromancyAmplifier: Self = .special2
        
        /// Special2 for towns: [Rampart]
        static let fountainOfFortune: Self = .special2
        
        /// Special2 for towns: [Stronghold]
        static let freelancersGuild: Self = .special2
        
        /// Special2 for towns: [Tower]
        static let lookoutTower: Self = .special2
        
        /// Castle: brotherhoodOfSword
        /// Dungeon: portalOfSummoning
        /// Fortress: glyphsOfFear
        /// Inferno: castleGate
        /// Necropolis: skeletonTransformer
        /// Rampart: treasury
        /// Stronghold: ballistaYard
        /// Tower: library
        ///
        /// NOTE that Conflux lacks `speclial3`
        case special3
        
        /// Special3 for towns: [Castle]
        static let brotherhoodOfSword: Self = special3
        
        /// Special3 for towns: [Dungeon]
        static let portalOfSummoning: Self = special3
        
        /// Special3 for towns: [Fortress]
        static let glyphsOfFear: Self = special3
        
        /// Special3 for towns: [Inferno]
        static let castleGate: Self = special3
        
        /// Special3 for towns: [Necropolis]
        static let skeletonTransformer: Self = special3
        
        /// Special3 for towns: [Rampart]
        static let treasury: Self = special3
        
        /// Special3 for towns: [Stronghold]
        static let ballistaYard: Self = special3
        
        /// Special3 for towns: [Tower]
        static let library: Self = special3
        
        /// Dungeon: battleScholarAcademy
        /// Inferno: orderOfFire
        /// Stronghold: hallOfValhalla
        /// Tower: wallOfKnowledge
        ///
        /// NOTE that these town lacks `special4`: [Castle, Conflux, Dungeon, Fortress, Necropolis, Rampart]
        case special4
        
        /// Special4 for towns: [Dungeon]
        static let battleScholarAcademy: Self = .special4
        
        /// Special4 for towns: [Inferno]
        static let orderOfFire: Self = .special4
        
        /// Special4 for towns: [Stronghold]
        static let hallOfValhalla: Self = .special4
        
        /// Special4 for towns: [Tower]
        static let wallOfKnowledge: Self = .special4
        
        case dwelling1
        case upgradedDwelling1
        
        /// Castle: griffinBastion
        /// Castle: minersGuild
        case horde1
        
        /// Castle horde 1
        static let griffinBastion: Self = .horde1
        /// Castle horde 2 ???
        static let griffinBastionUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
        
        /// Rampart horde 1
        static let minersGuild: Self = .horde1
        /// Rampart horde 2 ???
        static let minersGuildUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
        
        /// Tower horde 1
        static let sculptorsWings: Self = .horde1
        /// Tower horde 2 ???
        static let sculptorsWingsUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
        
        /// Inferno horde 1
        static let birthingPools: Self = .horde1
        /// Inferno horde 2 ???
        static let birthingPoolsUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
        
        /// Necropolis horde 1
        static let unearthedGraves: Self = .horde1
        /// Necropolis horde 2 ???
        static let unearthedGravesUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2

        /// Dungeon horde 1
        static let mushroomRings: Self = .horde1
        /// Dungeon horde 2 ???
        static let mushroomRingsUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
        
        /// Stronghold horde 1
        static let messHall: Self = .horde1
        /// Stronghold horde 2 ???
        static let messHallUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
        
        /// Fortress horde 1
        static let captainsQuarters: Self = .horde1
        /// Fortress horde 2 ???
        static let captainsQuartersUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
        
        /// Conflux horde 1
        static let gardenOfLife: Self = .horde1
        /// Conflux horde 2 ???
        static let gardenOfLifeUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
        
        /// Rampart horde 3
        static let dendroidSaplings: Self = .horde3
        /// Rampart horde 4 ???
        static let dendroidSaplingsUpg_NOT_SURE_THIS_IS_HORDE4: Self = .horde4
        
        /// Inferno horde 3
        static let cages: Self = .horde3
        /// Inferno horde 4 ???
        static let cagesUpg_NOT_SURE_THIS_IS_HORDE4: Self = .horde4
   
        
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

// MARK: Town Event
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
