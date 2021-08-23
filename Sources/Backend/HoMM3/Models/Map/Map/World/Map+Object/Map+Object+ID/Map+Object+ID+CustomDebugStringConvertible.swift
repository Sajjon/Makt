//
//  Map+Object+ID+CustomDebugStringConvertible.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-21.
//

import Foundation

public extension Map.Object.ID {
    var debugDescription: String {
        
        switch self {
        case .artifact(let value):
            return "artifact: \(value)"
        case .borderguard(let value):
            return "borderguard: \(value)"
        case .keymastersTent(let value):
            return "keymastersTent: \(value)"
        case .creatureBank(let value):
            return "creatureBank: \(value)"
        case .creatureGenerator1(let value):
            return "creatureGenerator1: \(value)"
        case .creatureGenerator4(let value):
            return "creatureGenerator4: \(value)"
        case .garrison(let value):
            return "garrison: \(value)"
        case .hero(let value):
            return "hero: \(value)"
        case .monolithOneWayEntrance(let value):
            return "monolithOneWayEntrance: \(value)"
        case .monolithOneWayExit(let value):
            return "monolithOneWayExit: \(value)"
        case .monolithTwoWay(let value):
            return "monolithTwoWay: \(value)"
        case .mine(let value):
            return "mine: \(value)"
        case .monster(let value):
            return "monster: \(value)"
        case .spellScroll(let value):
            return "spellScroll: \(value)"
        case .town(let value):
            return "town: \(value)"
        case .witchHut(let value):
            return "witchHut: \(value)"
        case .borderGate(let value):
            return "borderGate: \(value)"
        case .randomDwellingAtLevel(let value):
            return "randomDwellingWithLevel: \(value)"
        case .randomDwellingOfFaction(let value):
            return "randomDwellingOfFaction: \(value)"
        case .resource(let value):
            return "resource: \(value)"
            
        // MARK: without sub id"
        case .abandonedMine: return "abandonedMine"
        case .altarOfSacrifice: return "altarOfSacrifice"
        case .anchorPoint: return "anchorPoint"
        case .arena: return "arena"
        case .pandorasBox: return "pandorasBox"
        case .blackMarket: return "blackMarket"
        case .boat: return "boat"
        case .buoy: return "buoy"
        case .campfire: return "campfire"
        case .cartographer: return "cartographer"
        case .swanPond: return "swanPond"
        case .coverOfDarkness: return "coverOfDarkness"
        case .creatureGenerator2: return "creatureGenerator2"
        case .creatureGenerator3: return "creatureGenerator3"
        case .cursedGround: return "cursedGround"
        case .corpse: return "corpse"
        case .marlettoTower: return "marlettoTower"
        case .derelictShip: return "derelictShip"
        case .event: return "event"
        case .eyeOfTheMagi: return "eyeOfTheMagi"
        case .faerieRing: return "faerieRing"
        case .flotsam: return "flotsam"
        case .fountainOfFortune: return "fountainOfFortune"
        case .fountainOfYouth: return "fountainOfYouth"
        case .gardenOfRevelation: return "gardenOfRevelation"
        case .hillFort: return "hillFort"
        case .grail: return "grail"
        case .hutOfTheMagi: return "hutOfTheMagi"
        case .idolOfFortune: return "idolOfFortune"
        case .leanTo: return "leanTo"
        case .libraryOfEnlightenment: return "libraryOfEnlightenment"
        case .lighthouse: return "lighthouse"
        case .magicPlains: return "magicPlains"
        case .schoolOfMagic: return "schoolOfMagic"
        case .magicSpring: return "magicSpring"
        case .magicWell: return "magicWell"
        case .marketOfTime: return "marketOfTime"
        case .mercenaryCamp: return "mercenaryCamp"
        case .mermaid: return "mermaid"
        case .mysticalGarden: return "mysticalGarden"
        case .oasis: return "oasis"
        case .obelisk: return "obelisk"
        case .redwoodObservatory: return "redwoodObservatory"
        case .oceanBottle: return "oceanBottle"
        case .pillarOfFire: return "pillarOfFire"
        case .starAxis: return "starAxis"
        case .prison: return "prison"
        case .pyramid: return "pyramid"
        case .rallyFlag: return "rallyFlag"
            
        case .randomArtifact: return "randomArtifact"
        case .randomTreasureArtifact: return "randomTreasureArtifact"
        case .randomMinorArtifact: return "randomMinorArtifact"
        case .randomMajorArtifact: return "randomMajorArtifact"
        case .randomRelic: return "randomRelic"
            
        case .randomHero: return "randomHero"
        case .randomMonster: return "randomMonster"
        case .randomMonsterLevel1: return "randomMonsterLevel1"
        case .randomMonsterLevel2: return "randomMonsterLevel2"
        case .randomMonsterLevel3: return "randomMonsterLevel3"
        case .randomMonsterLevel4: return "randomMonsterLevel4"
            
        case .randomResource: return "randomResource"
        case .randomTown: return "randomTown"
        case .refugeeCamp: return "refugeeCamp"
        case .sanctuary: return "sanctuary"
        case .scholar: return "scholar"
        case .seaChest: return "seaChest"
        case .seerSHut: return "seerSHut"
        case .crypt: return "crypt"
        case .shipwreck: return "shipwreck"
        case .shipwreckSurvivor: return "shipwreckSurvivor"
        case .shipyard: return "shipyard"
        case .shrineOfMagicIncantation: return "shrineOfMagicIncantation"
        case .shrineOfMagicGesture: return "shrineOfMagicGesture"
        case .shrineOfMagicThought: return "shrineOfMagicThought"
        case .sign: return "sign"
        case .sirens: return "sirens"
        case .stables: return "stables"
        case .tavern: return "tavern"
        case .temple: return "temple"
        case .denOfThieves: return "denOfThieves"
        case .tradingPost: return "tradingPost"
        case .learningStone: return "learningStone"
        case .treasureChest: return "treasureChest"
        case .treeofKnowledge: return "treeofKnowledge"
        case .subterraneanGate: return "subterraneanGate"
        case .university: return "university"
        case .wagon: return "wagon"
        case .warMachineFactory: return "warMachineFactory"
        case .schooloFWar: return "schooloFWar"
        case .warriorsTomb: return "warriorsTomb"
        case .waterWheel: return "waterWheel"
        case .wateringHole: return "wateringHole"
        case .whirlpool: return "whirlpool"
        case .windmill: return "windmill"
        case .brush: return "brush"
        case .bush: return "bush"
        case .cactus: return "cactus"
        case .canyon: return "canyon"
        case .crater: return "crater"
        case .deadVegetation: return "deadVegetation"
        case .flowers: return "flowers"
        case .frozenLake: return "frozenLake"
        case .hedge: return "hedge"
        case .hill: return "hill"
        case .hole: return "hole"
        case .kelp: return "kelp"
        case .lake: return "lake"
        case .lavaFlow: return "lavaFlow"
        case .lavaLake: return "lavaLake"
        case .mushrooms: return "mushrooms"
        case .log: return "log"
        case .mandrake: return "mandrake"
        case .moss: return "moss"
        case .mound: return "mound"
        case .mountain: return "mountain"
        case .oakTrees: return "oakTrees"
        case .outcropping: return "outcropping"
        case .pineTrees: return "pineTrees"
        case .plant: return "plant"
        case .riverDelta: return "riverDelta"
        case .rock: return "rock"
        case .sandDune: return "sandDune"
        case .sandPit: return "sandPit"
        case .shrub: return "shrub"
        case .skull: return "skull"
        case .stalagmite: return "stalagmite"
        case .stump: return "stump"
        case .tarPit: return "tarPit"
        case .trees: return "trees"
        case .vine: return "vine"
        case .volcanicVent: return "volcanicVent"
        case .volcano: return "volcano"
        case .willowTrees: return "willowTrees"
        case .yuccaTrees: return "yuccaTrees"
        case .reef: return "reef"
        case .randomMonsterLevel5: return "randomMonsterLevel5"
        case .randomMonsterLevel6: return "randomMonsterLevel6"
        case .randomMonsterLevel7: return "randomMonsterLevel7"
            
            
            
            
        case .brush2: return "brush2"
        case .bush2: return "bush2"
        case .cactus2: return "cactus2"
        case .canyon2: return "canyon2"
        case .crater2: return "crater2"
        case .deadVegetation2: return "deadVegetation2"
        case .flowers2: return "flowers2"
        case .frozenLake2: return "frozenLake2"
        case .hedge2: return "hedge2"
        case .hill2: return "hill2"
        case .hole2: return "hole2"
        case .kelp2: return "kelp2"
        case .lake2: return "lake2"
        case .lavaFlow2: return "lavaFlow2"
        case .lavaLake2: return "lavaLake2"
        case .mushrooms2: return "mushrooms2"
        case .log2: return "log2"
        case .mandrake2: return "mandrake2"
        case .moss2: return "moss2"
        case .mound2: return "mound2"
        case .mountain2: return "mountain2"
        case .oakTrees2: return "oakTrees2"
        case .outcropping2: return "outcropping2"
        case .pineTrees2: return "pineTrees2"
        case .plant2: return "plant2"
        case .riverDelta2: return "riverDelta2"
        case .rock2: return "rock2"
        case .sandDune2: return "sandDune2"
        case .sandPit2: return "sandPit2"
        case .shrub2: return "shrub2"
        case .skull2: return "skull2"
        case .stalagmite2: return "stalagmite2"
        case .stump2: return "stump2"
        case .tarPit2: return "tarPit2"
        case .trees2: return "trees2"
        case .vine2: return "vine2"
        case .volcanicVent2: return "volcanicVent2"
        case .volcano2: return "volcano2"
        case .willowTrees2: return "willowTrees2"
        case .yuccaTrees2: return "yuccaTrees2"
        case .reef2: return "reef2"
            
            
            
            
            
            
            
            
            
            
        case .desertHills: return "desertHills"
        case .dirtHills: return "dirtHills"
        case .grassHills: return "grassHills"
        case .roughHills: return "roughHills"
        case .subterraneanRocks: return "subterraneanRocks"
        case .swampFoliage: return "swampFoliage"
        case .freelancersGuild: return "freelancersGuild"
        case .heroPlaceholder: return "heroPlaceholder"
        case .questGuard: return "questGuard"
        case .randomDwelling: return "randomDwelling"
        case .garrison2: return "garrison2"
        case .tradingPostSnow: return "tradingPostSnow"
        case .cloverField: return "cloverField"
        case .cursedGround2: return "cursedGround2"
        case .evilFog: return "evilFog"
        case .favoredWinds: return "favoredWinds"
        case .fieryFields: return "fieryFields"
        case .holyGround: return "holyGround"
        case .lucidPools: return "lucidPools"
        case .magicClouds: return "magicClouds"
        case .magicPlains2: return "magicPlains2"
        case .rocklands: return "rocklands"
        case .dragonUtopia: return "dragonUtopia"
        }
        
    }
}
