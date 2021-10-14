//
//  Map+Object+CreatureGenerator.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation

public extension Map.Object {
    enum CreatureGenerator: Equatable {}
}

public extension Map.Object.CreatureGenerator {
    enum ID: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible, Codable {
        /// For creature: "basilisk"
        case basiliskPit = 0

        /// For creature: "behemoth"
        case behemothCrag = 1

        /// For creature: "beholder"
        case pillarOfEyes = 2

        /// For creature: "blackKnight"
        case hallOfDarkness = 3

        /// For creature: "boneDragon"
        case dragonVault = 4

        /// For creature: "cavalier"
        case trainingGrounds = 5

        /// For creature: "centaur"
        case centaurStables = 6

        /// For creature: "airElemental"
        case airConflux = 7

        /// For creature: "angel"
        case portalOfGlory = 8

        /// For creature: "cyclop"
        case cyclopsCave = 9

        /// For creature: "devil"
        case forsakenPalace = 10

        /// For creature: "serpentFly"
        case serpentFlyHive = 11

        /// For creature: "dwarf"
        case dwarfCottage = 12

        /// For creature: "earthElemental"
        case earthConflux = 13

        /// For creature: "efreet"
        case fireLake = 14

        /// For creature: "woodElf"
        case homestead = 15

        /// For creature: "fireElemental"
        case fireConflux = 16

        /// For creature: "stoneGargoyle"
        case parapet = 17

        /// For creature: "genie"
        case altarOfWishes = 18

        /// For creature: "goblinWolfRider"
        case wolfPen = 19

        /// For creature: "gnoll"
        case gnollHut = 20

        /// For creature: "goblin"
        case goblinBarracks = 21

        /// For creature: "gog"
        case hallOfSins = 22

        /// For creature: "gorgon"
        case gorgonLair = 23

        /// For creature: "greenDragon"
        case dragonCliffs = 24

        /// For creature: "griffin"
        case griffinTower = 25

        /// For creature: "harpy"
        case harpyLoft = 26

        /// For creature: "hellHound"
        case kennels = 27

        /// For creature: "hydra"
        case hydraPond = 28

        /// For creature: "imp"
        case impCrucible = 29

        /// For creature: "lizardman"
        case lizardDen = 30

        /// For creature: "mage"
        case mageTower = 31

        /// For creature: "manticore"
        case manticoreLair = 32

        /// For creature: "medusa"
        case medusaChapel = 33

        /// For creature: "minotaur"
        case labyrinth = 34

        /// For creature: "monk"
        case monastery = 35

        /// For creature: "naga"
        case goldenPavilion = 36

        /// For creature: "demon"
        case demonGate = 37

        /// For creature: "ogre"
        case ogreFort = 38

        /// For creature: "orc"
        case orcTower = 39

        /// For creature: "pitFiend"
        case hellHole = 40

        /// For creature: "redDragon"
        case dragonCave = 41

        /// For creature: "roc"
        case cliffNest = 42

        /// For creature: "gremlin"
        case workshop = 43

        /// For creature: "giant"
        case cloudTemple = 44

        /// For creature: "dendroidGuard"
        case dendroidArches = 45

        /// For creature: "troglodyte"
        case warren = 46

        /// For creature: "waterElemental"
        case waterConflux = 47

        /// For creature: "wight"
        case tombOfSouls = 48

        /// For creature: "wyvern"
        case wyvernNest = 49

        /// For creature: "pegasus"
        case enchantedSpring = 50

        /// For creature: "unicorn"
        case unicornGladeBig = 51

        /// For creature: "lich"
        case mausoleum = 52

        /// For creature: "vampire"
        case estate = 53

        /// For creature: "skeleton"
        case cursedTemple = 54

        /// For creature: "walkingDead"
        case graveyard = 55

        /// For creature: "pikeman"
        case guardhouse = 56

        /// For creature: "archer"
        case archersTower = 57

        /// For creature: "swordsman"
        case barracks = 58

        /// For creature: "pixie"
        case magicLantern = 59

        /// For creature: "psychicElemental"
        case altarOfThought = 60

        /// For creature: "firebird"
        case pyre = 61

        /// For creature: "azureDragon"
        case frozenCliffs = 62

        /// For creature: "crystalDragon"
        case crystalCavern = 63

        /// For creature: "fairieDragon"
        case magicForest = 64

        /// For creature: "rustDragon"
        case sulfurousLair = 65

        /// For creature: "enchanter"
        case enchantersHollow = 66

        /// For creature: "sharpshooter"
        case treetopTower = 67

        /// For creature: "unicorn"
        case unicornGlade = 68

        /// For creature: "airElemental"
        case altarOfAir = 69

        /// For creature: "earthElemental"
        case altarOfEarth = 70

        /// For creature: "fireElemental"
        case altarOfFire = 71

        /// For creature: "waterElemental"
        case altarOfWater = 72

        /// For creature: "halfling"
        case thatchedHut = 73

        /// For creature: "peasant"
        case hovel = 74

        /// For creature: "boar"
        case boarGlen = 75

        /// For creature: "mummy"
        case tombOfCurses = 76

        /// For creature: "nomad"
        case nomadTent = 77

        /// For creature: "rogue"
        case rogueCavern = 78

        /// For creature: "troll"
        case trollBridge = 79
    }

}


public extension Map.Object.CreatureGenerator.ID {
    var debugDescription: String {
        switch self {
        case .basiliskPit: return "basiliskPit"
        case .behemothCrag: return "behemothCrag"
        case .pillarOfEyes: return "pillarOfEyes"
        case .hallOfDarkness: return "hallOfDarkness"
        case .dragonVault: return "dragonVault"
        case .trainingGrounds: return "trainingGrounds"
        case .centaurStables: return "centaurStables"
        case .airConflux: return "airConflux"
        case .portalOfGlory: return "portalOfGlory"
        case .cyclopsCave: return "cyclopsCave"
        case .forsakenPalace: return "forsakenPalace"
        case .serpentFlyHive: return "serpentFlyHive"
        case .dwarfCottage: return "dwarfCottage"
        case .earthConflux: return "earthConflux"
        case .fireLake: return "fireLake"
        case .homestead: return "homestead"
        case .fireConflux: return "fireConflux"
        case .parapet: return "parapet"
        case .altarOfWishes: return "altarOfWishes"
        case .wolfPen: return "wolfPen"
        case .gnollHut: return "gnollHut"
        case .goblinBarracks: return "goblinBarracks"
        case .hallOfSins: return "hallOfSins"
        case .gorgonLair: return "gorgonLair"
        case .dragonCliffs: return "dragonCliffs"
        case .griffinTower: return "griffinTower"
        case .harpyLoft: return "harpyLoft"
        case .kennels: return "kennels"
        case .hydraPond: return "hydraPond"
        case .impCrucible: return "impCrucible"
        case .lizardDen: return "lizardDen"
        case .mageTower: return "mageTower"
        case .manticoreLair: return "manticoreLair"
        case .medusaChapel: return "medusaChapel"
        case .labyrinth: return "labyrinth"
        case .monastery: return "monastery"
        case .goldenPavilion: return "goldenPavilion"
        case .demonGate: return "demonGate"
        case .ogreFort: return "ogreFort"
        case .orcTower: return "orcTower"
        case .hellHole: return "hellHole"
        case .dragonCave: return "dragonCave"
        case .cliffNest: return "cliffNest"
        case .workshop: return "workshop"
        case .cloudTemple: return "cloudTemple"
        case .dendroidArches: return "dendroidArches"
        case .warren: return "warren"
        case .waterConflux: return "waterConflux"
        case .tombOfSouls: return "tombOfSouls"
        case .wyvernNest: return "wyvernNest"
        case .enchantedSpring: return "enchantedSpring"
        case .unicornGladeBig: return "unicornGladeBig"
        case .mausoleum: return "mausoleum"
        case .estate: return "estate"
        case .cursedTemple: return "cursedTemple"
        case .graveyard: return "graveyard"
        case .guardhouse: return "guardhouse"
        case .archersTower: return "archersTower"
        case .barracks: return "barracks"
        case .magicLantern: return "magicLantern"
        case .altarOfThought: return "altarOfThought"
        case .pyre: return "pyre"
        case .frozenCliffs: return "frozenCliffs"
        case .crystalCavern: return "crystalCavern"
        case .magicForest: return "magicForest"
        case .sulfurousLair: return "sulfurousLair"
        case .enchantersHollow: return "enchantersHollow"
        case .treetopTower: return "treetopTower"
        case .unicornGlade: return "unicornGlade"
        case .altarOfAir: return "altarOfAir"
        case .altarOfEarth: return "altarOfEarth"
        case .altarOfFire: return "altarOfFire"
        case .altarOfWater: return "altarOfWater"
        case .thatchedHut: return "thatchedHut"
        case .hovel: return "hovel"
        case .boarGlen: return "boarGlen"
        case .tombOfCurses: return "tombOfCurses"
        case .nomadTent: return "nomadTent"
        case .rogueCavern: return "rogueCavern"
        case .trollBridge: return "trollBridge"
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    }
}
