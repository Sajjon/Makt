//
//  Map+Object+Kind.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

public extension Map.Object {
    
    enum Mine: UInt8, Hashable, CaseIterable {
        case sawmill,
        alchemistsLab,
        orePit,
        sulfurDune,
        crystalCavern,
        gemPond,
        goldMine,
        abandonedMine
    }
    
    enum OneWayMonolith: UInt8, Hashable, CaseIterable {
        
        /// Blue (Starfield)
        case blue,
             
             /// Red (white vortex)
             red,
             
             /// Yellow (gold/brown)
             yellow,
             
             yellowGlowing
        
        #if WOG
        case purpleWithWhiteSwirl,
             yellowGlowingSpots,
             redSpiral,
             whiteGlowSphere
        #endif // WOG
    }
    
    enum TwoWayMonolith: UInt8, Hashable, CaseIterable {
        /// Green (lightning)
        case green,
             
        /// Orange (bubbles)
        orange,
        
        /// Purple (ripples)
        purple,
        
        /// Brown(ish)
        brown
        
        #if WOG
        case greenEnergy,
             explodingLine,
             glowingSphere,
             
             /// In case of wog "snow portal"?
             whirlingShape
        
        #endif // WOG

    }
}

import Foundation
public extension Map.Object {
    /// From here: https://h3maparchives.celestialheavens.com/tools/wog/erm_help/format/format_ob.htm
    enum ID: Hashable {
        case altarOfSacrifice,
             anchorPoint,
             arena,
             
             artifact(Artifact.ID),
             
             pandorasBox,
             blackMarket,
             boat,
             
             borderguard(BorderGuardTentType),
             
             keymastersTent(KeymastersTentType),
             
             buoy,
             campfire,
             cartographer,
             swanPond,
             coverOfDarkness,
             
             creatureBank(CreatureBank),
             
             creatureGenerator1(CreatureGenerator),
             
             creatureGenerator2,
             creatureGenerator3,
             
             creatureGenerator4(unknownBool: Bool),
             
             cursedGround,
             
             corpse,
             marlettoTower,
             derelictShip,
             dragonUtopia,
             event,
             eyeOfTheMagi,
             faerieRing,
             flotsam,
             fountainOfFortune,
             fountainOfYouth,
             gardenOfRevelation,
             
             garrison(hasAntiMagic: Bool),
             
             hero(Hero.ID),
             
             hillFort,
             grail,
             hutOfTheMagi,
             idolOfFortune,
             
             leanTo,
             
             libraryOfEnlightenment,
             lighthouse,
             
             monolithOneWayEntrance(OneWayMonolith),
             
             monolithOneWayExit(OneWayMonolith),
             
             monolithTwoWay(TwoWayMonolith),
             
             magicPlains,
             schoolOfMagic,
             magicSpring,
             magicWell,
             
             mercenaryCamp,
             mermaid,
             
             mine(Mine),
             
             monster(Creature.ID),
             
             mysticalGarden,
             oasis,
             obelisk,
             redwoodObservatory,
             oceanBottle,
             pillarOfFire,
             starAxis,
             prison,
             
             pyramid,
             
             rallyFlag,
             
             randomArtifact,
             randomTreasureArtifact,
             randomMinorArtifact,
             randomMajorArtifact,
             randomRelic,
             randomHero,
             randomMonster,
             randomMonster1,
             randomMonster2,
             randomMonster3,
             randomMonster4,
             randomResource,
             randomTown,
             refugeeCamp,
             resource07FormatR,
             sanctuary,
             scholar,
             seaChest,
             seerSHut,
             crypt,
             shipwreck,
             shipwreckSurvivor,
             shipyard,
             shrineOfMagicIncantation,
             shrineOfMagicGesture,
             shrineOfMagicThought,
             sign,
             sirens,
             
             spellScroll(Spell.ID),
             stables,
             tavern,
             temple,
             denOfThieves,
             
             town(Faction),
             
             tradingPost,
             learningStone,
             
             treasureChest,
             
             treeofKnowledge,
             subterraneanGate,
             university,
             wagon,
             warMachineFactory,
             schooloFWar,
             warriorsTomb,
             waterWheel,
             wateringHole,
             whirlpool,
             windmill,
             
             witchHut(Hero.SecondarySkill.Kind),
             
             brush,
             bush,
             cactus,
             canyon,
             crater,
             deadVegetation,
             flowers,
             frozenLake,
             hedge,
             hill,
             hole,
             kelp,
             lake,
             lavaFlow,
             lavaLake,
             mushrooms,
             log,
             mandrake,
             moss,
             mound,
             mountain,
             oakTrees,
             outcropping,
             pineTrees,
             plant,
             riverDelta,
             rock,
             sandDune,
             sandPit,
             shrub,
             skull,
             stalagmite,
             stump,
             tarPit,
             trees,
             vine,
             volcanicVent,
             volcano,
             willowTrees,
             yuccaTrees,
             reef,
             randomMonster5,
             randomMonster6,
             randomMonster7,
          
             desertHills,
             dirtHills,
             grassHills,
             roughHills,
             subterraneanRocks,
             swampFoliage,
             
             borderGate(BorderGuardTentType),
             
             freelancersGuild,
             heroPlaceholder,
             questGuard,
             randomDwelling,
             
             randomDwellingAtLevel(Creature.Level),
             
             randomDwellingOfFaction(Faction),
             
             garrison2,
             abandonedMine,
             tradingPostSnow,
             cloverField,
             cursedGround2,
             evilFog,
             favoredWinds,
             fieryFields,
             holyGround,
             lucidPools,
             magicClouds,
             magicPlains2,
             rocklands
    }
}

public extension Map.Object.ID {
    
    /// From here: https://h3maparchives.celestialheavens.com/tools/wog/erm_help/index.htm
    enum Stripped: UInt32 {
        case altarOfSacrifice = 2,
             anchorPoint = 3,
             arena = 4,
             
             /// [0-143 - A1 Format]
             artifact = 5,
             
             pandorasBox = 6,
             blackMarket = 7,
             boat = 8,
             
             /// [0-7 - BG Format]
             borderguard = 9,
             
             /// [0-7 - BG format]
             keymastersTent = 10,
             
             buoy = 11,
             campfire = 12,
             cartographer = 13,
             swanPond = 14,
             coverOfDarkness = 15,
             
             /// [0-20 - CB format]
             creatureBank = 16,
             
             /// [0-95 - CG Format]
             creatureGenerator1 = 17,
             
             creatureGenerator2 = 18,
             creatureGenerator3 = 19,
             
             creatureGenerator4 = 20,
             
             /// [0-1 - CG format]
             cursedGround = 21,
             
             corpse = 22,
             marlettoTower = 23,
             derelictShip = 24,
             dragonUtopia = 25,
             event = 26,
             eyeOfTheMagi = 27,
             faerieRing = 28,
             flotsam = 29,
             fountainOfFortune = 30,
             fountainOfYouth = 31,
             gardenOfRevelation = 32,
             
             /// [0 = ordinary, 1 = antimagic]
             garrison = 33,
             
             ///[0-155 - Format H]
             hero = 34,
             
             hillFort = 35,
             grail = 36,
             hutOfTheMagi = 37,
             idolOfFortune = 38,
             
             leanTo = 39,
             // case blank40 = 40,
             
             libraryOfEnlightenment = 41,
             lighthouse = 42,
             
             /// [0 - 7 - M1 format]
             monolithOneWayEntrance = 43,
             
             /// [0 - 7 - M1 format]
             monolithOneWayExit = 44,
             
             /// [0 - 7 - M2 format]
             monolithTwoWay = 45,
             
             magicPlains = 46,
             schoolOfMagic = 47,
             magicSpring = 48,
             magicWell = 49,
             
             /// case BLANK = 50,
             
             mercenaryCamp = 51,
             mermaid = 52,
             
             /// [0 - 7 - MI Format]
             mine = 53,
             
             /// [0 - 196 - Format C]
             monster = 54,
             
             mysticalGarden = 55,
             oasis = 56,
             obelisk = 57,
             redwoodObservatory = 58,
             oceanBottle = 59,
             pillarOfFire = 60,
             starAxis = 61,
             prison = 62,
             pyramid = 63,
             
             ///[0 - 74 - Castle Editor Objects]
             rallyFlag = 64,
             
             randomArtifact = 65,
             randomTreasureArtifact = 66,
             randomMinorArtifact = 67,
             randomMajorArtifact = 68,
             randomRelic = 69,
             randomHero = 70,
             randomMonster = 71,
             randomMonster1 = 72,
             randomMonster2 = 73,
             randomMonster3 = 74,
             randomMonster4 = 75,
             randomResource = 76,
             randomTown = 77,
             refugeeCamp = 78,
             resource07FormatR = 79,
             sanctuary = 80,
             scholar = 81,
             seaChest = 82,
             seerSHut = 83,
             crypt = 84,
             shipwreck = 85,
             shipwreckSurvivor = 86,
             shipyard = 87,
             shrineOfMagicIncantation = 88,
             shrineOfMagicGesture = 89,
             shrineOfMagicThought = 90,
             sign = 91,
             sirens = 92,
             
             /// [0 - 69 - SP Format]
             spellScroll = 93,
             stables = 94,
             tavern = 95,
             temple = 96,
             denOfThieves = 97,
             
             ///[0 - 8 -Format T]
             town = 98,
             
             tradingPost = 99,
             learningStone = 100,
             
             /// [UN: B]
             treasureChest = 101,
             
             treeofKnowledge = 102,
             subterraneanGate = 103,
             university = 104,
             wagon = 105,
             warMachineFactory = 106,
             schooloFWar = 107,
             warriorsTomb = 108,
             waterWheel = 109,
             wateringHole = 110,
             whirlpool = 111,
             windmill = 112,
             
             ///[0 - 27 - SS Format]
             witchHut = 113,
             
             brush = 114,
             bush = 115,
             cactus = 116,
             canyon = 117,
             crater = 118,
             deadVegetation = 119,
             flowers = 120,
             frozenLake = 121,
             hedge = 122,
             hill = 123,
             hole = 124,
             kelp = 125,
             lake = 126,
             lavaFlow = 127,
             lavaLake = 128,
             mushrooms = 129,
             log = 130,
             mandrake = 131,
             moss = 132,
             mound = 133,
             mountain = 134,
             oakTrees = 135,
             outcropping = 136,
             pineTrees = 137,
             plant = 138,
             riverDelta = 143,
             rock = 147,
             sandDune = 148,
             sandPit = 149,
             shrub = 150,
             skull = 151,
             stalagmite = 152,
             stump = 153,
             tarPit = 154,
             trees = 155,
             vine = 156,
             volcanicVent = 157,
             volcano = 158,
             willowTrees = 159,
             yuccaTrees = 160,
             reef = 161,
             randomMonster5 = 162,
             randomMonster6 = 163,
             randomMonster7 = 164,
             //             brush = 165,
             //             bush = 166,
             //             cactus = 167,
             //             canyon = 168,
             //             crater = 169,
             //             deadVegetation = 170,
             //             flowers = 171,
             //             frozenLake = 172,
             //             hedge = 173,
             //             hill = 174,
             //             hole = 175,
             //             kelp = 176,
             //             lake = 177,
             //             lavaFlow = 178,
             //             lavaLake = 179,
             //             mushrooms = 180,
             //             log = 181,
             //             mandrake = 182,
             //             moss = 183,
             //             mound = 184,
             //             mountain = 185,
             //             oakTrees = 186,
             //             outcropping = 187,
             //             pineTrees = 188,
             //             plant = 189,
             //             riverDelta = 190,
             //             rock = 191,
             //             sandDune = 192,
             //             sandPit = 193,
             //             shrub = 194,
             //             skull = 195,
             //             stalagmite = 196,
             //             stump = 197,
             //             tarPit = 198,
             //             trees = 199,
             //             vine = 200,
             //             volcanicVent = 201,
             //             volcano = 202,
             //             willowTrees = 203,
             //             yuccaTrees = 204,
             //             reef = 205,
             desertHills = 206,
             dirtHills = 207,
             grassHills = 208,
             roughHills = 209,
             subterraneanRocks = 210,
             swampFoliage = 211,
             
             ///[0-7 - BG Format]
             borderGate = 212,
             
             freelancersGuild = 213,
             heroPlaceholder = 214,
             questGuard = 215,
             randomDwelling = 216,
             
             /// subtype = creature level
             randomDwellingWithLevel = 217,
             
             /// subtype = faction
             randomDwellingFactoion = 218,
             
             garrison2 = 219,
             abandonedMine = 220,
             tradingPostSnow = 221,
             cloverField = 222,
             cursedGround2 = 223,
             evilFog = 224,
             favoredWinds = 225,
             fieryFields = 226,
             holyGround = 227,
             lucidPools = 228,
             magicClouds = 229,
             magicPlains2 = 230,
             rocklands = 231
    }
}
