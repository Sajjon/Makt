//
//  Map+Object+Kind.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

public extension Map {
    struct Mine: Hashable {
        public let kind: Kind
        public let owner: PlayerColor?
    }
    
    struct Shipyard: Hashable {
        public let owner: PlayerColor?
    }
    
    struct Shrine: Hashable {
        public let spell: Spell.ID?
    }
    struct Sign: Hashable {
        public let message: String
    }
    struct OceanBottle: Hashable {
        public let message: String
    }
    
    struct Scholar: Hashable {
        
        public let bonus: Bonus
        
        public enum Bonus: Hashable {
            
            case primarySkill(Hero.PrimarySkill.Kind)
            case secondarySkill(Hero.SecondarySkill.Kind)
            case spell(Spell.ID)
            case random
            
            public enum Stripped: UInt8, Hashable, CaseIterable {
                case primarySkill
                case secondarySkill
                case spell
                case random = 255
            }
        }
    }
}
public extension Map.Mine {
    enum Kind: UInt8, Hashable, CaseIterable {
        case sawmill,
        alchemistsLab,
        orePit,
        sulfurDune,
        crystalCavern,
        gemPond,
        goldMine,
        abandonedMine
    }
}

public extension Map.Object {
    

    
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
        
        case decorativeTown, altarOfSacrifice,
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
             
             hero(Hero.Class),
             
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
             
             mine(Map.Mine.Kind),
             
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
             seersHut,
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
             schoolOfWar,
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
             
             
             
             
             /// Sub ID can have values: 139, 141, 142, 144, 145, 146
             genericPassable(subID: Int),
             
             
             
          
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
             favorableWinds,
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
        
        case decorativeTown = 1,
            altarOfSacrifice = 2,
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

public extension Map.Object {
    enum Class: Hashable, CaseIterable {
        
        case abandonedMine,

        // Armageddon's Blade and Shadow of Death variants.
        artifact,

        // Armageddon's Blade and Shadow of Death variants.
        dwelling,
        
        event,
        
        // Armageddon's Blade and Shadow of Death variants.
        garrison,
        
        genericBoat,
        
        // Armageddon's Blade and Shadow of Death variants.
        genericImpassableTerrain,
        
        genericPassableTerrain,
        
        // Armageddon's Blade and Shadow of Death variants.
        genericTreasure,
        
        // Armageddon's Blade and Shadow of Death variants.
        genericVisitable,
        
        grail,
       
        // Armageddon's Blade and Shadow of Death variants.
        hero,
        
        lighthouse,
        monolithTwoWay,
        
        // Armageddon's Blade and Shadow of Death variants.
        monster,
       
        oceanBottle,
        pandorasBox,
        placeholderHero,
        prison,
        questGuard,
        randomDwelling,
        randomDwellingOfFaction,
        randomDwellingAtLevel,
        randomHero,
        resource,
        resourceGenerator,
        scholar,
        seersHut,
        shipyard,
        shrine,
        sign,
        spellScroll,
        subterraneanGate,

        // Armageddon's Blade and Shadow of Death variants.
        town,
        
        witchHut

    }
}

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

        case .mine:
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
