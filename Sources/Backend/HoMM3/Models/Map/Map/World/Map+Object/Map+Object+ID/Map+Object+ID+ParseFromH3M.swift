//
//  Map+Object+Kind+FromIDs.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation

public enum IDFromRawValueError<Model>: Swift.Error where Model: RawRepresentable {
    case genericUnrecognizedRawValue(Model.RawValue, tryingToInit: Model.Type = Model.self)
    case genericInteger(tooLarge: Int, tryingPassAsRawValueWhenInit: Model.Type = Model.self)
}
public extension RawRepresentable where RawValue: FixedWidthInteger {
    init(id rawValue: RawValue) throws {
        guard let selfValue = Self(rawValue: rawValue) else {
            throw IDFromRawValueError<Self>.genericUnrecognizedRawValue(rawValue)
        }
        self = selfValue
    }
}
public extension RawRepresentable where RawValue == UInt8 {
    init<I>(integer: I) throws where I: FixedWidthInteger {
        do {
            let rawValue = try UInt8(integer: integer)
            try self.init(id: rawValue)
        } catch {
            throw IDFromRawValueError<Self>.genericInteger(tooLarge: Int(integer))
        }
    }
}

extension Map.Object.ID {
    
 
    
     enum Error: Swift.Error {
         case unrecognizedObjectClassIdentifier(Stripped.RawValue)
     }
    
    init(id: UInt32, subId: UInt32) throws {
        guard let stripped = Stripped(rawValue: id) else {
            throw Error.unrecognizedObjectClassIdentifier(id)
        }
        try self.init(stripped: stripped, subId: subId)
    }
}

private extension Map.Object.ID {
    init(stripped: Stripped, subId: UInt32) throws {
        
        switch stripped {
        case .artifact:
            self = try .artifact(.init(integer: subId))
        case .borderguard:
            self = try .borderguard(.init(integer: subId))
        case .keymastersTent:
            self = try .keymastersTent(.init(integer: subId))
        case .creatureBank:
            self = try .creatureBank(.init(integer: subId))
        case .creatureGenerator1:
            self = try .creatureGenerator1(.init(integer: subId))
        case .creatureGenerator4:
            guard subId <= 1 else { fatalError("Expected 0 or 1 for Object.CreatureGenerator4") }
            self = .creatureGenerator4(unknownBool: subId != 0)
        case .garrison:
            guard subId <= 1 else { fatalError("Expected 0 or 1 for Garrison, where subid tells if it has antiMagic or not.") }
            self = .garrison(hasAntiMagic: subId != 0)
        case .hero:
            self = try .hero(.init(integer: subId))
        case .monolithOneWayEntrance:
            self = try .monolithOneWayEntrance(.init(integer: subId))
        case .monolithOneWayExit:
            self = try .monolithOneWayExit(.init(integer: subId))
        case .monolithTwoWay:
            self = try .monolithTwoWay(.init(integer: subId))
        case .mine:
            self = try .mine(.init(integer: subId))
        case .monster:
            self = try .monster(.init(integer: subId))
        case .spellScroll:
            self = try .spellScroll(.init(integer: subId))
        case .town:
            self = try .town(.init(integer: subId))
        case .witchHut:
            self = try .witchHut(.init(integer: subId))
        case .borderGate:
            self = try .borderGate(.init(integer: subId))
        case .randomDwellingWithLevel:
            self = try .randomDwellingAtLevel(.init(integer: subId))
        case .randomDwellingFactoion:
            self = try .randomDwellingOfFaction(.init(integer: subId))
        case .resource:
            self = try .resource(.init(integer: subId))
     
            // MARK: without sub id
        case .abandonedMine: self = .abandonedMine
        case .altarOfSacrifice: self = .altarOfSacrifice
        case .anchorPoint: self = .anchorPoint
        case .arena: self = .arena
        case .pandorasBox: self = .pandorasBox
        case .blackMarket: self = .blackMarket
        case .boat: self = .boat
        case .buoy: self = .buoy
        case .campfire: self = .campfire
        case .cartographer: self = .cartographer
        case .swanPond: self = .swanPond
        case .coverOfDarkness: self = .coverOfDarkness
        case .creatureGenerator2: self = .creatureGenerator2
        case .creatureGenerator3: self = .creatureGenerator3
        case .cursedGround: self = .cursedGround
        case .corpse: self = .corpse
        case .marlettoTower: self = .marlettoTower
        case .derelictShip: self = .derelictShip
        case .event: self = .event
        case .eyeOfTheMagi: self = .eyeOfTheMagi
        case .faerieRing: self = .faerieRing
        case .flotsam: self = .flotsam
        case .fountainOfFortune: self = .fountainOfFortune
        case .fountainOfYouth: self = .fountainOfYouth
        case .gardenOfRevelation: self = .gardenOfRevelation
        case .hillFort: self = .hillFort
        case .grail: self = .grail
        case .hutOfTheMagi: self = .hutOfTheMagi
        case .idolOfFortune: self = .idolOfFortune
        case .leanTo: self = .leanTo
        case .libraryOfEnlightenment: self = .libraryOfEnlightenment
        case .lighthouse: self = .lighthouse
        case .magicPlains: self = .magicPlains
        case .schoolOfMagic: self = .schoolOfMagic
        case .magicSpring: self = .magicSpring
        case .magicWell: self = .magicWell
            
        case .marketOfTime: self = .marketOfTime
        case .mercenaryCamp: self = .mercenaryCamp
        case .mermaid: self = .mermaid
        case .mysticalGarden: self = .mysticalGarden
        case .oasis: self = .oasis
        case .obelisk: self = .obelisk
        case .redwoodObservatory: self = .redwoodObservatory
        case .oceanBottle: self = .oceanBottle
        case .pillarOfFire: self = .pillarOfFire
        case .starAxis: self = .starAxis
        case .prison: self = .prison
        case .pyramid: self = .pyramid
        case .rallyFlag: self = .rallyFlag
            
        case .randomArtifact: self = .randomArtifact
        case .randomTreasureArtifact: self = .randomTreasureArtifact
        case .randomMinorArtifact: self = .randomMinorArtifact
        case .randomMajorArtifact: self = .randomMajorArtifact
        case .randomRelic: self = .randomRelic
            
        case .randomHero: self = .randomHero
        case .randomMonster: self = .randomMonster
        case .randomMonsterLevel1: self = .randomMonsterLevel1
        case .randomMonsterLevel2: self = .randomMonsterLevel2
        case .randomMonsterLevel3: self = .randomMonsterLevel3
        case .randomMonsterLevel4: self = .randomMonsterLevel4
            
        case .randomResource: self = .randomResource
        case .randomTown: self = .randomTown
        case .refugeeCamp: self = .refugeeCamp
        case .sanctuary: self = .sanctuary
        case .scholar: self = .scholar
        case .seaChest: self = .seaChest
        case .seersHut: self = .seersHut
        case .crypt: self = .crypt
        case .shipwreck: self = .shipwreck
        case .shipwreckSurvivor: self = .shipwreckSurvivor
        case .shipyard: self = .shipyard
        case .shrineOfMagicIncantation: self = .shrineOfMagicIncantation
        case .shrineOfMagicGesture: self = .shrineOfMagicGesture
        case .shrineOfMagicThought: self = .shrineOfMagicThought
        case .sign: self = .sign
        case .sirens: self = .sirens
        case .stables: self = .stables
        case .tavern: self = .tavern
        case .temple: self = .temple
        case .denOfThieves: self = .denOfThieves
        case .tradingPost: self = .tradingPost
        case .learningStone: self = .learningStone
        case .treasureChest: self = .treasureChest
        case .treeofKnowledge: self = .treeofKnowledge
        case .subterraneanGate: self = .subterraneanGate
        case .university: self = .university
        case .wagon: self = .wagon
        case .warMachineFactory: self = .warMachineFactory
        case .schoolOfWar: self = .schoolOfWar
        case .warriorsTomb: self = .warriorsTomb
        case .waterWheel: self = .waterWheel
        case .wateringHole: self = .wateringHole
        case .whirlpool: self = .whirlpool
        case .windmill: self = .windmill
        case .brush: self = .brush
        case .bush: self = .bush
        case .cactus: self = .cactus
        case .canyon: self = .canyon
        case .crater: self = .crater
        case .deadVegetation: self = .deadVegetation
        case .flowers: self = .flowers
        case .frozenLake: self = .frozenLake
        case .hedge: self = .hedge
        case .hill: self = .hill
        case .hole: self = .hole
        case .kelp: self = .kelp
        case .lake: self = .lake
        case .lavaFlow: self = .lavaFlow
        case .lavaLake: self = .lavaLake
        case .mushrooms: self = .mushrooms
        case .log: self = .log
        case .mandrake: self = .mandrake
        case .moss: self = .moss
        case .mound: self = .mound
        case .mountain: self = .mountain
        case .oakTrees: self = .oakTrees
        case .outcropping: self = .outcropping
        case .pineTrees: self = .pineTrees
        case .plant: self = .plant
        case .riverDelta: self = .riverDelta
        case .rock: self = .rock
        case .sandDune: self = .sandDune
        case .sandPit: self = .sandPit
        case .shrub: self = .shrub
        case .skull: self = .skull
        case .stalagmite: self = .stalagmite
        case .stump: self = .stump
        case .tarPit: self = .tarPit
        case .trees: self = .trees
        case .vine: self = .vine
        case .volcanicVent: self = .volcanicVent
        case .volcano: self = .volcano
        case .willowTrees: self = .willowTrees
        case .yuccaTrees: self = .yuccaTrees
        case .reef: self = .reef
        case .randomMonsterLevel5: self = .randomMonsterLevel5
        case .randomMonsterLevel6: self = .randomMonsterLevel6
        case .randomMonsterLevel7: self = .randomMonsterLevel7
            
            
            
        case .brush2: self = .brush2
        case .bush2: self = .bush2
        case .cactus2: self = .cactus2
        case .canyon2: self = .canyon2
        case .crater2: self = .crater2
        case .deadVegetation2: self = .deadVegetation2
        case .flowers2: self = .flowers2
        case .frozenLake2: self = .frozenLake2
        case .hedge2: self = .hedge2
        case .hill2: self = .hill2
        case .hole2: self = .hole2
        case .kelp2: self = .kelp2
        case .lake2: self = .lake2
        case .lavaFlow2: self = .lavaFlow2
        case .lavaLake2: self = .lavaLake2
        case .mushrooms2: self = .mushrooms2
        case .log2: self = .log2
        case .mandrake2: self = .mandrake2
        case .moss2: self = .moss2
        case .mound2: self = .mound2
        case .mountain2: self = .mountain2
        case .oakTrees2: self = .oakTrees2
        case .outcropping2: self = .outcropping2
        case .pineTrees2: self = .pineTrees2
        case .plant2: self = .plant2
        case .riverDelta2: self = .riverDelta2
        case .rock2: self = .rock2
        case .sandDune2: self = .sandDune2
        case .sandPit2: self = .sandPit2
        case .shrub2: self = .shrub2
        case .skull2: self = .skull2
        case .stalagmite2: self = .stalagmite2
        case .stump2: self = .stump2
        case .tarPit2: self = .tarPit2
        case .trees2: self = .trees2
        case .vine2: self = .vine2
        case .volcanicVent2: self = .volcanicVent2
        case .volcano2: self = .volcano2
        case .willowTrees2: self = .willowTrees2
        case .yuccaTrees2: self = .yuccaTrees2
        case .reef2: self = .reef2
            
            
            
            
            
            
            
        case .desertHills: self = .desertHills
        case .dirtHills: self = .dirtHills
        case .grassHills: self = .grassHills
        case .roughHills: self = .roughHills
        case .subterraneanRocks: self = .subterraneanRocks
        case .swampFoliage: self = .swampFoliage
        case .freelancersGuild: self = .freelancersGuild
        case .heroPlaceholder: self = .heroPlaceholder
        case .questGuard: self = .questGuard
        case .randomDwelling: self = .randomDwelling
        case .garrison2: self = .garrison2
        case .tradingPostSnow: self = .tradingPostSnow
        case .cloverField: self = .cloverField
        case .cursedGround2: self = .cursedGround2
        case .evilFog: self = .evilFog
        case .favorableWinds: self = .favorableWinds
        case .fieryFields: self = .fieryFields
        case .holyGround: self = .holyGround
        case .lucidPools: self = .lucidPools
        case .magicClouds: self = .magicClouds
        case .magicPlains2: self = .magicPlains2
        case .rocklands: self = .rocklands
        case .dragonUtopia: self = .dragonUtopia
        case .decorativeTown:
            self = .decorativeTown
        case .passable139:
            self = .genericPassable(subID: 139)
        case .passable141:
            self = .genericPassable(subID: 141)
        case .passable142:
            self = .genericPassable(subID: 142)
        case .passable144:
            self = .genericPassable(subID: 144)
        case .passable145:
            self = .genericPassable(subID: 144)
        case .passable146:
            self = .genericPassable(subID: 146)
        }
    }
}
