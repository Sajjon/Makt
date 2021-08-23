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
        
        case purpleWithWhiteSwirl,
             yellowGlowingSpots,
             redSpiral,
             whiteGlowSphere
    }
    
    enum TwoWayMonolith: UInt8, Hashable, CaseIterable {
        /// Green (lightning)
        case greenLighting,
             
        /// Orange (bubbles)
        orange,
        
        /// Purple (ripples)
        purple,
        
        /// Brown(ish)
        brown,
        
        // Green (energry)
        greenEnergy,
        
        explodingLine,
        glowingSphere,
             
        // In case of wog "snow portal"?
        whirlingShape
    }
}

import Foundation
public extension Map.Object {
    /// From here: https://h3maparchives.celestialheavens.com/tools/wog/erm_help/format/format_ob.htm
    enum ID: Hashable, CustomDebugStringConvertible {
        
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
             
             creatureBank(CreatureBank.ID),
             
             creatureGenerator1(CreatureGenerator.ID),
             
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
             
             marketOfTime, // missing in VCMI - why?
             
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
             randomMonsterLevel1,
             randomMonsterLevel2,
             randomMonsterLevel3,
             randomMonsterLevel4,
             randomResource,
             randomTown,
             refugeeCamp,
             
             resource(Resource.Kind),
             
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
             randomMonsterLevel5,
             randomMonsterLevel6,
             randomMonsterLevel7,
             
             
             
             brush2,
             bush2,
             cactus2,
             canyon2,
             crater2,
             deadVegetation2,
             flowers2,
             frozenLake2,
             hedge2,
             hill2,
             hole2,
             kelp2,
             lake2,
             lavaFlow2,
             lavaLake2,
             mushrooms2,
             log2,
             mandrake2,
             moss2,
             mound2,
             mountain2,
             oakTrees2,
             outcropping2,
             pineTrees2,
             plant2,
             riverDelta2,
             rock2,
             sandDune2,
             sandPit2,
             shrub2,
             skull2,
             stalagmite2,
             stump2,
             tarPit2,
             trees2,
             vine2,
             volcanicVent2,
             volcano2,
             willowTrees2,
             yuccaTrees2,
             reef2,
             
             
             
             
             
             
             
             
             
          
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

// MARK: Stripped
public extension Map.Object.ID {

    
    /// From here: https://h3maparchives.celestialheavens.com/tools/wog/erm_help/index.htm
    enum Stripped: UInt32, Hashable, CaseIterable {
        
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
             
             /// Source: https://github.com/potmdehex/homm3tools/blob/5687f581a4eb5e7b0e8f48794d7be4e3b0a8cc8b/h3m/h3mlib/h3m_parsing/parse_oa_meta_type.c#L31
             /// Source 2: explainatino needed, we parsed the object attributes with animation file name `AVXmktt0.def` for Object ID 50
             /// https://forum.df2.ru/lofiversion/index.php/t24182-1450.html
             /// See comment by: pHOMM at time 13 Aug 2010, 08:57, use google translate, he corrpobrates that this is market of time: "...and the time market AVXMKTT0.DEF"
            marketOfTime = 50,
             
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
             randomMonsterLevel1 = 72,
             randomMonsterLevel2 = 73,
             randomMonsterLevel3 = 74,
             randomMonsterLevel4 = 75,
             randomResource = 76,
             randomTown = 77,
             refugeeCamp = 78,
             
             ///  [0 - 7 - Format R]
             resource = 79,
             
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
             randomMonsterLevel5 = 162,
             randomMonsterLevel6 = 163,
             randomMonsterLevel7 = 164,
                          brush2 = 165,
                          bush2 = 166,
                          cactus2 = 167,
                          canyon2 = 168,
                          crater2 = 169,
                          deadVegetation2 = 170,
                          flowers2 = 171,
                          frozenLake2 = 172,
                          hedge2 = 173,
                          hill2 = 174,
                          hole2 = 175,
                          kelp2 = 176,
                          lake2 = 177,
                          lavaFlow2 = 178,
                          lavaLake2 = 179,
                          mushrooms2 = 180,
                          log2 = 181,
                          mandrake2 = 182,
                          moss2 = 183,
                          mound2 = 184,
                          mountain2 = 185,
                          oakTrees2 = 186,
                          outcropping2 = 187,
                          pineTrees2 = 188,
                          plant2 = 189,
                          riverDelta2 = 190,
                          rock2 = 191,
                          sandDune2 = 192,
                          sandPit2 = 193,
                          shrub2 = 194,
                          skull2 = 195,
                          stalagmite2 = 196,
                          stump2 = 197,
                          tarPit2 = 198,
                          trees2 = 199,
                          vine2 = 200,
                          volcanicVent2 = 201,
                          volcano2 = 202,
                          willowTrees2 = 203,
                          yuccaTrees2 = 204,
                          reef2 = 205,
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
