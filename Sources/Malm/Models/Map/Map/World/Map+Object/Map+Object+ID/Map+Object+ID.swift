//
//  Map+Object+Kind.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map.Object {
    /// From here: https://h3maparchives.celestialheavens.com/tools/wog/erm_help/format/format_ob.htm
    enum ID: Hashable, CustomDebugStringConvertible, Codable {
        
        /// Not used by bundled maps, but seen in some custom maps.
        ///
        /// User map "West Orient & Underground Cave" by "Super man"
        /// https://heroesportal.net/maps/download/2585
        ///
        /// Has a `decorative town` of type `Fortress` approximately at (x: 40, y: 60)
        ///
        case decorativeTown(Faction),
             altarOfSacrifice,
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
             
             resourceGenerator(Map.ResourceGenerator.Kind.Placeholder),
             
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

