//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-14.
//

import Foundation

// MARK: Stripped
public extension Map.Object.ID {
    
    
    /// From here: https://h3maparchives.celestialheavens.com/tools/wog/erm_help/index.htm
    enum Stripped: UInt32, Hashable, CaseIterable {
        
        case decorativeTown = 1,
             altarOfSacrifice = 2,
             anchorPoint = 3,
             arena = 4,
             
             artifact = 5,
             
             pandorasBox = 6,
             blackMarket = 7,
             boat = 8,
             
             borderguard = 9,
             
             keymastersTent = 10,
             
             buoy = 11,
             campfire = 12,
             cartographer = 13,
             swanPond = 14,
             coverOfDarkness = 15,
             
             creatureBank = 16,
             
             creatureGenerator1 = 17,
             
             creatureGenerator2 = 18,
             creatureGenerator3 = 19,
             
             creatureGenerator4 = 20,
             
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
             
             garrison = 33,
             
             hero = 34,
             
             hillFort = 35,
             grail = 36,
             hutOfTheMagi = 37,
             idolOfFortune = 38,
             
             leanTo = 39,
             
             // case blank40 = 40,
             
             libraryOfEnlightenment = 41,
             lighthouse = 42,
             
             monolithOneWayEntrance = 43,
             
             monolithOneWayExit = 44,
             
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
             
             resourceGenerator = 53,
             
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
             
             resource = 79,
             
             sanctuary = 80,
             scholar = 81,
             seaChest = 82,
             seersHut = 83,
             crypt = 84,
             shipwreck = 85,
             shipwreckSurvivor = 86,
             shipyard = 87,
             shrineOfMagicIncantation = 88,
             shrineOfMagicGesture = 89,
             shrineOfMagicThought = 90,
             sign = 91,
             sirens = 92,
             
             spellScroll = 93,
             stables = 94,
             tavern = 95,
             temple = 96,
             denOfThieves = 97,
             
             town = 98,
             
             tradingPost = 99,
             learningStone = 100,
             
             treasureChest = 101,
             
             treeofKnowledge = 102,
             subterraneanGate = 103,
             university = 104,
             wagon = 105,
             warMachineFactory = 106,
             schoolOfWar = 107,
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
             
             
             
             passable139 = 139, passable141 = 141, passable142 = 142, passable144 = 144, passable145 = 145, passable146 = 146,
             
             
             
             
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
             randomDwellingOfFaction = 218,
             
             garrison2 = 219,
             abandonedMine = 220,
             tradingPostSnow = 221,
             cloverField = 222,
             cursedGround2 = 223,
             evilFog = 224,
             favorableWinds = 225,
             fieryFields = 226,
             holyGround = 227,
             lucidPools = 228,
             magicClouds = 229,
             magicPlains2 = 230,
             rocklands = 231
    }
}
