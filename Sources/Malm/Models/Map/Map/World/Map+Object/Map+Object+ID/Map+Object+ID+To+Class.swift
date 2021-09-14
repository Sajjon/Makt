//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-14.
//

import Foundation

// MARK: ID => Class
public extension Map.Object.ID {
    var `class`: Map.Object.Class {
        switch self {
        case /* .none0, .blank40,*/ .brush, .bush, .cactus, .canyon, .crater, .deadVegetation, .flowers, .frozenLake, .hedge, .hill, .lake, .lavaFlow, .lavaLake, .mushrooms, .log, .mandrake, .moss, .mound, .mountain, .oakTrees, .outcropping, .pineTrees, .plant, .riverDelta, .rock, .sandDune, .sandPit, .shrub, .skull, .stalagmite, .stump, .tarPit, .trees, .vine, .volcanicVent, .volcano, .willowTrees, .yuccaTrees, .reef:
            return .genericImpassableTerrain

        // MARK: AB
        case .brush2, .bush2, .cactus2, .canyon2, .crater2, .deadVegetation2, .flowers2, .frozenLake2, .hedge2, .hill2, .lake2, .lavaFlow2, .lavaLake2, .mushrooms2, .log2, .mandrake2, .moss2, .mound2, .mountain2, .oakTrees2, .outcropping2, .pineTrees2, .plant2, .riverDelta2, .rock2, .sandDune2, .sandPit2, .shrub2, .skull2, .stalagmite2, .stump2, .tarPit2, .trees2, .vine2, .volcanicVent2, .volcano2, .willowTrees2, .yuccaTrees2, .reef2, .desertHills, .dirtHills, .grassHills, .roughHills, .subterraneanRocks, .swampFoliage:
            return .genericImpassableTerrain

        case .altarOfSacrifice, .anchorPoint, .arena, .blackMarket, .cartographer, .buoy, .swanPond, .coverOfDarkness, .creatureBank, .corpse, .marlettoTower, .derelictShip, .dragonUtopia, .eyeOfTheMagi, .faerieRing, .fountainOfFortune, .fountainOfYouth, .gardenOfRevelation, .hillFort, .hutOfTheMagi, .idolOfFortune, .leanTo, .libraryOfEnlightenment, .schoolOfMagic, .magicSpring, .magicWell, .mercenaryCamp, .mermaid, .mysticalGarden, .oasis, .obelisk, .redwoodObservatory, .pillarOfFire, .starAxis, .rallyFlag, .borderguard, .keymastersTent, .refugeeCamp, .sanctuary, .crypt, .shipwreck, .sirens, .stables, .tavern, .temple, .denOfThieves, .tradingPost, .learningStone, .treeofKnowledge, .university, .wagon, .warMachineFactory, .schoolOfWar, .warriorsTomb, .waterWheel, .wateringHole, .whirlpool, .windmill, .marketOfTime, .decorativeTown:
            return .genericVisitable

        case .tradingPostSnow, .pyramid, .borderGate, .freelancersGuild:
            return .genericVisitable // AB, SOD

        case .artifact, .randomArtifact, .randomTreasureArtifact, .randomMinorArtifact, .randomMajorArtifact, .randomRelic:
            return .artifact

        case .abandonedMine:
            return .abandonedMine

        case .creatureGenerator1, .creatureGenerator2, .creatureGenerator3, .creatureGenerator4:
            return .dwelling

        case .event:
            return .event

        case .garrison, .garrison2:
            return .garrison

        case .boat:
            return .genericBoat

        case .cloverField, .evilFog, .favorableWinds, .fieryFields, .holyGround, .lucidPools, .magicClouds, .rocklands, .cursedGround2, .magicPlains2, .genericPassable:
            return .genericPassableTerrain // SOD

        case .hole, .cursedGround, .magicPlains, .kelp, .kelp2, .hole2:
            return .genericPassableTerrain

        case .pandorasBox:
            return .pandorasBox

        case .grail:
            return .grail

        case .hero:
            return .hero
        case .lighthouse:
            return .lighthouse

        case .monolithTwoWay:
            return .monolithTwoWay

        case .monolithOneWayEntrance, .monolithOneWayExit:
            return .genericVisitable // AB SOD

        case .monster, .randomMonster, .randomMonsterLevel1, .randomMonsterLevel2, .randomMonsterLevel3, .randomMonsterLevel4, .randomMonsterLevel5, .randomMonsterLevel6, .randomMonsterLevel7:
            return .monster

        case .oceanBottle:
            return .oceanBottle

        case .prison:
            return .prison
        
        case .questGuard:
            return .questGuard
        
        case .randomDwelling:
            return .randomDwelling
        
        case .randomDwellingAtLevel:
            return .randomDwellingAtLevel

        case .randomDwellingOfFaction:
            return .randomDwellingOfFaction

        case .randomHero:
            return .randomHero

        case .heroPlaceholder:
            return .placeholderHero

        case .resource, .randomResource:
            return .resource

        case .resourceGenerator:
            return .resourceGenerator
        
        case .scholar:
            return .scholar
        
        case .seersHut:
            return .seersHut

        case .shipyard:
            return .shipyard
        
        case .shrineOfMagicIncantation, .shrineOfMagicGesture, .shrineOfMagicThought:
            return .shrine
        
        case .sign:
            return .sign
            
        case .spellScroll:
            return .spellScroll
            
        case .subterraneanGate:
            return .subterraneanGate
            
        case .town, .randomTown:
            return .town
            
        case .witchHut:
            return .witchHut
        
        case .campfire, .flotsam, .seaChest, .shipwreckSurvivor, .treasureChest:
            return .genericTreasure
        
        }
    }
}
