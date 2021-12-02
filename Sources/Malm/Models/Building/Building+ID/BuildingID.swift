//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-13.
//

import Foundation
import Common

public protocol BuildingIDConvertible {
    static var villageHall: Self { get }
    static var townHall: Self { get }
    static var cityHall: Self { get }
    static var capitol: Self { get }
    
    static var fort: Self { get }
    static var citadel: Self { get }
    static var castle: Self { get }
    
    static var mageGuildLevel1: Self { get }
    static var mageGuildLevel2: Self { get }
    // Stronghold only have up to level3
    static var mageGuildLevel3: Self { get }

    static var marketplace: Self { get }
    static var resourceSilo: Self { get }
    static var blacksmith: Self { get }
    
    static var tavern: Self { get }
    
    static var grail: Self { get }
    
    static var dwellingLevel1: Self { get }
    static var dwellingLevel2: Self { get }
    static var dwellingLevel3: Self { get }
    static var dwellingLevel4: Self { get }
    static var dwellingLevel5: Self { get }
    static var dwellingLevel6: Self { get }
    static var dwellingLevel7: Self { get }
    
    static var dwellingLevel1Upgraded: Self { get }
    static var dwellingLevel2Upgraded: Self { get }
    static var dwellingLevel3Upgraded: Self { get }
    static var dwellingLevel4Upgraded: Self { get }
    static var dwellingLevel5Upgraded: Self { get }
    static var dwellingLevel6Upgraded: Self { get }
    static var dwellingLevel7Upgraded: Self { get }
    
    static var special2: Self { get }
    
    static var horde1: Self { get }
}

public protocol TownWithShipyardMarker {}
public protocol TownWithShipyard: TownWithShipyardMarker, BuildingIDConvertible {
    static var shipyard: Self { get }
    static var ship: Self { get }
}

public protocol TownWithMageGuildLevel4Marker {}
public protocol TownWithMageGuildLevel4: TownWithMageGuildLevel4Marker, BuildingIDConvertible {
    static var mageGuildLevel4: Self { get }
}

public protocol TownWithMageGuildLevel5Marker {}
public protocol TownWithMageGuildLevel5: TownWithMageGuildLevel4 /* Impossible to have level 5 and not level 4. */ , TownWithMageGuildLevel5Marker {
    static var mageGuildLevel5: Self { get }
}

public protocol TownWithFirstSpecialBuldingMarker {}
public protocol TownWithFirstSpecialBulding: TownWithFirstSpecialBuldingMarker, BuildingIDConvertible {
    static var special1: Self { get }
}
public protocol TownWithThirdSpecialBuldingMarker {}
public protocol TownWithThirdSpecialBulding: TownWithThirdSpecialBuldingMarker, BuildingIDConvertible {
    static var special3: Self { get }
}
public protocol TownWithFourthSpecialBuldingMarker {}
public protocol TownWithFourthSpecialBulding: TownWithFourthSpecialBuldingMarker, BuildingIDConvertible {
    static var special4: Self { get }
}

public protocol TownWithSecondHordeBuildingMarker {}
public protocol TownWithSecondHordeBuilding: TownWithSecondHordeBuildingMarker, BuildingIDConvertible {
    static var horde2: Self { get }
}

public protocol BuildingIDDecodable: BuildingIDConvertible {
    init(common: Building.ID.Common)
}
public extension BuildingIDDecodable {
    init(common: Building.ID.Common) {
        implementMe()
    }
}
public protocol BuildingIDEncodable: BuildingIDConvertible {
    var common: Building.ID.Common { get }
}
public extension BuildingIDEncodable where Self: Equatable {
    func shared() -> Building.ID.Common {
        
        switch self {
        case .villageHall: return .villageHall
        case .townHall: return .townHall
        case .cityHall: return .cityHall
        case .capitol: return .capitol
            
        case .fort: return .fort
        case .citadel: return .citadel
        case .castle: return .castle
            
        case .mageGuildLevel1: return .mageGuildLevel1
        case .mageGuildLevel2: return .mageGuildLevel2
        case .mageGuildLevel3: return .mageGuildLevel3
            
        case .marketplace: return .marketplace
        case .resourceSilo: return .resourceSilo
        case .blacksmith: return .blacksmith
            
        case .tavern: return .tavern
        case .grail: return .grail
            
        case .dwellingLevel1: return .dwellingLevel1
        case .dwellingLevel2: return .dwellingLevel2
        case .dwellingLevel3: return .dwellingLevel3
        case .dwellingLevel4: return .dwellingLevel4
        case .dwellingLevel5: return .dwellingLevel5
        case .dwellingLevel6: return .dwellingLevel6
        case .dwellingLevel7: return .dwellingLevel7
            
        case .dwellingLevel1Upgraded: return .dwellingLevel1Upgraded
        case .dwellingLevel2Upgraded: return .dwellingLevel2Upgraded
        case .dwellingLevel3Upgraded: return .dwellingLevel3Upgraded
        case .dwellingLevel4Upgraded: return .dwellingLevel4Upgraded
        case .dwellingLevel5Upgraded: return .dwellingLevel5Upgraded
        case .dwellingLevel6Upgraded: return .dwellingLevel6Upgraded
        case .dwellingLevel7Upgraded: return .dwellingLevel7Upgraded
            
        case .special2: return .special2
        case .horde1: return .horde1
        default:
            incorrectImplementation(shouldAlreadyHave: "Handled conversion of: \(String(describing: self))")
        }
    }
}
public typealias BuildingIDCodable = BuildingIDDecodable & BuildingIDEncodable
public protocol BuildingIDForFaction: BuildingIDCodable, Hashable, Codable, CustomDebugStringConvertible {
    static var faction: Faction { get }
    var name: String { get }
}
public extension BuildingIDForFaction {
    var name: String { common.name }
    var debugDescription: String { name }
    var faction: Faction { Self.faction }
}

public extension Building.ID {
    
    /// Building IDs for the `Castle` faction
    enum Castle:
        BuildingIDForFaction,
        TownWithMageGuildLevel4,
        TownWithFirstSpecialBulding,
        TownWithThirdSpecialBulding,
        TownWithShipyard,
        Hashable,
        CaseIterable
    {
        public typealias AllCases = [Self]
        public static var allCases: AllCases =  [
            .mageGuildLevel1,
            .mageGuildLevel2,
            .mageGuildLevel3,
            .mageGuildLevel4,
            .tavern,
            .shipyard,
            .fort,
            .citadel,
            .castle,
            .villageHall,
            .townHall,
            .cityHall,
            .capitol,
            .marketplace,
            .resourceSilo,
            .blacksmith,
            .lighthouse,
            .griffinBastion(isUpgraded: false),
            .griffinBastion(isUpgraded: true),
            .ship,
            .stables,
            .brotherhoodOfSword,
            .colossus,
            .guardhouse(isUpgraded: false),
            .archersTower(isUpgraded: false),
            .griffinTower(isUpgraded: false),
            .barracks(isUpgraded: false),
            .monastery(isUpgraded: false),
            .trainingGrounds(isUpgraded: false),
            .portalOfGlory(isUpgraded: false),
            .guardhouse(isUpgraded: true),
            .archersTower(isUpgraded: true),
            .griffinTower(isUpgraded: true),
            .barracks(isUpgraded: true),
            .monastery(isUpgraded: true),
            .trainingGrounds(isUpgraded: true),
            .portalOfGlory(isUpgraded: true)
        ]
        
        public static var faction: Faction { .castle }
        
        case villageHall
        case townHall
        case cityHall
        case capitol
        
        case fort
        case citadel
        case castle
        
        case mageGuildLevel1
        case mageGuildLevel2
        case mageGuildLevel3
        case mageGuildLevel4

        case marketplace
        case resourceSilo
        case blacksmith
        
        case tavern
        case shipyard
        case ship
        
        case colossus
        public static let grail: Self = .colossus
        
        case guardhouse(isUpgraded: Bool = false)
        public static let dwellingLevel1: Self = .guardhouse()
        
        case archersTower(isUpgraded: Bool = false)
        public static let dwellingLevel2: Self = .archersTower()
        
        case griffinTower(isUpgraded: Bool = false)
        public static let dwellingLevel3: Self = .griffinTower()
        
        case barracks(isUpgraded: Bool = false)
        public static let dwellingLevel4: Self = .barracks()
        
        case monastery(isUpgraded: Bool = false)
        public static let dwellingLevel5: Self = .monastery()
        
        case trainingGrounds(isUpgraded: Bool = false)
        public static let dwellingLevel6: Self = .trainingGrounds()

        case portalOfGlory(isUpgraded: Bool = false)
        public static let dwellingLevel7: Self = .portalOfGlory()
        
        public static let dwellingLevel1Upgraded: Self = .guardhouse(isUpgraded: true)
        public static let dwellingLevel2Upgraded: Self = .archersTower(isUpgraded: true)
        public static let dwellingLevel3Upgraded: Self = .griffinTower(isUpgraded: true)
        public static let dwellingLevel4Upgraded: Self = .barracks(isUpgraded: true)
        public static let dwellingLevel5Upgraded: Self = .monastery(isUpgraded: true)
        public static let dwellingLevel6Upgraded: Self = .trainingGrounds(isUpgraded: true)
        public static let dwellingLevel7Upgraded: Self = .portalOfGlory(isUpgraded: true)

        /// Special1
        case lighthouse
        /// Special2
        case stables
        /// Special3
        case brotherhoodOfSword

        /// Horde1
        case griffinBastion(isUpgraded: Bool = false)
    }
}

public extension Building.ID.Castle {
    
    static let horde1: Self = .griffinBastion(isUpgraded: false) // TODO do we need to model upgraded here too?
    
    static let special1: Self = .lighthouse
    static let special2: Self = .stables
    static let special3: Self = .brotherhoodOfSword
}

public extension Building.ID.Castle {
    
    var name: String {
        switch self {
        case .mageGuildLevel1: return "mageGuildLevel1"
        case .mageGuildLevel2: return "mageGuildLevel2"
        case .mageGuildLevel3: return "mageGuildLevel3"
        case .mageGuildLevel4: return "mageGuildLevel4"
        case .tavern: return "tavern"
        case .shipyard: return "shipyard"
        case .ship: return "ship"
        case .fort: return "fort"
        case .citadel: return "citadel"
        case .castle: return "castle"
        case .villageHall: return "villageHall"
        case .townHall: return "townHall"
        case .cityHall: return "cityHall"
        case .capitol: return "capitol"
        case .marketplace: return "marketplace"
        case .resourceSilo: return "resourceSilo"
        case .blacksmith: return "blacksmith"
        case .lighthouse: return "lighthouse"
        case .griffinBastion: return "griffinBastion"
        case .stables: return "stables"
        case .brotherhoodOfSword: return "brotherhoodOfSword"
        case .colossus: return "colossus"
        case .guardhouse(let isUpgraded): return "\(isUpgraded ? "Upgraded " :"")guardhouse"
        case .archersTower(let isUpgraded): return "\(isUpgraded ? "Upgraded " :"")archersTower"
        case .griffinTower(let isUpgraded): return "\(isUpgraded ? "Upgraded " :"")griffinTower"
        case .barracks(let isUpgraded): return "\(isUpgraded ? "Upgraded " :"")barracks"
        case .monastery(let isUpgraded): return "\(isUpgraded ? "Upgraded " :"")monastery"
        case .trainingGrounds(let isUpgraded): return "\(isUpgraded ? "Upgraded " :"")trainingGrounds"
        case .portalOfGlory(let isUpgraded): return "\(isUpgraded ? "Upgraded " :"")portalOfGlory"
        }
    }
    
    var common: Building.ID.Common {
        switch self {
        case .special1: return .special1
        case .special3: return .special3
        case .shipyard: return .shipyard
        case .mageGuildLevel4: return .mageGuildLevel4
        default: return shared()
        }
    }
    
    init(common: Building.ID.Common) {
        switch common {
        case .villageHall: self = .villageHall
        case .townHall: self = .townHall
        case .cityHall: self = .cityHall
        case .capitol: self = .capitol
            
        case .fort: self = .fort
        case .citadel: self = .citadel
        case .castle: self = .castle
            
        case .mageGuildLevel1: self = .mageGuildLevel1
        case .mageGuildLevel2: self = .mageGuildLevel2
        case .mageGuildLevel3: self = .mageGuildLevel3
        case .mageGuildLevel4: self = .mageGuildLevel4
            
        case .marketplace: self = .marketplace
        case .resourceSilo: self = .resourceSilo
        case .blacksmith: self = .blacksmith
            
        case .tavern: self = .tavern
        case .grail: self = .grail
            
        case .dwellingLevel1: self = .dwellingLevel1
        case .dwellingLevel2: self = .dwellingLevel2
        case .dwellingLevel3: self = .dwellingLevel3
        case .dwellingLevel4: self = .dwellingLevel4
        case .dwellingLevel5: self = .dwellingLevel5
        case .dwellingLevel6: self = .dwellingLevel6
        case .dwellingLevel7: self = .dwellingLevel7
            
        case .dwellingLevel1Upgraded: self = .dwellingLevel1Upgraded
        case .dwellingLevel2Upgraded: self = .dwellingLevel2Upgraded
        case .dwellingLevel3Upgraded: self = .dwellingLevel3Upgraded
        case .dwellingLevel4Upgraded: self = .dwellingLevel4Upgraded
        case .dwellingLevel5Upgraded: self = .dwellingLevel5Upgraded
        case .dwellingLevel6Upgraded: self = .dwellingLevel6Upgraded
        case .dwellingLevel7Upgraded: self = .dwellingLevel7Upgraded
            
        case .special1: self = .special1
        case .special2: self = .special2
        case .special3: self = .special3
        case .horde1, .horde2: self = .horde1
            
        case .shipyard: self = .shipyard
            
        default: incorrectImplementation(shouldAlreadyHave: "Handled all buildings")
            
        }
    }
}


public extension Building.ID {
    enum Common: UInt8, BuildingIDConvertible, Hashable, CaseIterable, Codable, CustomDebugStringConvertible {
        case townHall = 0
        case cityHall = 1
        case capitol = 2

        case fort = 3
        case citadel = 4
        case castle = 5

        case tavern = 6
        case blacksmith = 7

        case marketplace = 8
        case resourceSilo = 9
        
        /// Really strange that 3DO chose to treat Artifact Merchant differently. Should be mapped to `special1`
        case special1_artifactMerchant = 10 // Special1
        
        case mageGuildLevel1 = 11
        case mageGuildLevel2 = 12
        case mageGuildLevel3 = 13
        case mageGuildLevel4 = 14
        case mageGuildLevel5 = 15

        case shipyard = 16
        case grail = 17
        
        
        /// Castle: lighthouse
        /// [Conflux, Dungeon, Tower]: artifactMerchant
        /// Fortress: cageOfWarlords
        /// Necropolis: coverOfDarkness
        /// Rampart: mysticPond
        /// Stronghold: escapeTunnel
        ///
        /// NOTE that Inferno lacks `special1`.
        case special1 = 18
        
        /// Castle: stables
        /// Conflux: magicUniversity
        /// Dungeon: manaVortex
        /// Fortress: bloodObelisk
        /// Inferno: brimstoneStormclouds
        /// Necropolis: necromancyAmplifier
        /// Rampart: fountainOfFortune
        /// Stronghold: freelancersGuild
        /// Tower: lookoutTower
        case special2 = 19
        
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
        case special3 = 20
        
        /// Dungeon: battleScholarAcademy
        /// Inferno: orderOfFire
        /// Stronghold: hallOfValhalla
        /// Tower: wallOfKnowledge
        ///
        /// NOTE that these town lacks `special4`: [Castle, Conflux, Dungeon, Fortress, Necropolis, Rampart]
        ///
        case special4 = 21
        case dwellingLevel1 = 22
        case dwellingLevel1Upgraded = 23
        
        /// Castle: griffinBastion
        /// Castle: minersGuild
        case horde1 = 24
        
        case dwellingLevel2 = 25
        case dwellingLevel2Upgraded = 26
        case horde2 = 27
        case dwellingLevel3 = 28
        case dwellingLevel3Upgraded = 29
        case horde3 = 30
        case dwellingLevel4 = 31
        case dwellingLevel4Upgraded = 32
        case horde4 = 33
        case dwellingLevel5 = 34
        case dwellingLevel5Upgraded = 35
        case horde5 = 36
        case dwellingLevel6 = 37
        case dwellingLevel6Upgraded = 38
        case dwellingLevel7 = 39
        case dwellingLevel7Upgraded = 40
        
        
        case villageHall = 255
    }
}


//
//// MARK: Special
//public extension Building.ID.Common {
//
//
//    /// Special1 for towns: [Conflux, Dungeon, Tower]
//    static let artifactMerchant: Self = .special1
//
//    /// Special1 for Castle
//    static let lighthouse: Self = .special1
//    /// Special2 for Castle
//    static let stables: Self = .special2
//    /// Special3 for Castle
//    static let brotherhoodOfSword: Self = special3
//
//    /// Special1 for Fortress
//    static let cageOfWarlords: Self = .special1
//    /// Special2 for Fortress
//    static let bloodObelisk: Self = .special2
//    /// Special3 for Fortress
//    static let glyphsOfFear: Self = special3
//
//    /// Special1 for Necropolis
//    static let coverOfDarkness: Self = .special1
//    /// Special2 for Necropolis
//    static let necromancyAmplifier: Self = .special2
//    /// Special3 for Necropolis
//    static let skeletonTransformer: Self = special3
//
//    /// Special1 for Rampart
//    static let mysticPond: Self = .special1
//    /// Special2 for Rampart
//    static let fountainOfFortune: Self = .special2
//    /// Special3 for Rampart
//    static let treasury: Self = special3
//
//    /// Special1 for Stronghold
//    static let escapeTunnel: Self = .special1
//    /// Special2 for Stronghold
//    static let freelancersGuild: Self = .special2
//    /// Special3 for Stronghold
//    static let ballistaYard: Self = special3
//    /// Special4 for Stronghold
//    static let hallOfValhalla: Self = .special4
//
//
//    /// Special2 for Conflux
//    static let magicUniversity: Self = .special2
//
//    /// Special2 for Dungeon
//    static let manaVortex: Self = .special2
//    /// Special3 for Dungeon
//    static let portalOfSummoning: Self = special3
//    /// Special4 for Dungeon
//    static let battleScholarAcademy: Self = .special4
//
//
//    /// Special2 for Inferno
//    static let brimstoneStormclouds: Self = .special2
//    /// Special3 for Inferno
//    static let castleGate: Self = special3
//    /// Special4 for Inferno
//    static let orderOfFire: Self = .special4
//
//
//    /// Special2 for Tower
//    static let lookoutTower: Self = .special2
//    /// Special3 for Tower
//    static let library: Self = special3
//    /// Special4 for Tower
//    static let wallOfKnowledge: Self = .special4
//
//}
//
//// MARK: Horde
//public extension Building.ID.Common {
//    /// Castle horde 1
//    static let griffinBastion: Self = .horde1
//    /// Castle horde 2 ???
//    static let griffinBastionUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
//
//    /// Rampart horde 1
//    static let minersGuild: Self = .horde1
//    /// Rampart horde 2 ???
//    static let minersGuildUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
//
//    /// Tower horde 1
//    static let sculptorsWings: Self = .horde1
//    /// Tower horde 2 ???
//    static let sculptorsWingsUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
//
//    /// Inferno horde 1
//    static let birthingPools: Self = .horde1
//    /// Inferno horde 2 ???
//    static let birthingPoolsUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
//
//    /// Necropolis horde 1
//    static let unearthedGraves: Self = .horde1
//    /// Necropolis horde 2 ???
//    static let unearthedGravesUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
//
//    /// Dungeon horde 1
//    static let mushroomRings: Self = .horde1
//    /// Dungeon horde 2 ???
//    static let mushroomRingsUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
//
//    /// Stronghold horde 1
//    static let messHall: Self = .horde1
//    /// Stronghold horde 2 ???
//    static let messHallUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
//
//    /// Fortress horde 1
//    static let captainsQuarters: Self = .horde1
//    /// Fortress horde 2 ???
//    static let captainsQuartersUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
//
//    /// Conflux horde 1
//    static let gardenOfLife: Self = .horde1
//    /// Conflux horde 2 ???
//    static let gardenOfLifeUpg_NOT_SURE_THIS_IS_HORDE2: Self = .horde2
//
//    /// Rampart horde 3
//    static let dendroidSaplings: Self = .horde3
//    /// Rampart horde 4 ???
//    static let dendroidSaplingsUpg_NOT_SURE_THIS_IS_HORDE4: Self = .horde4
//
//    /// Inferno horde 3
//    static let cages: Self = .horde3
//    /// Inferno horde 4 ???
//    static let cagesUpg_NOT_SURE_THIS_IS_HORDE4: Self = .horde4
//
//}

// MARK: CustomDebugStringConvertible
public extension Building.ID.Common {

    var debugDescription: String {
        name
    }

    var name: String {
        switch self {
        case .villageHall: return "villageHall"
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
        case .special1_artifactMerchant: return "artifactMerchants"
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
        case .dwellingLevel1: return "dwellingLevel1"
        case .dwellingLevel1Upgraded: return "dwellingLevel1Upgraded"
        case .horde1: return "horde1"
        case .dwellingLevel2: return "dwellingLevel2"
        case .dwellingLevel2Upgraded: return "dwellingLevel2Upgraded"
        case .horde2: return "horde2"
        case .dwellingLevel3: return "dwellingLevel3"
        case .dwellingLevel3Upgraded: return "dwellingLevel3Upgraded"
        case .horde3: return "horde3"
        case .dwellingLevel4: return "dwellingLevel4"
        case .dwellingLevel4Upgraded: return "dwellingLevel4Upgraded"
        case .horde4: return "horde4"
        case .dwellingLevel5: return "dwellingLevel5"
        case .dwellingLevel5Upgraded: return "dwellingLevel5Upgraded"
        case .horde5: return "horde5"
        case .dwellingLevel6: return "dwellingLevel6"
        case .dwellingLevel6Upgraded: return "dwellingLevel6Upgraded"
        case .dwellingLevel7: return "dwellingLevel7"
        case .dwellingLevel7Upgraded: return "dwellingLevel7Upgraded"
        }
    }
}
