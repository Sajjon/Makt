//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-13.
//

import Foundation

public extension Sprite {
    typealias StringLiteralType = String
    init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)!
    }
}

public enum Sprite: String, Hashable, CaseIterable, ExpressibleByStringLiteral {
    
    /// riverDelta
    /// Terrain kind: snow, swamp, rough
    case riverDelta_muddelt1 = "muddelt1.def"
    
    /// holyGround
    /// Terrain kind: Land
    case holyGround_AVXhg1 = "AVXhg1.def"

    /// fieryFields
    /// Terrain kind: Land
    case fieryFields_AVXff7 = "AVXff7.def"

    /// cloverField
    /// Terrain kind: Land
    case cloverField_AVXcf6 = "AVXcf6.def"

    /// cursedGround2
    /// Terrain kind: Land
    case cursedGround2_AVXcg3 = "AVXcg3.def"
    
    /// artifact - collarOfConjuring
    /// Terrain kind: dirt
    case collarOfConjuring_AVA0076 = "AVA0076.def"

    /// cursedGround2
    /// Terrain kind: Land
    case cursedGround2_AVXcg6 = "AVXcg6.def"
    
    /// borderGate - playerSix
    /// Terrain kind: Land
    case borderGatePlayerSix_avxbgt50 = "avxbgt50.def"

    /// favorableWinds
    /// Terrain kind: Water
    case favorableWinds_AVXfw2 = "AVXfw2.def"

    /// favorableWinds
    /// Terrain kind: Water
    case favorableWinds_AVXfw0 = "AVXfw0.def"

    /// favorableWinds
    /// Terrain kind: Water
    case favorableWinds_AVXfw3 = "AVXfw3.def"

    /// favorableWinds
    /// Terrain kind: Water
    case favorableWinds_AVXfw4 = "AVXfw4.def"

    /// favorableWinds
    /// Terrain kind: Water
    case favorableWinds_AVXfw5 = "AVXfw5.def"

    /// favorableWinds
    /// Terrain kind: Water
    case favorableWinds_AVXfw6 = "AVXfw6.def"

    /// favorableWinds
    /// Terrain kind: Water
    case favorableWinds_AVXfw1 = "AVXfw1.def"

    /// favorableWinds
    /// Terrain kind: Water
    case favorableWinds_AVXfw7 = "AVXfw7.def"

    /// holyGround
    /// Terrain kind: Land
    case holyGround_AVXhg5 = "AVXhg5.def"

    /// monolithOneWayEntrance - redSpiral
    /// Terrain kind: Land
    case monolithOneWayEntranceRedSpiral_AVXmn7i0 = "AVXmn7i0.def"

    /// monolithOneWayExit - redSpiral
    /// Terrain kind: Land
    case monolithOneWayExitRedSpiral_AVXmn7o0 = "AVXmn7o0.def"

    /// monolithOneWayEntrance - whiteGlowSphere
    /// Terrain kind: Land
    case monolithOneWayEntranceWhiteGlowSphere_AVXmn8i0 = "AVXmn8i0.def"

    /// fieryFields
    /// Terrain kind: Land
    case fieryFields_AVXff6 = "AVXff6.def"

    /// fieryFields
    /// Terrain kind: Land
    case fieryFields_AVXff4 = "AVXff4.def"

    /// magicClouds
    /// Terrain kind: Land
    case magicClouds_AVXmc1 = "AVXmc1.def"

    /// monolithOneWayExit - whiteGlowSphere
    /// Terrain kind: Land
    case monolithOneWayExitWhiteGlowSphere_AVXmn8o0 = "AVXmn8o0.def"

    /// rocklands
    /// Terrain kind: Land
    case rocklands_AVXrk5 = "AVXrk5.def"

    /// rocklands
    /// Terrain kind: Land
    case rocklands_AVXrk7 = "AVXrk7.def"
    
    /// rocklands
    /// Terrain kind: Land
    case rocklands_AVXrk0 = "AVXrk0.def"

    /// rocklands
    /// Terrain kind: Land
    case rocklands_AVXrk3 = "AVXrk3.def"

    /// fieryFields
    /// Terrain kind: Land
    case fieryFields_AVXff2 = "AVXff2.def"

    /// fieryFields
    /// Terrain kind: Land
    case fieryFields_AVXff3 = "AVXff3.def"

    /// lucidPools
    /// Terrain kind: Land
    case lucidPools_AVXlp1 = "AVXlp1.def"

    /// lucidPools
    /// Terrain kind: Land
    case lucidPools_AVXlp3 = "AVXlp3.def"

    /// lucidPools
    /// Terrain kind: Land
    case lucidPools_AVXlp5 = "AVXlp5.def"
    
    /// riverDelta
    /// Terrain kind: lava
    case riverDelta_lavdelt4 = "lavdelt4.def"
    
    /// randomDwellingOfFaction - castle
    /// Terrain kind: Land
    case randomDwellingOfFactionCastle_avrcgn00 = "avrcgn00.def"

    /// randomDwellingOfFaction - rampart
    /// Terrain kind: Land
    case randomDwellingOfFactionRampart_avrcgn01 = "avrcgn01.def"

    /// randomDwellingOfFaction - tower
    /// Terrain kind: Land
    case randomDwellingOfFactionTower_avrcgn02 = "avrcgn02.def"

    /// randomDwellingOfFaction - inferno
    /// Terrain kind: Land
    case randomDwellingOfFactionInferno_avrcgn03 = "avrcgn03.def"

    /// randomDwellingOfFaction - necropolis
    /// Terrain kind: Land
    case randomDwellingOfFactionNecropolis_avrcgn04 = "avrcgn04.def"

    /// randomDwellingOfFaction - dungeon
    /// Terrain kind: Land
    case randomDwellingOfFactionDungeon_avrcgn05 = "avrcgn05.def"

    /// randomDwellingOfFaction - stronghold
    /// Terrain kind: Land
    case randomDwellingOfFactionStronghold_avrcgn06 = "avrcgn06.def"

    /// randomDwellingOfFaction - fortress
    /// Terrain kind: Land
    case randomDwellingOfFactionFortress_avrcgn07 = "avrcgn07.def"

    /// randomDwellingOfFaction - conflux
    /// Terrain kind: Land
    case randomDwellingOfFactionConflux_avrcgn08 = "avrcgn08.def"
    
    /// monster - griffin
    /// Terrain kind: grass
    case griffin_AvWGrif = "AvWGrif.def"

    /// monster - royalGriffin
    /// Terrain kind: dirt
    case royalGriffin_AVWgrix0 = "AVWgrix0.def"

    /// monster - pegasus
    /// Terrain kind: dirt
    case pegasus_AVWpega0 = "AVWpega0.def"

    /// monster - warUnicorn
    /// Terrain kind: dirt
    case warUnicorn_AVWunix0 = "AVWunix0.def"

    /// monster - masterGremlin
    /// Terrain kind: dirt
    case masterGremlin_AVWgrex0 = "AVWgrex0.def"

    /// monster - obsidianGargoyle
    /// Terrain kind: dirt
    case obsidianGargoyle_AVWgarx0 = "AVWgarx0.def"

    /// monster - stoneGolem
    /// Terrain kind: dirt
    case stoneGolem_AVWgolm0 = "AVWgolm0.def"

    /// monster - ironGolem
    /// Terrain kind: dirt
    case ironGolem_AVWgolx0 = "AVWgolx0.def"

    /// monster - naga
    /// Terrain kind: dirt
    case naga_AVWnaga0 = "AVWnaga0.def"

    /// monster - magog
    /// Terrain kind: dirt
    case magog_AVWgogx0 = "AVWgogx0.def"

    /// monster - efreeti
    /// Terrain kind: dirt
    case efreeti_AVWefre0 = "AVWefre0.def"

    /// monster - troglodyte
    /// Terrain kind: dirt
    case troglodyte_AVWtrog0 = "AVWtrog0.def"

    /// monster - infernalTroglodyte
    /// Terrain kind: grass
    case infernalTroglodyte_AvWInfr = "AvWInfr.def"

    /// monster - evilEye
    /// Terrain kind: dirt
    case evilEye_AVWbehx0 = "AVWbehx0.def"

    /// monster - orc
    /// Terrain kind: dirt
    case orc_AVWorc0 = "AVWorc0.def"

    /// monster - thunderbird
    /// Terrain kind: dirt
    case thunderbird_AVWrocx0 = "AVWrocx0.def"

    /// monster - cyclopsKing
    /// Terrain kind: dirt
    case cyclopsKing_AVWcycx0 = "AVWcycx0.def"

    /// monster - ancientBehemoth
    /// Terrain kind: dirt
    case ancientBehemoth_AVWbhmx0 = "AVWbhmx0.def"

    /// monster - lizardWarrior
    /// Terrain kind: dirt
    case lizardWarrior_AVWlizx0 = "AVWlizx0.def"

    /// monster - dragonFly
    /// Terrain kind: grass
    case dragonFly_AvWDFir = "AvWDFir.def"

    /// monster - greaterBasilisk
    /// Terrain kind: grass
    case greaterBasilisk_AvWGBas = "AvWGBas.def"

    /// monster - gorgon
    /// Terrain kind: grass
    case gorgon_AvWGorg = "AvWGorg.def"

    /// monster - pixie
    /// Terrain kind: Land
    case pixie_AVWpixie = "AVWpixie.def"

    /// monster - sprite
    /// Terrain kind: Land
    case sprite_AVWsprit = "AVWsprit.def"

    /// monster - magmaElemental
    /// Terrain kind: Land
    case magmaElemental_AVWstone = "AVWstone.def"

    /// monster - stormElemental
    /// Terrain kind: Land
    case stormElemental_AVWstorm = "AVWstorm.def"

    /// monster - energyElemental
    /// Terrain kind: Land
    case energyElemental_AVWnrg = "AVWnrg.def"

    /// monster - psychicElemental
    /// Terrain kind: Land
    case psychicElemental_AVWpsye = "AVWpsye.def"

    /// monster - magicElemental
    /// Terrain kind: Land
    case magicElemental_AVWmagel = "AVWmagel.def"

    /// monster - firebird
    /// Terrain kind: Land
    case firebird_AVWfbird = "AVWfbird.def"

    /// monster - phoenix
    /// Terrain kind: Land
    case phoenix_AVWphx = "AVWphx.def"

    /// monster - goldGolem
    /// Terrain kind: dirt
    case goldGolem_AVWglmg0 = "AVWglmg0.def"

    /// monster - diamondGolem
    /// Terrain kind: dirt
    case diamondGolem_AVWglmd0 = "AVWglmd0.def"

    /// monster - rustDragon
    /// Terrain kind: Land
    case rustDragon_AVWrust = "AVWrust.def"

    /// monster - halfling
    /// Terrain kind: Land
    case halfling_AVWhalf = "AVWhalf.def"

    /// monster - peasant
    /// Terrain kind: Land
    case peasant_AVWpeas = "AVWpeas.def"

    /// monster - boar
    /// Terrain kind: Land
    case boar_AVWboar = "AVWboar.def"

    /// monster - mummy
    /// Terrain kind: Land
    case mummy_AVWmumy = "AVWmumy.def"

    /// monster - nomad
    /// Terrain kind: Land
    case nomad_AVWnomd = "AVWnomd.def"

    /// monster - rogue
    /// Terrain kind: Land
    case rogue_AVWrog = "AVWrog.def"

    /// monster - troll
    /// Terrain kind: Land
    case troll_AVWtrll = "AVWtrll.def"
    
    /// artifact - tunicOfTheCyclopsKing
    /// Terrain kind: dirt
    case tunicOfTheCyclopsKing_AVA0028 = "AVA0028.def"

    /// artifact - celestialNecklaceOfBliss
    /// Terrain kind: dirt
    case celestialNecklaceOfBliss_AVA0033 = "AVA0033.def"

    /// artifact - helmOfHeavenlyEnlightenment
    /// Terrain kind: dirt
    case helmOfHeavenlyEnlightenment_AVA0036 = "AVA0036.def"

    /// artifact - dragonScaleShield
    /// Terrain kind: dirt
    case dragonScaleShield_AVA0039 = "AVA0039.def"

    /// artifact - dragonWingTabard
    /// Terrain kind: dirt
    case dragonWingTabard_AVA0042 = "AVA0042.def"

    /// artifact - stillEyeOfTheDragon
    /// Terrain kind: dirt
    case stillEyeOfTheDragon_AVA0045 = "AVA0045.def"

    /// artifact - cardsOfProphecy
    /// Terrain kind: dirt
    case cardsOfProphecy_AVA0047 = "AVA0047.def"

    /// artifact - ladybirdOfLuck
    /// Terrain kind: dirt
    case ladybirdOfLuck_AVA0048 = "AVA0048.def"

    /// artifact - crestOfValor
    /// Terrain kind: dirt
    case crestOfValor_AVA0050 = "AVA0050.def"

    /// artifact - glyphOfGallantry
    /// Terrain kind: dirt
    case glyphOfGallantry_AVA0051 = "AVA0051.def"

    /// artifact - speculum
    /// Terrain kind: dirt
    case speculum_AVA0052 = "AVA0052.def"

    /// artifact - garnitureOfInterference
    /// Terrain kind: dirt
    case garnitureOfInterference_AVA0057 = "AVA0057.def"

    /// artifact - surcoatOfCounterpoise
    /// Terrain kind: dirt
    case surcoatOfCounterpoise_AVA0058 = "AVA0058.def"

    /// artifact - bowOfElvenCherrywood
    /// Terrain kind: dirt
    case bowOfElvenCherrywood_AVA0060 = "AVA0060.def"

    /// artifact - angelFeatherArrows
    /// Terrain kind: dirt
    case angelFeatherArrows_AVA0062 = "AVA0062.def"

    /// artifact - birdOfPerception
    /// Terrain kind: dirt
    case birdOfPerception_AVA0063 = "AVA0063.def"

    /// artifact - stoicWatchman
    /// Terrain kind: dirt
    case stoicWatchman_AVA0064 = "AVA0064.def"

    /// artifact - emblemOfCognizance
    /// Terrain kind: dirt
    case emblemOfCognizance_AVA0065 = "AVA0065.def"

    /// artifact - statesmansMedal
    /// Terrain kind: dirt
    case statesmansMedal_AVA0066 = "AVA0066.def"

    /// artifact - cloverOfFortune
    /// Terrain kind: dirt
    case cloverOfFortune_AVA0046 = "AVA0046.def"

    /// artifact - ambassadorsSash
    /// Terrain kind: dirt
    case ambassadorsSash_AVA0068 = "AVA0068.def"

    /// artifact - equestriansGloves
    /// Terrain kind: dirt
    case equestriansGloves_AVA0070 = "AVA0070.def"

    /// artifact - angelWings
    /// Terrain kind: dirt
    case angelWings_AVA0072 = "AVA0072.def"

    /// artifact - charmOfMana
    /// Terrain kind: dirt
    case charmOfMana_AVA0073 = "AVA0073.def"

    /// artifact - talismanOfMana
    /// Terrain kind: dirt
    case talismanOfMana_AVA0074 = "AVA0074.def"

    /// artifact - capeOfConjuring
    /// Terrain kind: dirt
    case capeOfConjuring_AVA0078 = "AVA0078.def"

    /// artifact - orbOfSilt
    /// Terrain kind: dirt
    case orbOfSilt_AVA0080 = "AVA0080.def"

    /// artifact - orbOfDrivingRain
    /// Terrain kind: dirt
    case orbOfDrivingRain_AVA0082 = "AVA0082.def"

    /// artifact - recantersCloak
    /// Terrain kind: dirt
    case recantersCloak_AVA0083 = "AVA0083.def"

    /// artifact - spiritOfOppression
    /// Terrain kind: dirt
    case spiritOfOppression_AVA0084 = "AVA0084.def"

    /// artifact - hourglassOfTheEvilHour
    /// Terrain kind: dirt
    case hourglassOfTheEvilHour_AVA0085 = "AVA0085.def"

    /// artifact - tomeOfFireMagic
    /// Terrain kind: dirt
    case tomeOfFireMagic_AVA0086 = "AVA0086.def"

    /// artifact - tomeOfAirMagic
    /// Terrain kind: dirt
    case tomeOfAirMagic_AVA0087 = "AVA0087.def"

    /// artifact - tomeOfWaterMagic
    /// Terrain kind: dirt
    case tomeOfWaterMagic_AVA0088 = "AVA0088.def"

    /// artifact - tomeOfEarthMagic
    /// Terrain kind: dirt
    case tomeOfEarthMagic_AVA0089 = "AVA0089.def"

    /// artifact - bootsOfLevitation
    /// Terrain kind: dirt
    case bootsOfLevitation_AVA0090 = "AVA0090.def"

    /// artifact - goldenBow
    /// Terrain kind: dirt
    case goldenBow_AVA0091 = "AVA0091.def"

    /// artifact - orbOfVulnerability
    /// Terrain kind: dirt
    case orbOfVulnerability_AVA0093 = "AVA0093.def"

    /// artifact - ringOfLife
    /// Terrain kind: dirt
    case ringOfLife_AVA0095 = "AVA0095.def"

    /// artifact - vialOfLifeblood
    /// Terrain kind: dirt
    case vialOfLifeblood_AVA0096 = "AVA0096.def"

    /// artifact - necklaceOfSwiftness
    /// Terrain kind: dirt
    case necklaceOfSwiftness_AVA0097 = "AVA0097.def"

    /// artifact - pendantOfSecondSight
    /// Terrain kind: dirt
    case pendantOfSecondSight_AVA0101 = "AVA0101.def"

    /// artifact - pendantOfHoliness
    /// Terrain kind: dirt
    case pendantOfHoliness_AVA0102 = "AVA0102.def"

    /// artifact - pendantOfLife
    /// Terrain kind: dirt
    case pendantOfLife_AVA0103 = "AVA0103.def"

    /// artifact - pendantOfFreeWill
    /// Terrain kind: dirt
    case pendantOfFreeWill_AVA0105 = "AVA0105.def"

    /// artifact - pendantOfNegativity
    /// Terrain kind: dirt
    case pendantOfNegativity_AVA0106 = "AVA0106.def"

    /// artifact - pendantOfTotalRecall
    /// Terrain kind: dirt
    case pendantOfTotalRecall_AVA0107 = "AVA0107.def"

    /// artifact - pendantOfCourage
    /// Terrain kind: dirt
    case pendantOfCourage_AVA0108 = "AVA0108.def"

    /// artifact - everflowingCrystalCloak
    /// Terrain kind: dirt
    case everflowingCrystalCloak_AVA0109 = "AVA0109.def"

    /// artifact - everpouringVialOfMercury
    /// Terrain kind: dirt
    case everpouringVialOfMercury_AVA0111 = "AVA0111.def"

    /// artifact - eversmokingRingOfSulfur
    /// Terrain kind: dirt
    case eversmokingRingOfSulfur_AVA0113 = "AVA0113.def"

    /// artifact - orbOfInhibition
    /// Terrain kind: dirt
    case orbOfInhibition_AVA0126 = "AVA0126.def"

    /// artifact - vialOfDragonBlood
    /// Terrain kind: Land
    case vialOfDragonBlood_AVA0127 = "AVA0127.def"

    /// artifact - armageddonsBlade
    /// Terrain kind: Land
    case armageddonsBlade_AVA0129 = "AVA0129.def"

    /// artifact - angelicAlliance
    /// Terrain kind: Land
    case angelicAlliance_AVA0130 = "AVA0130.def"

    /// artifact - cloakOfTheUndeadKing
    /// Terrain kind: Land
    case cloakOfTheUndeadKing_AVA0131 = "AVA0131.def"

    /// artifact - elixirOfLife
    /// Terrain kind: Land
    case elixirOfLife_AVA0132 = "AVA0132.def"

    /// artifact - armorOfTheDamned
    /// Terrain kind: Land
    case armorOfTheDamned_AVA0133 = "AVA0133.def"

    /// artifact - statueOfLegion
    /// Terrain kind: Land
    case statueOfLegion_AVA0134 = "AVA0134.def"

    /// artifact - powerOfTheDragonFather
    /// Terrain kind: Land
    case powerOfTheDragonFather_AVA0135 = "AVA0135.def"

    /// artifact - titansThunder
    /// Terrain kind: Land
    case titansThunder_AVA0136 = "AVA0136.def"

    /// artifact - admiralHat
    /// Terrain kind: Land
    case admiralHat_AVA0137 = "AVA0137.def"

    /// artifact - bowOfTheSharpshooter
    /// Terrain kind: Land
    case bowOfTheSharpshooter_AVA0138 = "AVA0138.def"

    /// artifact - wizardWell
    /// Terrain kind: Land
    case wizardWell_AVA0139 = "AVA0139.def"

    /// artifact - ringOfTheMagi
    /// Terrain kind: Land
    case ringOfTheMagi_AVA0140 = "AVA0140.def"

    /// artifact - cornucopia
    /// Terrain kind: Land
    case cornucopia_AVA0141 = "AVA0141.def"
    
    /// creatureGenerator1 - boarGlen
    /// Terrain kind: Land
    case boarGlen_AVGboar = "AVGboar.def"

    /// magicPlains2
    /// Terrain kind: Land
    case magicPlains2_AVXmp5 = "AVXmp5.def"

    /// magicPlains2
    /// Terrain kind: Land
    case magicPlains2_AVXmp3 = "AVXmp3.def"

    /// magicPlains2
    /// Terrain kind: Land
    case magicPlains2_AVXmp2 = "AVXmp2.def"

    /// magicClouds
    /// Terrain kind: Land
    case magicClouds_AVXmc2 = "AVXmc2.def"
    
    
    /// abandonedMine
    /// Terrain kind: swamp
    case abandonedMine_AVXamSw = "AVXamSw.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt03 = "avlswt03.def"

    /// creatureGenerator4 - false
    /// Terrain kind: Land
    case creatureGenerator4False_AVGelem0 = "AVGelem0.def"

    /// artifact - seaCaptainsHat
    /// Terrain kind: dirt
    case seaCaptainsHat_AVA0123 = "AVA0123.def"
    
    /// artifact - ringOfInfiniteGems
    /// Terrain kind: dirt
    case ringOfInfiniteGems_AVA0110 = "AVA0110.def"

    /// marketOfTime
    /// Terrain kind: Land
    case marketOfTime_AVXmktt0 = "AVXmktt0.def"

    /// outcropping
    /// Terrain kind: subterranean
    case outcropping_AVLoc3u0 = "AVLoc3u0.def"
    
    /// artifact - endlessSackOfGold
    /// Terrain kind: dirt
    case endlessSackOfGold_AVA0115 = "AVA0115.def"

    /// borderGate - white
    /// Terrain kind: Land
    case borderGateWhite_avxbgt60 = "avxbgt60.def"
    
    /// monolithTwoWay - brown
    /// Terrain kind: Land
    case monolithTwoWayBrown_AVXmn4b0 = "AVXmn4b0.def"
    
    
    /// hero - battleMage
    /// Terrain kind: Land
    case heroBattleMage_ah13_e = "ah13_e.def"

    /// hero - beastmaster
    /// Terrain kind: Land
    case heroBeastmaster_ah14_e = "ah14_e.def"
    
    /// abandonedMine
    /// Terrain kind: sand
    case abandonedMine_AVXamDs = "AVXamDs.def"

    /// abandonedMine
    /// Terrain kind: grass
    case abandonedMine_AVXamGr = "AVXamGr.def"

    /// artifact - torsoOfLegion
    /// Terrain kind: dirt
    case torsoOfLegion_AVA0120 = "AVA0120.def"

    /// pandorasBox
    /// Terrain kind: dirt
    case pandorasBox_AVA0128 = "AVA0128.def"

    /// monolithTwoWay - greenEnergy
    /// Terrain kind: Land
    case monolithTwoWayGreenEnergy_AVXmn5b0 = "AVXmn5b0.def"

    /// monolithTwoWay - explodingLine
    /// Terrain kind: Land
    case monolithTwoWayExplodingLine_AVXmn6b0 = "AVXmn6b0.def"

    /// cloverField
    /// Terrain kind: Land
    case cloverField_AVXcf0 = "AVXcf0.def"

    /// cursedGround2
    /// Terrain kind: Land
    case cursedGround2_AVXcg5 = "AVXcg5.def"

    /// lake
    /// Terrain kind: subterranean
    case lake_AVLlk1u0 = "AVLlk1u0.def"

    /// abandonedMine
    /// Terrain kind: subterranean
    case abandonedMine_AVXamSu = "AVXamSu.def"

    /// artifact - shacklesOfWar
    /// Terrain kind: dirt
    case shacklesOfWar_AVA0125 = "AVA0125.def"

    /// monster - dendroidSoldier
    /// Terrain kind: dirt
    case dendroidSoldier_AVWtrex0 = "AVWtrex0.def"

    /// artifact - vampiresCowl
    /// Terrain kind: dirt
    case vampiresCowl_AVA0055 = "AVA0055.def"
    
    /// mine - crystalCavern
    /// Terrain kind: subterranean
    case crystalCavern_AVMcrsu0 = "AVMcrsu0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr04u0 = "AVLr04u0.def"
    
    /// shrub
    /// Terrain kind: rough
    case shrub_avlsh1r0 = "avlsh1r0.def"
    
    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu08 = "avlxsu08.def"

    /// borderguard - white
    /// Terrain kind: Land
    case borderguardWhite_AVXbor60 = "AVXbor60.def"

    /// monster - azureDragon
    /// Terrain kind: Land
    case azureDragon_AVWazure = "AVWazure.def"

    /// monster - faerieDragon
    /// Terrain kind: Land
    case faerieDragon_AVWfdrg = "AVWfdrg.def"

    /// keymastersTent - white
    /// Terrain kind: Land
    case keymastersTentWhite_AVXkey60 = "AVXkey60.def"

    /// monster - crystalDragon
    /// Terrain kind: Land
    case crystalDragon_AVWcdrg = "AVWcdrg.def"

    /// monster - enchanter
    /// Terrain kind: Land
    case enchanter_AVWench = "AVWench.def"

    /// magicClouds
    /// Terrain kind: Land
    case magicClouds_AVXmc0 = "AVXmc0.def"

    /// magicClouds
    /// Terrain kind: Land
    case magicClouds_AVXmc6 = "AVXmc6.def"

    /// magicClouds
    /// Terrain kind: Land
    case magicClouds_AVXmc5 = "AVXmc5.def"

    /// magicClouds
    /// Terrain kind: Land
    case magicClouds_AVXmc7 = "AVXmc7.def"

    /// magicClouds
    /// Terrain kind: Land
    case magicClouds_AVXmc3 = "AVXmc3.def"

    /// evilFog
    /// Terrain kind: Land
    case evilFog_AVXef1 = "AVXef1.def"

    /// evilFog
    /// Terrain kind: Land
    case evilFog_AVXef7 = "AVXef7.def"

    /// evilFog
    /// Terrain kind: Land
    case evilFog_AVXef4 = "AVXef4.def"

    /// evilFog
    /// Terrain kind: Land
    case evilFog_AVXef0 = "AVXef0.def"

    /// rocklands
    /// Terrain kind: Land
    case rocklands_AVXrk2 = "AVXrk2.def"

    /// rocklands
    /// Terrain kind: Land
    case rocklands_AVXrk1 = "AVXrk1.def"

    /// rocklands
    /// Terrain kind: Land
    case rocklands_AVXrk4 = "AVXrk4.def"

    /// rocklands
    /// Terrain kind: Land
    case rocklands_AVXrk6 = "AVXrk6.def"

    /// monolithOneWayEntrance - purpleWithWhiteSwirl
    /// Terrain kind: Land
    case monolithOneWayEntrancePurpleWithWhiteSwirl_AVXmn5i0 = "AVXmn5i0.def"

    /// monolithOneWayExit - purpleWithWhiteSwirl
    /// Terrain kind: Land
    case monolithOneWayExitPurpleWithWhiteSwirl_AVXmn5o0 = "AVXmn5o0.def"

    /// monolithOneWayEntrance - yellowGlowingSpots
    /// Terrain kind: Land
    case monolithOneWayEntranceYellowGlowingSpots_AVXmn6i0 = "AVXmn6i0.def"

    /// monolithOneWayExit - yellowGlowingSpots
    /// Terrain kind: Land
    case monolithOneWayExitYellowGlowingSpots_AVXmn6o0 = "AVXmn6o0.def"

    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu12 = "avlxsu12.def"

    /// monster - sharpshooter
    /// Terrain kind: Land
    case sharpshooter_AVWsharp = "AVWsharp.def"

    /// cloverField
    /// Terrain kind: Land
    case cloverField_AVXcf4 = "AVXcf4.def"

    /// cloverField
    /// Terrain kind: Land
    case cloverField_AVXcf3 = "AVXcf3.def"

    /// cloverField
    /// Terrain kind: Land
    case cloverField_AVXcf7 = "AVXcf7.def"

    /// holyGround
    /// Terrain kind: Land
    case holyGround_AVXhg7 = "AVXhg7.def"

    /// holyGround
    /// Terrain kind: Land
    case holyGround_AVXhg3 = "AVXhg3.def"

    /// holyGround
    /// Terrain kind: Land
    case holyGround_AVXhg6 = "AVXhg6.def"

    /// holyGround
    /// Terrain kind: Land
    case holyGround_AVXhg0 = "AVXhg0.def"

    /// holyGround
    /// Terrain kind: Land
    case holyGround_AVXhg4 = "AVXhg4.def"
    
    /// artifact - shieldOfTheDwarvenLords
    /// Terrain kind: dirt
    case shieldOfTheDwarvenLords_AVA0013 = "AVA0013.def"

    /// artifact - spellbindersHat
    /// Terrain kind: dirt
    case spellbindersHat_AVA0124 = "AVA0124.def"

    /// artifact - inexhaustibleCartOfLumber
    /// Terrain kind: dirt
    case inexhaustibleCartOfLumber_AVA0114 = "AVA0114.def"

    /// artifact - legsOfLegion
    /// Terrain kind: dirt
    case legsOfLegion_AVA0118 = "AVA0118.def"

    /// artifact - headOfLegion
    /// Terrain kind: dirt
    case headOfLegion_AVA0122 = "AVA0122.def"

    /// artifact - inexhaustibleCartOfOre
    /// Terrain kind: dirt
    case inexhaustibleCartOfOre_AVA0112 = "AVA0112.def"

    /// artifact - loinsOfLegion
    /// Terrain kind: dirt
    case loinsOfLegion_AVA0119 = "AVA0119.def"
    
    /// randomTown
    /// Terrain kind: Land
    case randomTown_AVCrand0 = "AVCrand0.def"

    /// creatureGenerator1 - wyvernNest
    /// Terrain kind: Land
    case wyvernNest_AVGwyvn0 = "AVGwyvn0.def"

    /// garrison - true
    /// Terrain kind: Land
    case garrisonTrue_AVCgar20 = "AVCgar20.def"

    /// monster - ogre
    /// Terrain kind: dirt
    case ogre_AVWogre0 = "AVWogre0.def"

    /// monster - wyvernMonarch
    /// Terrain kind: dirt
    case wyvernMonarch_AVWwyvx0 = "AVWwyvx0.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_avlsh3r0 = "avlsh3r0.def"

    /// monster - wolfRaider
    /// Terrain kind: dirt
    case wolfRaider_AVWwolx0 = "AVWwolx0.def"
    
    /// crater
    /// Terrain kind: swamp
    case crater_AVLctrs0 = "AVLctrs0.def"

    /// town - necropolis
    /// Terrain kind: Land
    case townNecropolis_AVCnecr0 = "AVCnecr0.def"

    /// monster - harpy
    /// Terrain kind: dirt
    case harpy_AVWharp0 = "AVWharp0.def"

    /// monster - monk
    /// Terrain kind: grass
    case monk_AvWMonk = "AvWMonk.def"

    /// monster - roc
    /// Terrain kind: dirt
    case roc_AVWroc0 = "AVWroc0.def"

    /// monster - redDragon
    /// Terrain kind: grass
    case redDragon_AvWRDrg = "AvWRDrg.def"

    /// monster - greenDragon
    /// Terrain kind: dirt
    case greenDragon_AVWdrag0 = "AVWdrag0.def"

    /// monster - orcChieftain
    /// Terrain kind: dirt
    case orcChieftain_AVWorcx0 = "AVWorcx0.def"

    /// monster - hobgoblin
    /// Terrain kind: dirt
    case hobgoblin_AVWgobx0 = "AVWgobx0.def"

    /// monster - goldDragon
    /// Terrain kind: dirt
    case goldDragon_AVWdrax0 = "AVWdrax0.def"

    /// monster - titan
    /// Terrain kind: dirt
    case titan_AVWtitx0 = "AVWtitx0.def"

    /// artifact - lionsShieldOfCourage
    /// Terrain kind: dirt
    case lionsShieldOfCourage_AVA0034 = "AVA0034.def"

    /// artifact - ringOfVitality
    /// Terrain kind: dirt
    case ringOfVitality_AVA0094 = "AVA0094.def"

    /// artifact - dragonScaleArmor
    /// Terrain kind: dirt
    case dragonScaleArmor_AVA0040 = "AVA0040.def"

    /// artifact - crownOfDragontooth
    /// Terrain kind: dirt
    case crownOfDragontooth_AVA0044 = "AVA0044.def"

    /// monster - blackDragon
    /// Terrain kind: dirt
    case blackDragon_AVWddrx0 = "AVWddrx0.def"

    /// artifact - necklaceOfDragonteeth
    /// Terrain kind: dirt
    case necklaceOfDragonteeth_AVA0043 = "AVA0043.def"

    /// artifact - pendantOfDispassion
    /// Terrain kind: dirt
    case pendantOfDispassion_AVA0100 = "AVA0100.def"

    /// monster - goblin
    /// Terrain kind: dirt
    case goblin_AVWgobl0 = "AVWgobl0.def"

    /// monster - gog
    /// Terrain kind: dirt
    case gog_AVWgog0 = "AVWgog0.def"

    /// monster - gremlin
    /// Terrain kind: dirt
    case gremlin_AVWgrem0 = "AVWgrem0.def"

    /// monster - dendroidGuard
    /// Terrain kind: dirt
    case dendroidGuard_AVWtree0 = "AVWtree0.def"

    /// artifact - pendantOfDeath
    /// Terrain kind: dirt
    case pendantOfDeath_AVA0104 = "AVA0104.def"

    /// monster - gnoll
    /// Terrain kind: dirt
    case gnoll_AVWgnll0 = "AVWgnll0.def"

    /// monster - beholder
    /// Terrain kind: dirt
    case beholder_AVWbehl0 = "AVWbehl0.def"

    /// monster - masterGenie
    /// Terrain kind: dirt
    case masterGenie_AVWgenx0 = "AVWgenx0.def"

    /// mine - goldMine
    /// Terrain kind: subterranean
    case goldMine_AVMgosb0 = "AVMgosb0.def"

    /// artifact - bootsOfSpeed
    /// Terrain kind: dirt
    case bootsOfSpeed_AVA0098 = "AVA0098.def"

    /// mountain
    /// Terrain kind: subterranean
    case mountain_AVLmtsb1 = "AVLmtsb1.def"

    /// artifact - shieldOfTheDamned
    /// Terrain kind: dirt
    case shieldOfTheDamned_AVA0017 = "AVA0017.def"

    /// artifact - titansCuirass
    /// Terrain kind: dirt
    case titansCuirass_AVA0030 = "AVA0030.def"

    /// monster - blackKnight
    /// Terrain kind: dirt
    case blackKnight_AVWbkni0 = "AVWbkni0.def"

    /// monster - pitFiend
    /// Terrain kind: dirt
    case pitFiend_AVWpitf0 = "AVWpitf0.def"

    /// outcropping
    /// Terrain kind: subterranean
    case outcropping_AVLoc2u0 = "AVLoc2u0.def"

    /// mine - orePit
    /// Terrain kind: subterranean
    case orePit_AVMorsb0 = "AVMorsb0.def"

    /// monster - hornedDemon
    /// Terrain kind: dirt
    case hornedDemon_AVWdemx0 = "AVWdemx0.def"

    /// artifact - dragonboneGreaves
    /// Terrain kind: dirt
    case dragonboneGreaves_AVA0041 = "AVA0041.def"
    
    /// town - dungeon
    /// Terrain kind: Land
    case townDungeon_AVCdung0 = "AVCdung0.def"

    /// hero - ranger
    /// Terrain kind: Land
    case heroRanger_ah02_e = "ah02_e.def"

    /// mine - crystalCavern
    /// Terrain kind: swamp
    case crystalCavern_AVMcrsw0 = "AVMcrsw0.def"

    /// creatureGenerator1 - dwarfCottage
    /// Terrain kind: Land
    case dwarfCottage_AVGdwrf0 = "AVGdwrf0.def"

    /// artifact - endlessPurseOfGold
    /// Terrain kind: dirt
    case endlessPurseOfGold_AVA0117 = "AVA0117.def"

    /// artifact - diplomatsRing
    /// Terrain kind: dirt
    case diplomatsRing_AVA0067 = "AVA0067.def"

    /// creatureGenerator1 - enchantedSpring
    /// Terrain kind: Land
    case enchantedSpring_AVGpega0 = "AVGpega0.def"

    /// monster - silverPegasus
    /// Terrain kind: dirt
    case silverPegasus_AVWpegx0 = "AVWpegx0.def"

    /// monster - unicorn
    /// Terrain kind: dirt
    case unicorn_AVWunic0 = "AVWunic0.def"

    /// monster - centaurCaptain
    /// Terrain kind: dirt
    case centaurCaptain_AVWcenx0 = "AVWcenx0.def"

    /// monster - zealot
    /// Terrain kind: dirt
    case zealot_AVWmonx0 = "AVWmonx0.def"

    /// monster - ogreMage
    /// Terrain kind: dirt
    case ogreMage_AVWogrx0 = "AVWogrx0.def"

    /// artifact - necklaceOfOceanGuidance
    /// Terrain kind: dirt
    case necklaceOfOceanGuidance_AVA0071 = "AVA0071.def"

    /// hero - warlock
    /// Terrain kind: Land
    case heroWarlock_ah11_e = "ah11_e.def"

    /// hero - overlord
    /// Terrain kind: Land
    case heroOverlord_ah10_e = "ah10_e.def"

    /// monster - cyclops
    /// Terrain kind: dirt
    case cyclops_AVWcycl0 = "AVWcycl0.def"

    /// hero - cleric
    /// Terrain kind: Land
    case heroCleric_ah01_e = "ah01_e.def"

    /// monster - earthElemental
    /// Terrain kind: dirt
    case earthElemental_AVWelme0 = "AVWelme0.def"

    /// monster - airElemental
    /// Terrain kind: dirt
    case airElemental_AVWelma0 = "AVWelma0.def"

    /// monster - medusaQueen
    /// Terrain kind: dirt
    case medusaQueen_AVWmedx0 = "AVWmedx0.def"

    /// monster - vampire
    /// Terrain kind: dirt
    case vampire_AVWvamp0 = "AVWvamp0.def"

    /// artifact - endlessBagOfGold
    /// Terrain kind: dirt
    case endlessBagOfGold_AVA0116 = "AVA0116.def"

    /// creatureGenerator1 - waterConflux
    /// Terrain kind: Land
    case waterConflux_AVGwatr0 = "AVGwatr0.def"

    /// hero - druid
    /// Terrain kind: Land
    case heroDruid_ah03_e = "ah03_e.def"

    /// creatureGenerator1 - dendroidArches
    /// Terrain kind: Land
    case dendroidArches_AVGtree0 = "AVGtree0.def"

    /// monster - hydra
    /// Terrain kind: grass
    case hydra_AvWHydr = "AvWHydr.def"

    /// monster - giant
    /// Terrain kind: dirt
    case giant_AVWtitn0 = "AVWtitn0.def"

    /// creatureGenerator1 - dragonCliffs
    /// Terrain kind: Land
    case dragonCliffs_AVGgdrg0 = "AVGgdrg0.def"

    /// monster - wraith
    /// Terrain kind: dirt
    case wraith_AVWwigx0 = "AVWwigx0.def"

    /// monster - vampireLord
    /// Terrain kind: dirt
    case vampireLord_AVWvamx0 = "AVWvamx0.def"

    /// monster - powerLich
    /// Terrain kind: dirt
    case powerLich_AVWlicx0 = "AVWlicx0.def"

    /// monster - wight
    /// Terrain kind: Land
    case wight_AvWWigh = "AvWWigh.def"

    /// monster - walkingDead
    /// Terrain kind: dirt
    case walkingDead_AVWzomb0 = "AVWzomb0.def"

    /// monster - dreadKnight
    /// Terrain kind: dirt
    case dreadKnight_AVWbknx0 = "AVWbknx0.def"

    /// monster - zombie
    /// Terrain kind: dirt
    case zombie_AVWzomx0 = "AVWzomx0.def"

    /// monster - lich
    /// Terrain kind: dirt
    case lich_AVWlich0 = "AVWlich0.def"

    /// monster - wyvern
    /// Terrain kind: grass
    case wyvern_AvWWyvr = "AvWWyvr.def"

    /// hero - deathKnight
    /// Terrain kind: Land
    case heroDeathKnight_ah08_e = "ah08_e.def"

    /// monster - minotaurKing
    /// Terrain kind: dirt
    case minotaurKing_AVWminx0 = "AVWminx0.def"

    /// monster - minotaur
    /// Terrain kind: grass
    case minotaur_AvWMino = "AvWMino.def"

    /// hero - necromancer
    /// Terrain kind: Land
    case heroNecromancer_ah09_e = "ah09_e.def"

    /// monster - cerberus
    /// Terrain kind: dirt
    case cerberus_AVWhoux0 = "AVWhoux0.def"

    /// crater
    /// Terrain kind: subterranean
    case crater_AVLlk2u0 = "AVLlk2u0.def"
    
    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca020 = "AVLca020.def"

    /// coverOfDarkness
    /// Terrain kind: Land
    case coverOfDarkness_AVXcovr0 = "AVXcovr0.def"
    
    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu09 = "avlxsu09.def"

    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu07 = "avlxsu07.def"

    /// moss
    /// Terrain kind: swamp
    case moss_AVLmoss0 = "AVLmoss0.def"

    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu01 = "avlxsu01.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt15 = "avlswt15.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLstg30 = "AVLstg30.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLstg20 = "AVLstg20.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt05 = "avlswt05.def"

    /// abandonedMine
    /// Terrain kind: snow
    case abandonedMine_AVXamSn = "AVXamSn.def"

    /// redwoodObservatory
    /// Terrain kind: snow
    case redwoodObservatory_AVXreds0 = "AVXreds0.def"

    /// mine - goldMine
    /// Terrain kind: rough
    case goldMine_AVMgorf0 = "AVMgorf0.def"

    /// mine - crystalCavern
    /// Terrain kind: rough
    case crystalCavern_AVMcrrf0 = "AVMcrrf0.def"

    /// abandonedMine
    /// Terrain kind: rough
    case abandonedMine_AVXamRo = "AVXamRo.def"

    /// randomDwelling
    /// Terrain kind: Land
    case randomDwelling_avrcgen0 = "avrcgen0.def"

    /// tavern
    /// Terrain kind: Land
    case tavern_AVXtvrn0 = "AVXtvrn0.def"

    /// borderGate - black
    /// Terrain kind: Land
    case borderGateBlack_avxbgt70 = "avxbgt70.def"

    /// borderGate - playerOne
    /// Terrain kind: Land
    case borderGatePlayerOne_avxbgt20 = "avxbgt20.def"

    /// artifact - sentinelsShield
    /// Terrain kind: dirt
    case sentinelsShield_AVA0018 = "AVA0018.def"

    /// riverDelta
    /// Terrain kind: dirt, sand, grass
    case riverDelta_clrdelt2 = "clrdelt2.def"

    /// garrison2
    /// Terrain kind: Land
    case garrison2_AVCvgr = "AVCvgr.def"

    /// randomArtifact
    /// Terrain kind: dirt
    case randomArtifact_AVArand = "AVArand.def"

    /// randomHero
    /// Terrain kind: Land
    case randomHero_ahrandom = "ahrandom.def"

    /// borderGate - playerFour
    /// Terrain kind: Land
    case borderGatePlayerFour_avxbgt10 = "avxbgt10.def"

    /// monster - iceElemental
    /// Terrain kind: Land
    case iceElemental_AVWicee = "AVWicee.def"

    /// cartographer
    /// Terrain kind: dirt, sand, grass, snow, swamp, rough, lava
    case cartographer_AVXmaps0 = "AVXmaps0.def"

    /// cloverField
    /// Terrain kind: Land
    case cloverField_AVXcf2 = "AVXcf2.def"

    /// cloverField
    /// Terrain kind: Land
    case cloverField_AVXcf1 = "AVXcf1.def"

    /// evilFog
    /// Terrain kind: Land
    case evilFog_AVXef2 = "AVXef2.def"

    /// evilFog
    /// Terrain kind: Land
    case evilFog_AVXef3 = "AVXef3.def"

    /// evilFog
    /// Terrain kind: Land
    case evilFog_AVXef5 = "AVXef5.def"

    /// evilFog
    /// Terrain kind: Land
    case evilFog_AVXef6 = "AVXef6.def"

    /// holyGround
    /// Terrain kind: Land
    case holyGround_AVXhg2 = "AVXhg2.def"

    /// fieryFields
    /// Terrain kind: Land
    case fieryFields_AVXff1 = "AVXff1.def"

    /// fieryFields
    /// Terrain kind: Land
    case fieryFields_AVXff0 = "AVXff0.def"

    /// monolithTwoWay - glowingSphere
    /// Terrain kind: Land
    case monolithTwoWayGlowingSphere_AVXmn7b0 = "AVXmn7b0.def"

    /// monolithTwoWay - whirlingShape
    /// Terrain kind: Land
    case monolithTwoWayWhirlingShape_AVXmn8b0 = "AVXmn8b0.def"

    /// cursedGround2
    /// Terrain kind: Land
    case cursedGround2_AVXcg2 = "AVXcg2.def"

    /// lucidPools
    /// Terrain kind: Land
    case lucidPools_AVXlp2 = "AVXlp2.def"

    /// lucidPools
    /// Terrain kind: Land
    case lucidPools_AVXlp0 = "AVXlp0.def"

    /// cursedGround2
    /// Terrain kind: Land
    case cursedGround2_AVXcg1 = "AVXcg1.def"

    /// fieryFields
    /// Terrain kind: Land
    case fieryFields_AVXff5 = "AVXff5.def"

    /// monster - fireElemental
    /// Terrain kind: dirt
    case fireElemental_AVWelmf0 = "AVWelmf0.def"

    /// cloverField
    /// Terrain kind: Land
    case cloverField_AVXcf5 = "AVXcf5.def"
    
    /// randomTown
    /// Terrain kind: Land
    case randomTown_AVCranx0 = "AVCranx0.def"

    /// riverDelta
    /// Terrain kind: lava
    case riverDelta_lavdelt1 = "lavdelt1.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_avlsh8r0 = "avlsh8r0.def"

    /// hole
    /// Terrain kind: rough
    case hole_AVLholr0 = "AVLholr0.def"

    /// crater
    /// Terrain kind: rough
    case crater_AVLctrr0 = "AVLctrr0.def"

    /// creatureGenerator1 - fireConflux
    /// Terrain kind: Land
    case fireConflux_AVGfire0 = "AVGfire0.def"

    /// creatureGenerator1 - earthConflux
    /// Terrain kind: Land
    case earthConflux_AVGerth0 = "AVGerth0.def"

    /// swanPond
    /// Terrain kind: dirt
    case swanPond_AVSclvd0 = "AVSclvd0.def"

    /// dragonUtopia
    /// Terrain kind: Land
    case dragonUtopia_AVSutop0 = "AVSutop0.def"

    /// monster - battleDwarf
    /// Terrain kind: dirt
    case battleDwarf_AVWdwrx0 = "AVWdwrx0.def"

    /// crypt
    /// Terrain kind: snow
    case crypt_AVXgysn0 = "AVXgysn0.def"

    /// creatureGenerator1 - lizardDen
    /// Terrain kind: Land
    case lizardDen_AVGlzrd0 = "AVGlzrd0.def"

    /// monster - archer
    /// Terrain kind: grass
    case archer_AvWLCrs = "AvWLCrs.def"

    /// monster - wolfRider
    /// Terrain kind: dirt
    case wolfRider_AVWwolf0 = "AVWwolf0.def"

    /// creatureGenerator1 - cliffNest
    /// Terrain kind: Land
    case cliffNest_AVGrocs0 = "AVGrocs0.def"

    /// university
    /// Terrain kind: Land
    case university_AVSuniv0 = "AVSuniv0.def"

    /// randomMonsterLevel7
    /// Terrain kind: dirt
    case randomMonsterLevel7_AVWmon7 = "AVWmon7.def"

    /// mound
    /// Terrain kind: rough
    case mound_AVLmd2r0 = "AVLmd2r0.def"

    /// creatureGenerator1 - behemothCrag
    /// Terrain kind: Land
    case behemothCrag_AVGbhmt0 = "AVGbhmt0.def"

    /// artifact - spyglass
    /// Terrain kind: dirt
    case spyglass_AVA0053 = "AVA0053.def"

    /// monster - centaur
    /// Terrain kind: dirt
    case centaur_AVWcent0 = "AVWcent0.def"

    /// warriorsTomb
    /// Terrain kind: Land
    case warriorsTomb_AVXtomb0 = "AVXtomb0.def"

    /// randomDwellingWithLevel - level1
    /// Terrain kind: Land
    case randomDwellingWithLevelLevel1_avrcgen1 = "avrcgen1.def"

    /// randomDwellingWithLevel - level2
    /// Terrain kind: Land
    case randomDwellingWithLevelLevel2_avrcgen2 = "avrcgen2.def"

    /// randomDwellingWithLevel - level3
    /// Terrain kind: Land
    case randomDwellingWithLevelLevel3_avrcgen3 = "avrcgen3.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro11 = "avlxro11.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds06 = "avlxds06.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds07 = "avlxds07.def"

    /// grail
    /// Terrain kind: dirt
    case grail_AVZgrail = "AVZgrail.def"

    /// riverDelta
    /// Terrain kind: lava
    case riverDelta_lavdelt3 = "lavdelt3.def"

    /// creatureGenerator1 - airConflux
    /// Terrain kind: Land
    case airConflux_AVGair0 = "AVGair0.def"

    /// tradingPostSnow
    /// Terrain kind: snow
    case tradingPostSnow_AVXpsSn = "AVXpsSn.def"

    /// crater
    /// Terrain kind: rough
    case crater_AVLct3r0 = "AVLct3r0.def"

    /// creatureGenerator1 - hydraPond
    /// Terrain kind: Land
    case hydraPond_AVGhydr0 = "AVGhydr0.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswtr9 = "avlswtr9.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw06 = "avlxsw06.def"

    /// denOfThieves
    /// Terrain kind: Land
    case denOfThieves_AVXdend0 = "AVXdend0.def"

    /// creatureGenerator1 - serpentFlyHive
    /// Terrain kind: Land
    case serpentFlyHive_AVGdfly0 = "AVGdfly0.def"

    /// monster - serpentFly
    /// Terrain kind: grass
    case serpentFly_AvWDFly = "AvWDFly.def"

    /// creatureGenerator1 - basiliskPit
    /// Terrain kind: Land
    case basiliskPit_AVGbasl0 = "AVGbasl0.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt00 = "avlswt00.def"

    /// abandonedMine
    /// Terrain kind: lava
    case abandonedMine_AVXamLv = "AVXamLv.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds01 = "avlxds01.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds03 = "avlxds03.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds04 = "avlxds04.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt02 = "avlswt02.def"

    /// monster - woodElf
    /// Terrain kind: dirt
    case woodElf_AVWelfw0 = "AVWelfw0.def"

    /// monster - mage
    /// Terrain kind: dirt
    case mage_AVWmage0 = "AVWmage0.def"

    /// monster - waterElemental
    /// Terrain kind: dirt
    case waterElemental_AVWelmw0 = "AVWelmw0.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds02 = "avlxds02.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro12 = "avlxro12.def"

    /// monster - basilisk
    /// Terrain kind: grass
    case basilisk_AvWBasl = "AvWBasl.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro05 = "avlxro05.def"

    /// lake2
    /// Terrain kind: rough
    case lake2_AVLlk1r = "AVLlk1r.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt06 = "avlswt06.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt16 = "avlswt16.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca090 = "AVLca090.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt07 = "avlswt07.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds11 = "avlxds11.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt08 = "avlxdt08.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt19 = "avlswt19.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt12 = "avlswt12.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt04 = "avlswt04.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw07 = "avlxsw07.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw08 = "avlxsw08.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw09 = "avlxsw09.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt01 = "avlswt01.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw10 = "avlxsw10.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt09 = "avlswt09.def"

    /// crater
    /// Terrain kind: subterranean
    case crater_AVLct4u0 = "AVLct4u0.def"

    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu04 = "avlxsu04.def"

    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu02 = "avlxsu02.def"

    /// pillarOfFire
    /// Terrain kind: subterranean
    case pillarOfFire_AVXpllr0 = "AVXpllr0.def"

    /// randomDwellingWithLevel - level4
    /// Terrain kind: Land
    case randomDwellingWithLevelLevel4_avrcgen4 = "avrcgen4.def"

    /// randomDwellingWithLevel - level5
    /// Terrain kind: Land
    case randomDwellingWithLevelLevel5_avrcgen5 = "avrcgen5.def"

    /// randomDwellingWithLevel - level6
    /// Terrain kind: Land
    case randomDwellingWithLevelLevel6_avrcgen6 = "avrcgen6.def"

    /// artifact - redDragonFlameTongue
    /// Terrain kind: dirt
    case redDragonFlameTongue_AVA0038 = "AVA0038.def"

    /// monster - chaosHydra
    /// Terrain kind: dirt
    case chaosHydra_AVWhydx0 = "AVWhydx0.def"

    /// artifact - bucklerOfTheGnollKing
    /// Terrain kind: dirt
    case bucklerOfTheGnollKing_AVA0015 = "AVA0015.def"

    /// artifact - helmOfChaos
    /// Terrain kind: dirt
    case helmOfChaos_AVA0021 = "AVA0021.def"

    /// artifact - sandalsOfTheSaint
    /// Terrain kind: dirt
    case sandalsOfTheSaint_AVA0032 = "AVA0032.def"

    /// monster - behemoth
    /// Terrain kind: dirt
    case behemoth_AVWbhmt0 = "AVWbhmt0.def"

    /// randomDwellingWithLevel - level7
    /// Terrain kind: Land
    case randomDwellingWithLevelLevel7_avrcgen7 = "avrcgen7.def"

    /// outcropping
    /// Terrain kind: subterranean
    case outcropping_AVLoc4u0 = "AVLoc4u0.def"

    /// artifact - orbOfTheFirmament
    /// Terrain kind: dirt
    case orbOfTheFirmament_AVA0079 = "AVA0079.def"

    /// artifact - orbOfTempestuousFire
    /// Terrain kind: dirt
    case orbOfTempestuousFire_AVA0081 = "AVA0081.def"

    /// artifact - capeOfVelocity
    /// Terrain kind: dirt
    case capeOfVelocity_AVA0099 = "AVA0099.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLstg10 = "AVLstg10.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr09u0 = "AVLr09u0.def"

    /// monster - mightyGorgon
    /// Terrain kind: dirt
    case mightyGorgon_AVWgorx0 = "AVWgorx0.def"

    /// artifact - bowstringOfTheUnicornsMane
    /// Terrain kind: dirt
    case bowstringOfTheUnicornsMane_AVA0061 = "AVA0061.def"

    /// cartographer
    /// Terrain kind: subterranean
    case cartographer_AVXmapu0 = "AVXmapu0.def"

    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu10 = "avlxsu10.def"

    /// crater
    /// Terrain kind: subterranean
    case crater_AVLct3u0 = "AVLct3u0.def"

    /// crater
    /// Terrain kind: subterranean
    case crater_AVLct1u0 = "AVLct1u0.def"
    
    /// town - tower
    /// Terrain kind: Land
    case townTower_AVCtowx0 = "AVCtowx0.def"

    /// town - stronghold
    /// Terrain kind: Land
    case townStronghold_AVCstrx0 = "AVCstrx0.def"

    /// town - castle
    /// Terrain kind: Land
    case townCastle_AVCcasx0 = "AVCcasx0.def"

    /// town - rampart
    /// Terrain kind: Land
    case townRampart_AVCramx0 = "AVCramx0.def"

    /// town - necropolis
    /// Terrain kind: Land
    case townNecropolis_AVCnecx0 = "AVCnecx0.def"

    /// town - dungeon
    /// Terrain kind: Land
    case townDungeon_AVCdunx0 = "AVCdunx0.def"

    /// town - inferno
    /// Terrain kind: Land
    case townInferno_AVCinfx0 = "AVCinfx0.def"

    /// shipyard
    /// Terrain kind: Land
    case shipyard_AVXshyd0 = "AVXshyd0.def"

    /// creatureGenerator1 - thatchedHut
    /// Terrain kind: Land
    case thatchedHut_AVGhalf = "AVGhalf.def"

    /// seersHut
    /// Terrain kind: Land
    case seersHut_AVXseer0 = "AVXseer0.def"

    /// seersHut (mushroom)
    /// Terrain kind: Land
    case seersHut_AVXseey0 = "AVXseey0.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr01 = "avlxgr01.def"

    /// seersHut (Tree)
    /// Terrain kind: Land
    case seersHut_AVXseeb0 = "AVXseeb0.def"

    /// boat
    /// Terrain kind: Water
    case boat_AVXboat0 = "AVXboat0.def"

    /// creatureGenerator1 - treetopTower
    /// Terrain kind: Land
    case treetopTower_AVGshrp = "AVGshrp.def"

    /// warMachineFactory
    /// Terrain kind: Land
    case warMachineFactory_AVGsieg0 = "AVGsieg0.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr02 = "avlxgr02.def"

    /// creatureGenerator1 - homestead
    /// Terrain kind: Land
    case homestead_AVGelf0 = "AVGelf0.def"

    /// creatureGenerator1 - enchantersHollow
    /// Terrain kind: Land
    case enchantersHollow_AVGench = "AVGench.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLd1sn0 = "AVLd1sn0.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr09 = "avlxgr09.def"

    /// creatureGenerator1 - ogreFort
    /// Terrain kind: Land
    case ogreFort_AVGogre0 = "AVGogre0.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr04 = "avlxgr04.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr03 = "avlxgr03.def"

    /// creatureGenerator1 - griffinTower
    /// Terrain kind: Land
    case griffinTower_AVGgrff0 = "AVGgrff0.def"

    /// rock
    /// Terrain kind: snow
    case rock_AVLr5sn0 = "AVLr5sn0.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtrRo0 = "AVLtrRo0.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo00 = "AVLtRo00.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt11 = "avlxdt11.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo02 = "AVLtRo02.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt05 = "avlxdt05.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt02 = "avlxdt02.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo12 = "AVLtRo12.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt01 = "avlxdt01.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt03 = "avlxdt03.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtrRo7 = "AVLtrRo7.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtrRo3 = "AVLtrRo3.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_avlsh5r0 = "avlsh5r0.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo05 = "AVLtRo05.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtrRo2 = "AVLtrRo2.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw11 = "avlxsw11.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt06 = "avlxdt06.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo06 = "AVLtRo06.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw01 = "avlxsw01.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt07 = "avlxdt07.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtrRo4 = "AVLtrRo4.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw02 = "avlxsw02.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo09 = "AVLtRo09.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt00 = "avlxdt00.def"

    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu03 = "avlxsu03.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswtr1 = "avlswtr1.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro04 = "avlxro04.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo07 = "AVLtRo07.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo11 = "AVLtRo11.def"

    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu06 = "avlxsu06.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt04 = "avlxdt04.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt10 = "avlxdt10.def"

    /// riverDelta
    /// Terrain kind: snow
    case riverDelta_icedelt4 = "icedelt4.def"

    /// riverDelta
    /// Terrain kind: snow, swamp, rough
    case riverDelta_clrdelt4 = "clrdelt4.def"

    /// riverDelta
    /// Terrain kind: snow
    case riverDelta_icedelt2 = "icedelt2.def"

    /// creatureGenerator1 - cursedTemple
    /// Terrain kind: Land
    case cursedTemple_AVGskel0 = "AVGskel0.def"

    /// creatureGenerator1 - graveyard
    /// Terrain kind: Land
    case graveyard_AVGzomb0 = "AVGzomb0.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo01 = "AVLtRo01.def"

    /// creatureGenerator1 - estate
    /// Terrain kind: Land
    case estate_AVGvamp0 = "AVGvamp0.def"

    /// creatureGenerator1 - tombOfSouls
    /// Terrain kind: Land
    case tombOfSouls_AVGwght0 = "AVGwght0.def"

    /// creatureGenerator1 - mausoleum
    /// Terrain kind: Land
    case mausoleum_AVGlich0 = "AVGlich0.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw05 = "avlxsw05.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt08 = "avlswt08.def"

    /// riverDelta
    /// Terrain kind: snow
    case riverDelta_icedelt1 = "icedelt1.def"

    /// creatureGenerator1 - rogueCavern
    /// Terrain kind: Land
    case rogueCavern_AVGrog = "AVGrog.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo04 = "AVLtRo04.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo03 = "AVLtRo03.def"

    /// dirtHills
    /// Terrain kind: dirt
    case dirtHills_avlxdt09 = "avlxdt09.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtrRo1 = "AVLtrRo1.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo10 = "AVLtRo10.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtrRo5 = "AVLtrRo5.def"

    /// town - fortress
    /// Terrain kind: Land
    case townFortress_AVCftrx0 = "AVCftrx0.def"

    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu11 = "avlxsu11.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw03 = "avlxsw03.def"

    /// creatureGenerator1 - trollBridge
    /// Terrain kind: Land
    case trollBridge_AVGtrll = "AVGtrll.def"

    /// riverDelta
    /// Terrain kind: dirt, sand, grass
    case riverDelta_clrdelt1 = "clrdelt1.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt11 = "avlswt11.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt10 = "avlswt10.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr05 = "avlxgr05.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr08 = "avlxgr08.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr06 = "avlxgr06.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtrRo6 = "AVLtrRo6.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro09 = "avlxro09.def"

    /// creatureGenerator1 - hallOfDarkness
    /// Terrain kind: Land
    case hallOfDarkness_AVGbkni0 = "AVGbkni0.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro01 = "avlxro01.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro03 = "avlxro03.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro06 = "avlxro06.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro07 = "avlxro07.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr12 = "avlxgr12.def"

    /// creatureGenerator1 - hovel
    /// Terrain kind: Land
    case hovel_AVGpeas = "AVGpeas.def"

    /// creatureBank - griffinConservatory
    /// Terrain kind: Land
    case griffinConservatory_AVXbnk30 = "AVXbnk30.def"

    /// freelancersGuild
    /// Terrain kind: Land
    case freelancersGuild_avxfgld = "avxfgld.def"

    /// creatureGenerator1 - altarOfWater
    /// Terrain kind: Land
    case altarOfWater_AVG2elw = "AVG2elw.def"

    /// creatureGenerator1 - warren
    /// Terrain kind: Land
    case warren_AVGtrog0 = "AVGtrog0.def"

    /// creatureGenerator1 - harpyLoft
    /// Terrain kind: Land
    case harpyLoft_AVGharp0 = "AVGharp0.def"

    /// creatureGenerator1 - pillarOfEyes
    /// Terrain kind: Land
    case pillarOfEyes_AVGbhld0 = "AVGbhld0.def"

    /// creatureGenerator1 - medusaChapel
    /// Terrain kind: Land
    case medusaChapel_AVGmdsa0 = "AVGmdsa0.def"

    /// creatureGenerator1 - manticoreLair
    /// Terrain kind: Land
    case manticoreLair_AVGmant0 = "AVGmant0.def"

    /// creatureGenerator1 - labyrinth
    /// Terrain kind: Land
    case labyrinth_AVGmino0 = "AVGmino0.def"

    /// creatureGenerator1 - nomadTent
    /// Terrain kind: Land
    case nomadTent_AVGnomd = "AVGnomd.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds10 = "avlxds10.def"

    /// creatureGenerator1 - tombOfCurses
    /// Terrain kind: Land
    case tombOfCurses_AVGmumy = "AVGmumy.def"

    /// mine - crystalCavern
    /// Terrain kind: sand
    case crystalCavern_AVMcrds0 = "AVMcrds0.def"

    /// mine - gemPond
    /// Terrain kind: sand, rough, subterranean
    case gemPond_AVMgerf0 = "AVMgerf0.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds12 = "avlxds12.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds05 = "avlxds05.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds09 = "avlxds09.def"

    /// desertHills
    /// Terrain kind: sand
    case desertHills_avlxds08 = "avlxds08.def"

    /// borderguard - black
    /// Terrain kind: Land
    case borderguardBlack_AVXbor70 = "AVXbor70.def"

    /// artifact - sphereOfPermanence
    /// Terrain kind: dirt
    case sphereOfPermanence_AVA0092 = "AVA0092.def"

    /// artifact - deadMansBoots
    /// Terrain kind: dirt
    case deadMansBoots_AVA0056 = "AVA0056.def"

    /// creatureGenerator1 - mageTower
    /// Terrain kind: Land
    case mageTower_AVGmage0 = "AVGmage0.def"

    /// creatureGenerator1 - altarOfWishes
    /// Terrain kind: Land
    case altarOfWishes_AVGgeni0 = "AVGgeni0.def"

    /// questGuard
    /// Terrain kind: Land
    case questGuard_avxbor80 = "avxbor80.def"

    /// artifact - badgeOfCourage
    /// Terrain kind: dirt
    case badgeOfCourage_AVA0049 = "AVA0049.def"

    /// trees2
    /// Terrain kind: rough
    case trees2_AVLtRo08 = "AVLtRo08.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr10 = "avlxgr10.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt13 = "avlswt13.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt14 = "avlswt14.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt17 = "avlswt17.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswt18 = "avlswt18.def"

    /// keymastersTent - black
    /// Terrain kind: Land
    case keymastersTentBlack_AVXkey70 = "AVXkey70.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr11 = "avlxgr11.def"

    /// artifact - greaterGnollsFlail
    /// Terrain kind: dirt
    case greaterGnollsFlail_AVA0009 = "AVA0009.def"

    /// artifact - skullHelmet
    /// Terrain kind: dirt
    case skullHelmet_AVA0020 = "AVA0020.def"

    /// randomMajorArtifact
    /// Terrain kind: dirt
    case randomMajorArtifact_AVArnd3 = "AVArnd3.def"

    /// randomRelic
    /// Terrain kind: dirt
    case randomRelic_AVArnd4 = "AVArnd4.def"

    /// creatureGenerator1 - magicForest
    /// Terrain kind: Land
    case magicForest_AVGfdrg = "AVGfdrg.def"

    /// creatureGenerator1 - frozenCliffs
    /// Terrain kind: Land
    case frozenCliffs_AVGazur = "AVGazur.def"

    /// creatureGenerator1 - crystalCavern
    /// Terrain kind: Land
    case crystalCavern_AVGcdrg = "AVGcdrg.def"

    /// creatureGenerator1 - sulfurousLair
    /// Terrain kind: Land
    case sulfurousLair_AVGrust = "AVGrust.def"

    /// shipwreck
    /// Terrain kind: Water
    case shipwreck_AVAwre20 = "AVAwre20.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca060 = "AVLca060.def"

    /// subterraneanRocks
    /// Terrain kind: subterranean
    case subterraneanRocks_avlxsu05 = "avlxsu05.def"

    /// swampFoliage
    /// Terrain kind: swamp
    case swampFoliage_avlxsw04 = "avlxsw04.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro08 = "avlxro08.def"

    /// grassHills
    /// Terrain kind: grass
    case grassHills_avlxgr07 = "avlxgr07.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswtr4 = "avlswtr4.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswtr7 = "avlswtr7.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswtr8 = "avlswtr8.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswtr0 = "avlswtr0.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswtr3 = "avlswtr3.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswtr2 = "avlswtr2.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswtr5 = "avlswtr5.def"

    /// trees2
    /// Terrain kind: swamp
    case trees2_avlswtr6 = "avlswtr6.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro10 = "avlxro10.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca030 = "AVLca030.def"

    /// roughHills
    /// Terrain kind: rough
    case roughHills_avlxro02 = "avlxro02.def"

    /// creatureGenerator4 - true
    /// Terrain kind: Land
    case creatureGenerator4True_AVGgolm0 = "AVGgolm0.def"

    /// creatureGenerator1 - centaurStables
    /// Terrain kind: Land
    case centaurStables_AVGcent0 = "AVGcent0.def"

    /// creatureGenerator1 - kennels
    /// Terrain kind: Land
    case kennels_AVGhell0 = "AVGhell0.def"

    /// creatureGenerator1 - fireLake
    /// Terrain kind: Land
    case fireLake_AVGefre0 = "AVGefre0.def"
    
    /// randomMonster
    /// Terrain kind: dirt
    case randomMonster_AVWmrnd0 = "AVWmrnd0.def"

    /// hole
    /// Terrain kind: grass
    case hole_AVLholg0 = "AVLholg0.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv250 = "AVLlv250.def"

    /// monster - halberdier
    /// Terrain kind: dirt
    case halberdier_AVWpikx0 = "AVWpikx0.def"

    /// monster - marksman
    /// Terrain kind: grass
    case marksman_AvWHCrs = "AvWHCrs.def"

    /// monster - crusader
    /// Terrain kind: dirt
    case crusader_AVWswrx0 = "AVWswrx0.def"

    /// sign
    /// Terrain kind: dirt, grass, subterranean
    case sign_AVXsndg0 = "AVXsndg0.def"

    /// hole
    /// Terrain kind: lava
    case hole_AVLholl0 = "AVLholl0.def"

    /// randomTreasureArtifact
    /// Terrain kind: dirt
    case randomTreasureArtifact_AVArnd1 = "AVArnd1.def"

    /// monster - swordsman
    /// Terrain kind: dirt
    case swordsman_AVWswrd0 = "AVWswrd0.def"

    /// hole
    /// Terrain kind: dirt
    case hole_AVLhold0 = "AVLhold0.def"

    /// monster - dwarf
    /// Terrain kind: dirt
    case dwarf_AVWdwrf0 = "AVWdwrf0.def"

    /// oakTrees
    /// Terrain kind: grass, swamp
    case oakTrees_AVLsptr8 = "AVLsptr8.def"

    /// mine - goldMine
    /// Terrain kind: grass
    case goldMine_AVMgogr0 = "AVMgogr0.def"

    /// mine - crystalCavern
    /// Terrain kind: grass
    case crystalCavern_AVMcrgr0 = "AVMcrgr0.def"

    /// creatureGenerator1 - archersTower
    /// Terrain kind: Land
    case archersTower_AVGcros0 = "AVGcros0.def"

    /// creatureGenerator1 - barracks
    /// Terrain kind: Land
    case barracks_AVGswor0 = "AVGswor0.def"

    /// monster - champion
    /// Terrain kind: dirt
    case champion_AVWcvlx0 = "AVWcvlx0.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf08g0 = "AVLf08g0.def"

    /// monster - archangel
    /// Terrain kind: grass
    case archangel_AvWArch = "AvWArch.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG07 = "AvLRG07.def"

    /// creatureGenerator1 - trainingGrounds
    /// Terrain kind: Land
    case trainingGrounds_AVGcavl0 = "AVGcavl0.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf07g0 = "AVLf07g0.def"

    /// monster - cavalier
    /// Terrain kind: dirt
    case cavalier_AVWcvlr0 = "AVWcvlr0.def"

    /// creatureGenerator1 - monastery
    /// Terrain kind: Land
    case monastery_AVGmonk0 = "AVGmonk0.def"

    /// monster - angel
    /// Terrain kind: grass
    case angel_AvWAngl = "AvWAngl.def"

    /// creatureGenerator1 - cloudTemple
    /// Terrain kind: Land
    case cloudTemple_AVGtitn0 = "AVGtitn0.def"

    /// creatureGenerator1 - goldenPavilion
    /// Terrain kind: Land
    case goldenPavilion_AVGnaga0 = "AVGnaga0.def"

    /// monolithTwoWay - purple
    /// Terrain kind: Land
    case monolithTwoWayPurple_AVXmn2p0 = "AVXmn2p0.def"

    /// shrub
    /// Terrain kind: dirt
    case shrub_AVLsh1d0 = "AVLsh1d0.def"

    /// mandrake
    /// Terrain kind: swamp
    case mandrake_AVLman30 = "AVLman30.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_avlsh9r0 = "avlsh9r0.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_AVLsh1r0 = "AVLsh1r0.def"

    /// mandrake
    /// Terrain kind: swamp
    case mandrake_AVLman50 = "AVLman50.def"

    /// lake
    /// Terrain kind: swamp
    case lake_AVLlk2s0 = "AVLlk2s0.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs07s0 = "AVLs07s0.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs04s0 = "AVLs04s0.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs05s0 = "AVLs05s0.def"

    /// shrub
    /// Terrain kind: grass
    case shrub_AVLsh1g0 = "AVLsh1g0.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs02s0 = "AVLs02s0.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs10s0 = "AVLs10s0.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLswp30 = "AVLswp30.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf04g0 = "AVLf04g0.def"

    /// magicPlains
    /// Terrain kind: Land
    case magicPlains_AVXplns0 = "AVXplns0.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf06g0 = "AVLf06g0.def"

    /// creatureGenerator1 - portalOfGlory
    /// Terrain kind: Land
    case portalOfGlory_AVGangl0 = "AVGangl0.def"

    /// creatureGenerator1 - unicornGladeBig
    /// Terrain kind: Land
    case unicornGladeBig_AVGunic0 = "AVGunic0.def"

    /// boat
    /// Terrain kind: Water
    case boat_AVXboat2 = "AVXboat2.def"

    /// monster - stoneGargoyle
    /// Terrain kind: dirt
    case stoneGargoyle_AVWgarg0 = "AVWgarg0.def"

    /// monster - pitLord
    /// Terrain kind: dirt
    case pitLord_AVWpitx0 = "AVWpitx0.def"

    /// monster - manticore
    /// Terrain kind: dirt
    case manticore_AVWmant0 = "AVWmant0.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv130 = "AVLlv130.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLctrl0 = "AVLctrl0.def"

    /// monster - skeletonWarrior
    /// Terrain kind: dirt
    case skeletonWarrior_AVWskex0 = "AVWskex0.def"

    /// monster - boneDragon
    /// Terrain kind: dirt
    case boneDragon_AVWbone0 = "AVWbone0.def"

    /// monster - efreetSultan
    /// Terrain kind: dirt
    case efreetSultan_AVWefrx0 = "AVWefrx0.def"

    /// monster - ghostDragon
    /// Terrain kind: dirt
    case ghostDragon_AVWbonx0 = "AVWbonx0.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLct2l0 = "AVLct2l0.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv100 = "AVLlv100.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv170 = "AVLlv170.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv160 = "AVLlv160.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv110 = "AVLlv110.def"

    /// monster - scorpicore
    /// Terrain kind: dirt
    case scorpicore_AVWmanx0 = "AVWmanx0.def"

    /// mine - goldMine
    /// Terrain kind: lava
    case goldMine_AVMgovo0 = "AVMgovo0.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv210 = "AVLlv210.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv180 = "AVLlv180.def"

    /// monster - devil
    /// Terrain kind: dirt
    case devil_AVWdevl0 = "AVWdevl0.def"

    /// monolithTwoWay - orange
    /// Terrain kind: Land
    case monolithTwoWayOrange_AVXmn2o0 = "AVXmn2o0.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv190 = "AVLlv190.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv200 = "AVLlv200.def"

    /// mountain
    /// Terrain kind: subterranean
    case mountain_AVLmtsb3 = "AVLmtsb3.def"

    /// monster - hellHound
    /// Terrain kind: dirt
    case hellHound_AVWhoun0 = "AVWhoun0.def"

    /// mountain
    /// Terrain kind: subterranean
    case mountain_AVLmtsb5 = "AVLmtsb5.def"

    /// mountain
    /// Terrain kind: subterranean
    case mountain_AVLmtsb0 = "AVLmtsb0.def"

    /// artifact - armsOfLegion
    /// Terrain kind: dirt
    case armsOfLegion_AVA0121 = "AVA0121.def"

    /// monster - familiar
    /// Terrain kind: dirt
    case familiar_AVWimpx0 = "AVWimpx0.def"

    /// mountain
    /// Terrain kind: subterranean
    case mountain_AVLmtsb4 = "AVLmtsb4.def"

    /// monster - nagaQueen
    /// Terrain kind: dirt
    case nagaQueen_AVWnagx0 = "AVWnagx0.def"

    /// mountain
    /// Terrain kind: subterranean
    case mountain_AVLmtsb2 = "AVLmtsb2.def"

    /// randomMinorArtifact
    /// Terrain kind: dirt
    case randomMinorArtifact_AVArnd2 = "AVArnd2.def"

    /// monster - archDevil
    /// Terrain kind: dirt
    case archDevil_AVWdevx0 = "AVWdevx0.def"

    /// monster - demon
    /// Terrain kind: dirt
    case demon_AVWdemn0 = "AVWdemn0.def"

    /// artifact - shieldOfTheYawningDead
    /// Terrain kind: dirt
    case shieldOfTheYawningDead_AVA0014 = "AVA0014.def"

    /// sign
    /// Terrain kind: sand, rough
    case sign_AVXsnds0 = "AVXsnds0.def"

    /// artifact - quietEyeOfTheDragon
    /// Terrain kind: dirt
    case quietEyeOfTheDragon_AVA0037 = "AVA0037.def"

    /// creatureGenerator1 - demonGate
    /// Terrain kind: Land
    case demonGate_AVGdemn0 = "AVGdemn0.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLc12l0 = "AVLc12l0.def"

    /// monolithOneWayEntrance - yellow
    /// Terrain kind: Land
    case monolithOneWayEntranceYellow_AVXmn1y0 = "AVXmn1y0.def"

    /// monolithOneWayExit - yellow
    /// Terrain kind: Land
    case monolithOneWayExitYellow_AVXmx1y0 = "AVXmx1y0.def"

    /// creatureGenerator1 - dragonCave
    /// Terrain kind: Land
    case dragonCave_AVGrdrg0 = "AVGrdrg0.def"

    /// lavaFlow
    /// Terrain kind: subterranean
    case lavaFlow_AVLlv3u0 = "AVLlv3u0.def"

    /// lavaFlow
    /// Terrain kind: subterranean
    case lavaFlow_AVLlv2u0 = "AVLlv2u0.def"

    /// lavaLake
    /// Terrain kind: subterranean
    case lavaLake_AVLllk20 = "AVLllk20.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms120 = "AVLms120.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms020 = "AVLms020.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLstg50 = "AVLstg50.def"

    /// outcropping
    /// Terrain kind: subterranean
    case outcropping_AVLoc1u0 = "AVLoc1u0.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms030 = "AVLms030.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms080 = "AVLms080.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms050 = "AVLms050.def"

    /// lavaFlow
    /// Terrain kind: subterranean
    case lavaFlow_AVLlv1u0 = "AVLlv1u0.def"

    /// lavaLake
    /// Terrain kind: subterranean
    case lavaLake_AVLllk10 = "AVLllk10.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms100 = "AVLms100.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms040 = "AVLms040.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms060 = "AVLms060.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms070 = "AVLms070.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms090 = "AVLms090.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms010 = "AVLms010.def"

    /// mushrooms
    /// Terrain kind: subterranean
    case mushrooms_AVLms110 = "AVLms110.def"

    /// hole
    /// Terrain kind: subterranean
    case hole_AVLholx0 = "AVLholx0.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_AVLsh2r0 = "AVLsh2r0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr10u0 = "AVLr10u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr11u0 = "AVLr11u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr07u0 = "AVLr07u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr02u0 = "AVLr02u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr05u0 = "AVLr05u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr08u0 = "AVLr08u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr13u0 = "AVLr13u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr16u0 = "AVLr16u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr12u0 = "AVLr12u0.def"

    /// lake
    /// Terrain kind: subterranean
    case lake_AVLlk3u0 = "AVLlk3u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr01u0 = "AVLr01u0.def"

    /// crater
    /// Terrain kind: subterranean
    case crater_AVLct5u0 = "AVLct5u0.def"

    /// hero - demoniac
    /// Terrain kind: Land
    case heroDemoniac_ah06_e = "ah06_e.def"

    /// creatureGenerator1 - hellHole
    /// Terrain kind: Land
    case hellHole_AVGpit0 = "AVGpit0.def"

    /// creatureGenerator1 - forsakenPalace
    /// Terrain kind: Land
    case forsakenPalace_AVGdevl0 = "AVGdevl0.def"

    /// crater
    /// Terrain kind: subterranean
    case crater_AVLct2u0 = "AVLct2u0.def"
    
    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgn1 = "AVLmtgn1.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgr1 = "AVLmtgr1.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgr5 = "AVLmtgr5.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgr3 = "AVLmtgr3.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgn4 = "AVLmtgn4.def"

    /// crater
    /// Terrain kind: grass
    case crater_AVLctrg0 = "AVLctrg0.def"

    /// crater
    /// Terrain kind: grass
    case crater_AVLct3g0 = "AVLct3g0.def"

    /// crater
    /// Terrain kind: grass
    case crater_AVLct1g0 = "AVLct1g0.def"

    /// crater
    /// Terrain kind: grass
    case crater_AVLct6g0 = "AVLct6g0.def"

    /// crater
    /// Terrain kind: grass
    case crater_AVLct5g0 = "AVLct5g0.def"

    /// oakTrees
    /// Terrain kind: dirt, grass, swamp
    case oakTrees_AVLAUTR4 = "AVLAUTR4.def"

    /// oakTrees
    /// Terrain kind: dirt, grass, swamp
    case oakTrees_AVLautr6 = "AVLautr6.def"

    /// pineTrees
    /// Terrain kind: dirt, grass
    case pineTrees_AVLPNTR0 = "AVLPNTR0.def"

    /// pineTrees
    /// Terrain kind: dirt, grass
    case pineTrees_AVLPNTR3 = "AVLPNTR3.def"

    /// pineTrees
    /// Terrain kind: dirt, grass
    case pineTrees_AVLPNTR1 = "AVLPNTR1.def"

    /// pineTrees
    /// Terrain kind: dirt, grass
    case pineTrees_AVLPNTR5 = "AVLPNTR5.def"

    /// outcropping
    /// Terrain kind: grass
    case outcropping_AVLoc3g0 = "AVLoc3g0.def"

    /// oakTrees
    /// Terrain kind: dirt, grass, swamp
    case oakTrees_avlautr1 = "avlautr1.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgn0 = "AVLmtgn0.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgn2 = "AVLmtgn2.def"

    /// pineTrees
    /// Terrain kind: dirt, grass
    case pineTrees_AVLPNTR4 = "AVLPNTR4.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgn3 = "AVLmtgn3.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgn5 = "AVLmtgn5.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgr2 = "AVLmtgr2.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgr6 = "AVLmtgr6.def"

    /// lake
    /// Terrain kind: grass
    case lake_AVLlk2g0 = "AVLlk2g0.def"

    /// crater
    /// Terrain kind: grass
    case crater_AVLct4g0 = "AVLct4g0.def"

    /// mound
    /// Terrain kind: grass
    case mound_AVLmd2g0 = "AVLmd2g0.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLswmp6 = "AVLswmp6.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLswmp1 = "AVLswmp1.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLswmp3 = "AVLswmp3.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLswmp0 = "AVLswmp0.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLswmp5 = "AVLswmp5.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLswmp2 = "AVLswmp2.def"

    /// crater
    /// Terrain kind: grass
    case crater_AVLct2g0 = "AVLct2g0.def"

    /// mountain
    /// Terrain kind: grass
    case mountain_AVLmtgr4 = "AVLmtgr4.def"

    /// lake
    /// Terrain kind: grass
    case lake_AVLlk3g0 = "AVLlk3g0.def"

    /// pineTrees
    /// Terrain kind: dirt, grass
    case pineTrees_AVLpntr6 = "AVLpntr6.def"

    /// pineTrees
    /// Terrain kind: dirt, grass
    case pineTrees_AVLPNTR2 = "AVLPNTR2.def"

    /// oakTrees
    /// Terrain kind: dirt, grass, swamp
    case oakTrees_avlautr0 = "avlautr0.def"

    /// oakTrees
    /// Terrain kind: dirt, grass, swamp
    case oakTrees_AVLAUTR3 = "AVLAUTR3.def"

    /// outcropping
    /// Terrain kind: grass
    case outcropping_AVLoc1g0 = "AVLoc1g0.def"

    /// outcropping
    /// Terrain kind: grass
    case outcropping_AVLoc2g0 = "AVLoc2g0.def"

    /// reef
    /// Terrain kind: Water
    case reef_AVLref20 = "AVLref20.def"

    /// reef
    /// Terrain kind: Water
    case reef_AVLref50 = "AVLref50.def"

    /// reef
    /// Terrain kind: Water
    case reef_AVLref40 = "AVLref40.def"

    /// mountain
    /// Terrain kind: dirt
    case mountain_avlmtdr3 = "avlmtdr3.def"

    /// mountain
    /// Terrain kind: dirt
    case mountain_avlmtdr2 = "avlmtdr2.def"

    /// mountain
    /// Terrain kind: dirt
    case mountain_avlmtdr5 = "avlmtdr5.def"

    /// mountain
    /// Terrain kind: dirt
    case mountain_avlmtdr7 = "avlmtdr7.def"

    /// crater
    /// Terrain kind: dirt
    case crater_AVLct1d0 = "AVLct1d0.def"

    /// crater
    /// Terrain kind: dirt
    case crater_AVLct2d0 = "AVLct2d0.def"

    /// oakTrees
    /// Terrain kind: dirt, grass, swamp
    case oakTrees_AVLAUTR5 = "AVLAUTR5.def"

    /// oakTrees
    /// Terrain kind: dirt, grass, swamp
    case oakTrees_AVLautr7 = "AVLautr7.def"

    /// rock
    /// Terrain kind: dirt
    case rock_AvLRD01 = "AvLRD01.def"

    /// rock
    /// Terrain kind: dirt
    case rock_AvLRD02 = "AvLRD02.def"

    /// mountain
    /// Terrain kind: dirt
    case mountain_avlmtdr6 = "avlmtdr6.def"

    /// mountain
    /// Terrain kind: dirt
    case mountain_avlmtdr8 = "avlmtdr8.def"

    /// outcropping
    /// Terrain kind: dirt
    case outcropping_AVLoc3d0 = "AVLoc3d0.def"

    /// crater
    /// Terrain kind: dirt
    case crater_AVLct4d0 = "AVLct4d0.def"

    /// crater
    /// Terrain kind: dirt
    case crater_AVLct3d0 = "AVLct3d0.def"

    /// oakTrees
    /// Terrain kind: dirt, grass, swamp
    case oakTrees_AVLAUTR2 = "AVLAUTR2.def"

    /// mountain
    /// Terrain kind: dirt
    case mountain_avlmtdr4 = "avlmtdr4.def"

    /// lake
    /// Terrain kind: dirt
    case lake_AVLlk1d0 = "AVLlk1d0.def"

    /// mountain
    /// Terrain kind: snow
    case mountain_AVLmtsn4 = "AVLmtsn4.def"

    /// mountain
    /// Terrain kind: snow
    case mountain_AVLmtsn6 = "AVLmtsn6.def"

    /// outcropping
    /// Terrain kind: snow
    case outcropping_AVLo1sn0 = "AVLo1sn0.def"

    /// mountain
    /// Terrain kind: snow
    case mountain_AVLmtsn5 = "AVLmtsn5.def"

    /// mountain
    /// Terrain kind: snow
    case mountain_AVLmtsn3 = "AVLmtsn3.def"

    /// outcropping
    /// Terrain kind: snow
    case outcropping_AVLo3sn0 = "AVLo3sn0.def"

    /// rock
    /// Terrain kind: snow
    case rock_AVLr2sn0 = "AVLr2sn0.def"

    /// hole
    /// Terrain kind: snow
    case hole_AVLhlsn0 = "AVLhlsn0.def"

    /// pineTrees
    /// Terrain kind: snow
    case pineTrees_AVLsntr7 = "AVLsntr7.def"

    /// pineTrees
    /// Terrain kind: snow
    case pineTrees_AVLSNTR2 = "AVLSNTR2.def"

    /// pineTrees
    /// Terrain kind: snow
    case pineTrees_AVLSNTR3 = "AVLSNTR3.def"

    /// mountain
    /// Terrain kind: snow
    case mountain_AVLmtsn2 = "AVLmtsn2.def"

    /// pineTrees
    /// Terrain kind: snow
    case pineTrees_AVLSNTR4 = "AVLSNTR4.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLddsn7 = "AVLddsn7.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLddsn6 = "AVLddsn6.def"

    /// pineTrees
    /// Terrain kind: snow
    case pineTrees_AVLSNTR1 = "AVLSNTR1.def"

    /// pineTrees
    /// Terrain kind: snow
    case pineTrees_AVLSNTR0 = "AVLSNTR0.def"

    /// lake
    /// Terrain kind: snow
    case lake_AVLflk20 = "AVLflk20.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLddsn5 = "AVLddsn5.def"

    /// leanTo
    /// Terrain kind: snow
    case leanTo_AVMlean0 = "AVMlean0.def"

    /// rock
    /// Terrain kind: snow
    case rock_AVLr1sn0 = "AVLr1sn0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLddsn3 = "AVLddsn3.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLd7sn0 = "AVLd7sn0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLd9sn0 = "AVLd9sn0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLd8sn0 = "AVLd8sn0.def"

    /// mountain
    /// Terrain kind: snow
    case mountain_AVLmtsn1 = "AVLmtsn1.def"

    /// lake
    /// Terrain kind: snow
    case lake_AVLflk10 = "AVLflk10.def"

    /// outcropping
    /// Terrain kind: snow
    case outcropping_AVLo2sn0 = "AVLo2sn0.def"

    /// rock
    /// Terrain kind: snow
    case rock_AVLr6sn0 = "AVLr6sn0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLddsn2 = "AVLddsn2.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLddsn4 = "AVLddsn4.def"

    /// pineTrees
    /// Terrain kind: snow
    case pineTrees_AVLSNTR5 = "AVLSNTR5.def"

    /// mound
    /// Terrain kind: dirt
    case mound_AVLmd1d0 = "AVLmd1d0.def"

    /// mound
    /// Terrain kind: dirt
    case mound_AVLmd2d0 = "AVLmd2d0.def"

    /// lake
    /// Terrain kind: dirt
    case lake_AVLlk3d0 = "AVLlk3d0.def"

    /// flowers
    /// Terrain kind: dirt
    case flowers_AVLfl8d0 = "AVLfl8d0.def"

    /// flowers
    /// Terrain kind: dirt
    case flowers_AVLfl5d0 = "AVLfl5d0.def"

    /// flowers
    /// Terrain kind: dirt
    case flowers_AVLfl7d0 = "AVLfl7d0.def"

    /// pineTrees
    /// Terrain kind: snow
    case pineTrees_AVLsntr6 = "AVLsntr6.def"

    /// reef
    /// Terrain kind: Water
    case reef_AVLref30 = "AVLref30.def"

    /// reef
    /// Terrain kind: Water
    case reef_AVLref60 = "AVLref60.def"

    /// reef
    /// Terrain kind: Water
    case reef_AVLref10 = "AVLref10.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLc11l0 = "AVLc11l0.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLct3l0 = "AVLct3l0.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlav30 = "AVLlav30.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLct1l0 = "AVLct1l0.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLct5l0 = "AVLct5l0.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLc14l0 = "AVLc14l0.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLc13l0 = "AVLc13l0.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLct7l0 = "AVLct7l0.def"

    /// deadVegetation
    /// Terrain kind: swamp, subterranean, lava
    case deadVegetation_AVLdead7 = "AVLdead7.def"

    /// deadVegetation
    /// Terrain kind: swamp, subterranean, lava
    case deadVegetation_AVLdead5 = "AVLdead5.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlav20 = "AVLlav20.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLct4l0 = "AVLct4l0.def"

    /// deadVegetation
    /// Terrain kind: swamp, subterranean, lava
    case deadVegetation_AVLdead2 = "AVLdead2.def"

    /// mountain
    /// Terrain kind: lava
    case mountain_AVLmtvo1 = "AVLmtvo1.def"

    /// volcano
    /// Terrain kind: lava
    case volcano_AVLvol10 = "AVLvol10.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv120 = "AVLlv120.def"

    /// mountain
    /// Terrain kind: lava
    case mountain_AVLmtvo4 = "AVLmtvo4.def"

    /// volcano
    /// Terrain kind: lava
    case volcano_AVLvol20 = "AVLvol20.def"

    /// volcano
    /// Terrain kind: lava
    case volcano_AVLvol40 = "AVLvol40.def"

    /// mountain
    /// Terrain kind: lava
    case mountain_AVLmtvo5 = "AVLmtvo5.def"

    /// volcano
    /// Terrain kind: lava
    case volcano_AVLvol50 = "AVLvol50.def"

    /// mountain
    /// Terrain kind: lava
    case mountain_AVLmtvo6 = "AVLmtvo6.def"

    /// mountain
    /// Terrain kind: lava
    case mountain_AVLmtvo3 = "AVLmtvo3.def"

    /// mountain
    /// Terrain kind: lava
    case mountain_AVLmtvo2 = "AVLmtvo2.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlav40 = "AVLlav40.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlav70 = "AVLlav70.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlav90 = "AVLlav90.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlav80 = "AVLlav80.def"

    /// deadVegetation
    /// Terrain kind: swamp, subterranean, lava
    case deadVegetation_AVLdead4 = "AVLdead4.def"

    /// deadVegetation
    /// Terrain kind: swamp, subterranean, lava
    case deadVegetation_AVLdead3 = "AVLdead3.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlav60 = "AVLlav60.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLct9l0 = "AVLct9l0.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLc10l0 = "AVLc10l0.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLct8l0 = "AVLct8l0.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlav50 = "AVLlav50.def"

    /// volcano
    /// Terrain kind: lava
    case volcano_AVLvol30 = "AVLvol30.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv260 = "AVLlv260.def"

    /// deadVegetation
    /// Terrain kind: swamp, subterranean, lava
    case deadVegetation_AVLdead0 = "AVLdead0.def"

    /// deadVegetation
    /// Terrain kind: swamp, subterranean, lava
    case deadVegetation_AVLdead6 = "AVLdead6.def"

    /// crater
    /// Terrain kind: dirt
    case crater_AVLct5d0 = "AVLct5d0.def"

    /// mountain
    /// Terrain kind: sand
    case mountain_AVLmtds2 = "AVLmtds2.def"

    /// mountain
    /// Terrain kind: sand
    case mountain_AVLmtds4 = "AVLmtds4.def"

    /// mountain
    /// Terrain kind: sand
    case mountain_AVLmtds5 = "AVLmtds5.def"

    /// hole
    /// Terrain kind: sand
    case hole_AVLhlds0 = "AVLhlds0.def"

    /// crater
    /// Terrain kind: sand
    case crater_AVLctds0 = "AVLctds0.def"

    /// trees
    /// Terrain kind: sand
    case trees_AVLplm20 = "AVLplm20.def"

    /// trees
    /// Terrain kind: sand
    case trees_AVLplm30 = "AVLplm30.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca100 = "AVLca100.def"

    /// sandPit
    /// Terrain kind: sand
    case sandPit_AVLspit0 = "AVLspit0.def"

    /// trees
    /// Terrain kind: sand
    case trees_AVLplm40 = "AVLplm40.def"

    /// mountain
    /// Terrain kind: sand
    case mountain_AVLmtds6 = "AVLmtds6.def"

    /// sandDune
    /// Terrain kind: sand
    case sandDune_AVLdun10 = "AVLdun10.def"

    /// sandDune
    /// Terrain kind: sand
    case sandDune_AVLdun30 = "AVLdun30.def"

    /// sandDune
    /// Terrain kind: sand
    case sandDune_AVLdun20 = "AVLdun20.def"

    /// trees
    /// Terrain kind: sand
    case trees_AVLplm10 = "AVLplm10.def"

    /// mountain
    /// Terrain kind: sand
    case mountain_AVLmtds1 = "AVLmtds1.def"

    /// trees
    /// Terrain kind: sand
    case trees_AVLplm50 = "AVLplm50.def"

    /// mountain
    /// Terrain kind: dirt
    case mountain_avlmtdr1 = "avlmtdr1.def"

    /// pineTrees
    /// Terrain kind: dirt, grass
    case pineTrees_AVLpntr7 = "AVLpntr7.def"

    /// lake
    /// Terrain kind: dirt
    case lake_AVLlk2d0 = "AVLlk2d0.def"

    /// flowers
    /// Terrain kind: dirt
    case flowers_AVLfl3d0 = "AVLfl3d0.def"

    /// trees
    /// Terrain kind: dirt, grass, swamp
    case trees_AVLtr2d0 = "AVLtr2d0.def"

    /// shrub
    /// Terrain kind: dirt
    case shrub_AVLsh4d0 = "AVLsh4d0.def"

    /// flowers
    /// Terrain kind: dirt
    case flowers_AVLfl4d0 = "AVLfl4d0.def"

    /// crater
    /// Terrain kind: rough
    case crater_AVLct9r0 = "AVLct9r0.def"

    /// canyon
    /// Terrain kind: rough
    case canyon_AVLglly0 = "AVLglly0.def"

    /// crater
    /// Terrain kind: rough
    case crater_AVLct4r0 = "AVLct4r0.def"

    /// crater
    /// Terrain kind: rough
    case crater_AVLct5r0 = "AVLct5r0.def"

    /// outcropping
    /// Terrain kind: rough
    case outcropping_AVLoc1r0 = "AVLoc1r0.def"

    /// outcropping
    /// Terrain kind: rough
    case outcropping_AVLoc2r0 = "AVLoc2r0.def"

    /// outcropping
    /// Terrain kind: rough
    case outcropping_AVLoc3r0 = "AVLoc3r0.def"

    /// outcropping
    /// Terrain kind: rough
    case outcropping_AVLoc4r0 = "AVLoc4r0.def"

    /// mountain
    /// Terrain kind: rough
    case mountain_avlmtrf1 = "avlmtrf1.def"

    /// mountain
    /// Terrain kind: rough
    case mountain_avlmtrf2 = "avlmtrf2.def"

    /// mountain
    /// Terrain kind: rough
    case mountain_avlmtrf4 = "avlmtrf4.def"

    /// mountain
    /// Terrain kind: rough
    case mountain_avlmtrf6 = "avlmtrf6.def"

    /// crater
    /// Terrain kind: rough
    case crater_AVLct6r0 = "AVLct6r0.def"

    /// crater
    /// Terrain kind: rough
    case crater_AVLct8r0 = "AVLct8r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_avlbuzr0 = "avlbuzr0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr02r0 = "AVLr02r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr08r0 = "AVLr08r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr07r0 = "AVLr07r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr06r0 = "AVLr06r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr12r0 = "AVLr12r0.def"

    /// mountain
    /// Terrain kind: rough
    case mountain_avlmtrf5 = "avlmtrf5.def"

    /// mountain
    /// Terrain kind: rough
    case mountain_avlmtrf3 = "avlmtrf3.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr03r0 = "AVLr03r0.def"

    /// trees
    /// Terrain kind: rough
    case trees_AVLr04r0 = "AVLr04r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr10r0 = "AVLr10r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr14r0 = "AVLr14r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr15r0 = "AVLr15r0.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_AVLsh3r0 = "AVLsh3r0.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_avlsh4r0 = "avlsh4r0.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_avlsh2r0 = "avlsh2r0.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_avlsh6r0 = "avlsh6r0.def"

    /// deadVegetation
    /// Terrain kind: swamp
    case deadVegetation_AVLdt3s0 = "AVLdt3s0.def"

    /// deadVegetation
    /// Terrain kind: swamp
    case deadVegetation_AVLdt1s0 = "AVLdt1s0.def"

    /// mountain
    /// Terrain kind: swamp
    case mountain_AVLmtsw4 = "AVLmtsw4.def"

    /// mountain
    /// Terrain kind: swamp
    case mountain_AVLmtsw3 = "AVLmtsw3.def"

    /// mountain
    /// Terrain kind: swamp
    case mountain_AVLmtsw5 = "AVLmtsw5.def"

    /// mountain
    /// Terrain kind: swamp
    case mountain_AVLmtsw6 = "AVLmtsw6.def"

    /// rock
    /// Terrain kind: swamp
    case rock_AVLrk3s0 = "AVLrk3s0.def"

    /// rock
    /// Terrain kind: swamp
    case rock_AVLrk4s0 = "AVLrk4s0.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs06s0 = "AVLs06s0.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs09s0 = "AVLs09s0.def"

    /// mountain
    /// Terrain kind: swamp
    case mountain_AVLmtsw1 = "AVLmtsw1.def"

    /// mandrake
    /// Terrain kind: swamp
    case mandrake_AVLman40 = "AVLman40.def"

    /// mountain
    /// Terrain kind: swamp
    case mountain_AVLmtsw2 = "AVLmtsw2.def"

    /// lake
    /// Terrain kind: swamp
    case lake_AVLlk3s0 = "AVLlk3s0.def"

    /// lake
    /// Terrain kind: swamp
    case lake_AVLlk1s0 = "AVLlk1s0.def"

    /// deadVegetation
    /// Terrain kind: swamp
    case deadVegetation_AVLdt2s0 = "AVLdt2s0.def"

    /// oakTrees
    /// Terrain kind: grass, swamp
    case oakTrees_AVLSPTR4 = "AVLSPTR4.def"

    /// oakTrees
    /// Terrain kind: grass, swamp
    case oakTrees_AVLsptr7 = "AVLsptr7.def"

    /// oakTrees
    /// Terrain kind: grass, swamp
    case oakTrees_AVLSPTR6 = "AVLSPTR6.def"

    /// oakTrees
    /// Terrain kind: grass, swamp
    case oakTrees_AVLSPTR5 = "AVLSPTR5.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLswmp7 = "AVLswmp7.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLswp10 = "AVLswp10.def"

    /// rock
    /// Terrain kind: swamp
    case rock_AVLrk1s0 = "AVLrk1s0.def"

    /// rock
    /// Terrain kind: swamp
    case rock_AVLrk2s0 = "AVLrk2s0.def"

    /// skull
    /// Terrain kind: sand, rough
    case skull_AVLskul0 = "AVLskul0.def"

    /// log
    /// Terrain kind: dirt, grass, rough
    case log_AvLdlog = "AvLdlog.def"

    /// mound
    /// Terrain kind: rough
    case mound_AVLmd1r0 = "AVLmd1r0.def"

    /// stump
    /// Terrain kind: dirt, grass, rough
    case stump_AvLStm3 = "AvLStm3.def"

    /// stump
    /// Terrain kind: dirt, grass, rough
    case stump_AvLStm2 = "AvLStm2.def"

    /// stump
    /// Terrain kind: dirt, grass, rough
    case stump_AvLStm1 = "AvLStm1.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr09r0 = "AVLr09r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr11r0 = "AVLr11r0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLddsn1 = "AVLddsn1.def"

    /// shrub
    /// Terrain kind: snow
    case shrub_AVLs3sn0 = "AVLs3sn0.def"

    /// shrub
    /// Terrain kind: snow
    case shrub_AVLs1sn0 = "AVLs1sn0.def"

    /// shrub
    /// Terrain kind: snow
    case shrub_AVLs2sn0 = "AVLs2sn0.def"

    /// rock
    /// Terrain kind: snow
    case rock_AVLr7sn0 = "AVLr7sn0.def"

    /// rock
    /// Terrain kind: snow
    case rock_AVLr8sn0 = "AVLr8sn0.def"

    /// rock
    /// Terrain kind: snow
    case rock_AVLr3sn0 = "AVLr3sn0.def"

    /// lake
    /// Terrain kind: snow
    case lake_AVLflk30 = "AVLflk30.def"

    /// rock
    /// Terrain kind: snow
    case rock_AVLr4sn0 = "AVLr4sn0.def"

    /// stump
    /// Terrain kind: snow
    case stump_AVLp2sn0 = "AVLp2sn0.def"

    /// stump
    /// Terrain kind: snow
    case stump_AVLp1sn0 = "AVLp1sn0.def"

    /// crater
    /// Terrain kind: snow
    case crater_AVLctsn0 = "AVLctsn0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLddsn0 = "AVLddsn0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLd3sn0 = "AVLd3sn0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLd4sn0 = "AVLd4sn0.def"

    /// magicWell
    /// Terrain kind: snow
    case magicWell_AVXwlsn0 = "AVXwlsn0.def"

    /// mine - gemPond
    /// Terrain kind: snow
    case gemPond_AVMgesn0 = "AVMgesn0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLd5sn0 = "AVLd5sn0.def"

    /// mine - goldMine
    /// Terrain kind: snow
    case goldMine_AVMgosn0 = "AVMgosn0.def"

    /// mine - orePit
    /// Terrain kind: snow
    case orePit_AVMorsn0 = "AVMorsn0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLd6sn0 = "AVLd6sn0.def"

    /// mine - sawmill
    /// Terrain kind: snow
    case sawmill_AVMswsn0 = "AVMswsn0.def"

    /// mine - sulfurDune
    /// Terrain kind: snow, swamp, rough
    case sulfurDune_AVMsulf0 = "AVMsulf0.def"

    /// sign
    /// Terrain kind: snow
    case sign_AVXsnsn0 = "AVXsnsn0.def"

    /// learningStone
    /// Terrain kind: Land
    case learningStone_AVSgzbo0 = "AVSgzbo0.def"

    /// event
    case event_AVZevnt0 = "AVZevnt0.def"

    /// campfire
    /// Terrain kind: snow
    case campfire_AVXcfsn0 = "AVXcfsn0.def"

    /// town - tower
    /// Terrain kind: Land
    case townTower_AVCtowr0 = "AVCtowr0.def"

    /// deadVegetation
    /// Terrain kind: snow
    case deadVegetation_AVLd2sn0 = "AVLd2sn0.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf12g0 = "AVLf12g0.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf01g0 = "AVLf01g0.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf02g0 = "AVLf02g0.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLwlw20 = "AVLwlw20.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLwlw10 = "AVLwlw10.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLwlw30 = "AVLwlw30.def"

    /// mine - gemPond
    /// Terrain kind: grass, swamp
    case gemPond_AVMgems0 = "AVMgems0.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf05g0 = "AVLf05g0.def"

    /// mound
    /// Terrain kind: grass
    case mound_AVLmd1g0 = "AVLmd1g0.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf03g0 = "AVLf03g0.def"

    /// trees
    /// Terrain kind: dirt, grass, swamp
    case trees_AVLtr3d0 = "AVLtr3d0.def"

    /// mine - goldMine
    /// Terrain kind: grass
    case goldMine_AVMgold0 = "AVMgold0.def"

    /// mine - abandonedMine
    /// Terrain kind: grass
    case abandonedMine_AvMAbMG = "AvMAbMG.def"

    /// mine - sawmill
    /// Terrain kind: grass, swamp
    case sawmill_AVMsawg0 = "AVMsawg0.def"

    /// mine - orePit
    /// Terrain kind: grass
    case orePit_AVMore0 = "AVMore0.def"

    /// arena
    /// Terrain kind: dirt, grass
    case arena_AVSarna0 = "AVSarna0.def"

    /// waterWheel
    /// Terrain kind: dirt, grass, swamp
    case waterWheel_AVMwwhl0 = "AVMwwhl0.def"

    /// trees
    /// Terrain kind: dirt, grass, swamp
    case trees_AVLtr1d0 = "AVLtr1d0.def"

    /// fountainOfFortune
    /// Terrain kind: dirt, grass, swamp
    case fountainOfFortune_AVSfntn0 = "AVSfntn0.def"

    /// fountainOfYouth
    /// Terrain kind: dirt, grass, swamp
    case fountainOfYouth_AVXfyth0 = "AVXfyth0.def"

    /// faerieRing
    /// Terrain kind: dirt, grass, swamp
    case faerieRing_AVSring0 = "AVSring0.def"

    /// crypt
    /// Terrain kind: dirt, grass, swamp
    case crypt_AVXgyne0 = "AVXgyne0.def"

    /// oakTrees
    /// Terrain kind: grass, swamp
    case oakTrees_AVLSPTR2 = "AVLSPTR2.def"

    /// oakTrees
    /// Terrain kind: grass, swamp
    case oakTrees_AVLSPTR0 = "AVLSPTR0.def"

    /// shrub
    /// Terrain kind: grass
    case shrub_AVLsh6g0 = "AVLsh6g0.def"

    /// tradingPost
    /// Terrain kind: dirt, grass
    case tradingPost_AVXpost0 = "AVXpost0.def"

    /// stables
    /// Terrain kind: dirt, grass, rough
    case stables_AVXstbl0 = "AVXstbl0.def"

    /// oakTrees
    /// Terrain kind: grass, swamp
    case oakTrees_AVLSPTR3 = "AVLSPTR3.def"

    /// oakTrees
    /// Terrain kind: grass, swamp
    case oakTrees_AVLSPTR1 = "AVLSPTR1.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG08 = "AvLRG08.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG02 = "AvLRG02.def"

    /// shrub
    /// Terrain kind: grass
    case shrub_AVLsh3g0 = "AVLsh3g0.def"

    /// town - inferno
    /// Terrain kind: Land
    case townInferno_AVCinft0 = "AVCinft0.def"

    /// mine - alchemistsLab
    /// Terrain kind: lava
    case alchemistsLab_AVMalch0 = "AVMalch0.def"

    /// mine - gemPond
    /// Terrain kind: lava
    case gemPond_AVMgelv0 = "AVMgelv0.def"

    /// mine - sawmill
    /// Terrain kind: subterranean, lava
    case sawmill_AVMsawl0 = "AVMsawl0.def"

    /// sign
    /// Terrain kind: lava
    case sign_AVXsnlv0 = "AVXsnlv0.def"

    /// obelisk
    /// Terrain kind: lava
    case obelisk_AvXOblY = "AvXOblY.def"

    /// campfire
    /// Terrain kind: Land
    case campfire_adcfra = "adcfra.def"

    /// schoolOfWar
    /// Terrain kind: Land
    case schoolOfWar_AVSwar20 = "AVSwar20.def"

    /// rock
    /// Terrain kind: dirt
    case rock_AVLrk3d0 = "AVLrk3d0.def"

    /// rock
    /// Terrain kind: dirt
    case rock_AVLrk5d0 = "AVLrk5d0.def"

    /// mountain
    /// Terrain kind: sand
    case mountain_AVLmtds3 = "AVLmtds3.def"

    /// deadVegetation
    /// Terrain kind: swamp, subterranean, lava
    case deadVegetation_AVLdead1 = "AVLdead1.def"

    /// shrub
    /// Terrain kind: dirt
    case shrub_AVLsh2d0 = "AVLsh2d0.def"

    /// shrub
    /// Terrain kind: dirt
    case shrub_AVLsh5d0 = "AVLsh5d0.def"

    /// outcropping
    /// Terrain kind: dirt
    case outcropping_AVLoc1d0 = "AVLoc1d0.def"

    /// mine - orePit
    /// Terrain kind: sand
    case orePit_AVMords0 = "AVMords0.def"

    /// mine - sawmill
    /// Terrain kind: sand
    case sawmill_AVMswds0 = "AVMswds0.def"

    /// trees
    /// Terrain kind: sand, rough
    case trees_AVLyuc20 = "AVLyuc20.def"

    /// trees
    /// Terrain kind: sand, rough
    case trees_AVLyuc10 = "AVLyuc10.def"

    /// obelisk
    /// Terrain kind: sand, subterranean
    case obelisk_AvXOblK = "AvXOblK.def"

    /// pyramid
    /// Terrain kind: sand
    case pyramid_AVXprmd0 = "AVXprmd0.def"

    /// corpse
    /// Terrain kind: sand, rough
    case corpse_AVXskds0 = "AVXskds0.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca120 = "AVLca120.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca130 = "AVLca130.def"

    /// idolOfFortune
    /// Terrain kind: Land
    case idolOfFortune_AVSidol0 = "AVSidol0.def"

    /// schoolOfMagic
    /// Terrain kind: Land
    case schoolOfMagic_AVSschm0 = "AVSschm0.def"

    /// mine - abandonedMine
    /// Terrain kind: dirt
    case abandonedMine_AVXabnd0 = "AVXabnd0.def"

    /// mine - sawmill
    /// Terrain kind: dirt
    case sawmill_AVMsawd0 = "AVMsawd0.def"

    /// mine - goldMine
    /// Terrain kind: dirt
    case goldMine_AVMgodr0 = "AVMgodr0.def"

    /// mine - gemPond
    /// Terrain kind: dirt
    case gemPond_AVMgedr0 = "AVMgedr0.def"

    /// obelisk
    /// Terrain kind: dirt
    case obelisk_AvXOblG = "AvXOblG.def"

    /// hillFort
    /// Terrain kind: dirt
    case hillFort_AVXhild0 = "AVXhild0.def"

    /// magicWell
    /// Terrain kind: dirt, grass, swamp
    case magicWell_AVXwelg0 = "AVXwelg0.def"

    /// shrub
    /// Terrain kind: dirt
    case shrub_AVLsh3d0 = "AVLsh3d0.def"

    /// shrub
    /// Terrain kind: dirt
    case shrub_AVLsh6d0 = "AVLsh6d0.def"

    /// mysticalGarden
    /// Terrain kind: dirt, grass, swamp
    case mysticalGarden_AVTmyst0 = "AVTmyst0.def"

    /// shrub
    /// Terrain kind: dirt
    case shrub_AVLsh7d0 = "AVLsh7d0.def"

    /// shrub
    /// Terrain kind: dirt
    case shrub_AVLsh8d0 = "AVLsh8d0.def"

    /// creatureGenerator1 - goblinBarracks
    /// Terrain kind: Land
    case goblinBarracks_AVGgobl0 = "AVGgobl0.def"

    /// outcropping
    /// Terrain kind: dirt
    case outcropping_AVLoc2d0 = "AVLoc2d0.def"

    /// flowers
    /// Terrain kind: dirt
    case flowers_AVLfl9d0 = "AVLfl9d0.def"

    /// scholar
    /// Terrain kind: Land
    case scholar_AVXschl0 = "AVXschl0.def"

    /// crater
    /// Terrain kind: dirt
    case crater_AVLctrd0 = "AVLctrd0.def"

    /// flowers
    /// Terrain kind: dirt
    case flowers_AVLfl2d0 = "AVLfl2d0.def"

    /// trees
    /// Terrain kind: grass, swamp
    case trees_AVLswmp4 = "AVLswmp4.def"

    /// lake
    /// Terrain kind: grass
    case lake_AVLlk1g0 = "AVLlk1g0.def"

    /// creatureGenerator1 - guardhouse
    /// Terrain kind: Land
    case guardhouse_AVGpike0 = "AVGpike0.def"

    /// resource - wood
    /// Terrain kind: dirt
    case resourceWood_AVTwood0 = "AVTwood0.def"

    /// resource - ore
    /// Terrain kind: dirt
    case resourceOre_AVTore0 = "AVTore0.def"

    /// resource - gold
    /// Terrain kind: dirt
    case resourceGold_AVTgold0 = "AVTgold0.def"

    /// resource - sulfur
    /// Terrain kind: dirt
    case resourceSulfur_AVTsulf0 = "AVTsulf0.def"

    /// resource - mercury
    /// Terrain kind: dirt
    case resourceMercury_AVTmerc0 = "AVTmerc0.def"

    /// treasureChest
    /// Terrain kind: Land
    case treasureChest_AVTchst0 = "AVTchst0.def"

    /// mine - orePit
    /// Terrain kind: dirt
    case orePit_AVMordr0 = "AVMordr0.def"

    /// randomResource
    /// Terrain kind: dirt
    case randomResource_AVTrndm0 = "AVTrndm0.def"

    /// resource - gems
    /// Terrain kind: Land
    case resourceGems_AVTgems0 = "AVTgems0.def"

    /// resource - crystal
    /// Terrain kind: dirt
    case resourceCrystal_AVTcrys0 = "AVTcrys0.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca110 = "AVLca110.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf11g0 = "AVLf11g0.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf09g0 = "AVLf09g0.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG11 = "AvLRG11.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG05 = "AvLRG05.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG01 = "AvLRG01.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG06 = "AvLRG06.def"

    /// flowers
    /// Terrain kind: dirt
    case flowers_AVLfl6d0 = "AVLfl6d0.def"

    /// monster - grandElf
    /// Terrain kind: dirt
    case grandElf_AVWelfx0 = "AVWelfx0.def"

    /// town - fortress
    /// Terrain kind: Land
    case townFortress_AVCftrt0 = "AVCftrt0.def"

    /// whirlpool
    /// Terrain kind: Water
    case whirlpool_AVXwhrl0 = "AVXwhrl0.def"

    /// seaChest
    /// Terrain kind: Water
    case seaChest_AVXccht0 = "AVXccht0.def"

    /// flotsam
    /// Terrain kind: Water
    case flotsam_AVAflot0 = "AVAflot0.def"

    /// shipwreckSurvivor
    /// Terrain kind: Water
    case shipwreckSurvivor_AVAsurv0 = "AVAsurv0.def"

    /// rock
    /// Terrain kind: Water
    case rock_AVLrk1w0 = "AVLrk1w0.def"

    /// buoy
    /// Terrain kind: Water
    case buoy_AVSbuoy0 = "AVSbuoy0.def"

    /// oceanBottle
    /// Terrain kind: Water
    case oceanBottle_AVXbttl0 = "AVXbttl0.def"

    /// derelictShip
    /// Terrain kind: Water
    case derelictShip_AVAdlic0 = "AVAdlic0.def"

    /// kelp
    /// Terrain kind: Water
    case kelp_AVLklp20 = "AVLklp20.def"

    /// kelp
    /// Terrain kind: Water
    case kelp_AVLklp10 = "AVLklp10.def"

    /// mermaid
    /// Terrain kind: Water
    case mermaid_AVXmerm0 = "AVXmerm0.def"

    /// sirens
    /// Terrain kind: Water
    case sirens_AVXsirn0 = "AVXsirn0.def"

    /// rock
    /// Terrain kind: Water
    case rock_AVLrk2w0 = "AVLrk2w0.def"

    /// rock
    /// Terrain kind: Water
    case rock_AVLrk3w0 = "AVLrk3w0.def"

    /// rock
    /// Terrain kind: Water
    case rock_AVLrk4w0 = "AVLrk4w0.def"

    /// lake
    /// Terrain kind: swamp
    case lake_AVLswp50 = "AVLswp50.def"

    /// deadVegetation
    /// Terrain kind: swamp
    case deadVegetation_AVLswp60 = "AVLswp60.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs01s0 = "AVLs01s0.def"

    /// mine - goldMine
    /// Terrain kind: swamp
    case goldMine_AVMgosw0 = "AVMgosw0.def"

    /// mine - orePit
    /// Terrain kind: swamp
    case orePit_AVMorsw0 = "AVMorsw0.def"

    /// obelisk
    /// Terrain kind: swamp
    case obelisk_AvXOblB = "AvXOblB.def"

    /// swanPond
    /// Terrain kind: swamp
    case swanPond_AVSclvs0 = "AVSclvs0.def"

    /// mine - goldMine
    /// Terrain kind: sand
    case goldMine_AVMgods0 = "AVMgods0.def"

    /// crypt
    /// Terrain kind: sand
    case crypt_AVXgyds0 = "AVXgyds0.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLswp40 = "AVLswp40.def"

    /// monster - pikeman
    /// Terrain kind: grass
    case pikeman_AvWPike = "AvWPike.def"

    /// monster - imp
    /// Terrain kind: dirt
    case imp_AVWimp0 = "AVWimp0.def"

    /// monster - gnollMarauder
    /// Terrain kind: dirt
    case gnollMarauder_AVWgnlx0 = "AVWgnlx0.def"

    /// mine - sawmill
    /// Terrain kind: rough
    case sawmill_AVMsawr0 = "AVMsawr0.def"

    /// mine - orePit
    /// Terrain kind: rough
    case orePit_AVMorro0 = "AVMorro0.def"

    /// obelisk
    /// Terrain kind: rough
    case obelisk_AvXOblO = "AvXOblO.def"

    /// tradingPost
    /// Terrain kind: rough
    case tradingPost_AVXpstr0 = "AVXpstr0.def"

    /// wateringHole
    /// Terrain kind: rough
    case wateringHole_AVXwtrh0 = "AVXwtrh0.def"

    /// wagon
    /// Terrain kind: rough
    case wagon_AVTwagn0 = "AVTwagn0.def"

    /// trees
    /// Terrain kind: rough
    case trees_AVLroug1 = "AVLroug1.def"

    /// trees
    /// Terrain kind: rough
    case trees_AVLroug0 = "AVLroug0.def"

    /// trees
    /// Terrain kind: rough
    case trees_AVLroug2 = "AVLroug2.def"

    /// town - stronghold
    /// Terrain kind: Land
    case townStronghold_AVCstro0 = "AVCstro0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AvLRR05 = "AvLRR05.def"

    /// crater
    /// Terrain kind: rough
    case crater_AVLct2r0 = "AVLct2r0.def"

    /// mound
    /// Terrain kind: rough
    case mound_AVLmd3r0 = "AVLmd3r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AVLr13r0 = "AVLr13r0.def"

    /// magicSpring
    /// Terrain kind: rough
    case magicSpring_AVXmags0 = "AVXmags0.def"

    /// cactus
    /// Terrain kind: rough
    case cactus_AVLca2r0 = "AVLca2r0.def"

    /// cactus
    /// Terrain kind: rough
    case cactus_AVLca1r0 = "AVLca1r0.def"

    /// rock
    /// Terrain kind: rough
    case rock_AvLRR01 = "AvLRR01.def"

    /// monster - lizardman
    /// Terrain kind: grass
    case lizardman_AvWLizr = "AvWLizr.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLswp20 = "AVLswp20.def"

    /// monster - medusa
    /// Terrain kind: grass
    case medusa_AvWMeds = "AvWMeds.def"

    /// deadVegetation
    /// Terrain kind: swamp
    case deadVegetation_AVLswp70 = "AVLswp70.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs03s0 = "AVLs03s0.def"

    /// hillFort
    /// Terrain kind: grass
    case hillFort_AVXhilg0 = "AVXhilg0.def"

    /// monolithOneWayEntrance - blue
    /// Terrain kind: Land
    case monolithOneWayEntranceBlue_AVXmn1b0 = "AVXmn1b0.def"

    /// monolithTwoWay - greenLighting
    /// Terrain kind: Land
    case monolithTwoWayGreenLighting_AVXmn2g0 = "AVXmn2g0.def"

    /// monster - harpyHag
    /// Terrain kind: dirt
    case harpyHag_AVWharx0 = "AVWharx0.def"

    /// subterraneanGate
    /// Terrain kind: Land
    case subterraneanGate_AvTCave = "AvTCave.def"

    /// town - castle
    /// Terrain kind: Land
    case townCastle_AVCcast0 = "AVCcast0.def"

    /// randomMonsterLevel1
    /// Terrain kind: dirt
    case randomMonsterLevel1_AVWmon1 = "AVWmon1.def"

    /// randomMonsterLevel3
    /// Terrain kind: dirt
    case randomMonsterLevel3_AVWmon3 = "AVWmon3.def"

    /// randomMonsterLevel2
    /// Terrain kind: dirt
    case randomMonsterLevel2_AVWmon2 = "AVWmon2.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG04 = "AvLRG04.def"

    /// spellScroll - summonBoat
    /// Terrain kind: dirt
    case spellScrollSummonBoat_AVA0001 = "AVA0001.def"

    /// temple
    /// Terrain kind: Land
    case temple_AVStmpl0 = "AVStmpl0.def"

    /// shrub
    /// Terrain kind: grass
    case shrub_AVLsh2g0 = "AVLsh2g0.def"

    /// artifact - centaurAxe
    /// Terrain kind: dirt
    case centaurAxe_AVA0007 = "AVA0007.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG03 = "AvLRG03.def"

    /// swanPond
    /// Terrain kind: grass
    case swanPond_AVSclvg0 = "AVSclvg0.def"

    /// town - rampart
    /// Terrain kind: Land
    case townRampart_AVCramp0 = "AVCramp0.def"

    /// mine - crystalCavern
    /// Terrain kind: snow
    case crystalCavern_AVMcrsn0 = "AVMcrsn0.def"

    /// shipwreck
    /// Terrain kind: Water
    case shipwreck_AVAwrek0 = "AVAwrek0.def"

    /// mercenaryCamp
    /// Terrain kind: Land
    case mercenaryCamp_AVSmerc0 = "AVSmerc0.def"

    /// starAxis
    /// Terrain kind: Land
    case starAxis_AVSaxis0 = "AVSaxis0.def"

    /// gardenOfRevelation
    /// Terrain kind: dirt, grass, swamp, subterranean
    case gardenOfRevelation_AVSgrdn0 = "AVSgrdn0.def"

    /// libraryOfEnlightenment
    /// Terrain kind: Land
    case libraryOfEnlightenment_AVSlibr0 = "AVSlibr0.def"

    /// monster - skeleton
    /// Terrain kind: dirt
    case skeleton_AVWskel0 = "AVWskel0.def"

    /// altarOfSacrifice
    /// Terrain kind: Land
    case altarOfSacrifice_AvXAltar = "AvXAltar.def"

    /// creatureBank - cyclopsStockpile
    /// Terrain kind: Land
    case cyclopsStockpile_AVXbnk10 = "AVXbnk10.def"

    /// creatureBank - impCache
    /// Terrain kind: Land
    case impCache_AVXbnk40 = "AVXbnk40.def"

    /// denOfThieves
    /// Terrain kind: Land
    case denOfThieves_AvXDenT = "AvXDenT.def"

    /// eyeOfTheMagi
    /// Terrain kind: Land
    case eyeOfTheMagi_AVXeyem0 = "AVXeyem0.def"

    /// hutOfTheMagi
    /// Terrain kind: Land
    case hutOfTheMagi_AVXhutm0 = "AVXhutm0.def"

    /// shrineOfMagicIncantation
    /// Terrain kind: Land
    case shrineOfMagicIncantation_AVXl1sh0 = "AVXl1sh0.def"

    /// shrineOfMagicThought
    /// Terrain kind: Land
    case shrineOfMagicThought_AVXl3sh0 = "AVXl3sh0.def"

    /// shrineOfMagicGesture
    /// Terrain kind: Land
    case shrineOfMagicGesture_AVXl2sh0 = "AVXl2sh0.def"

    /// lighthouse
    /// Terrain kind: dirt, sand, grass, snow, swamp, rough, lava
    case lighthouse_AVXlths0 = "AVXlths0.def"

    /// blackMarket
    /// Terrain kind: Land
    case blackMarket_AVXmktb0 = "AVXmktb0.def"

    /// garrison - false
    /// Terrain kind: Land
    case garrisonFalse_AVCgar10 = "AVCgar10.def"

    /// marlettoTower
    /// Terrain kind: Land
    case marlettoTower_AvSMarl = "AvSMarl.def"

    /// borderguard - lightBlue
    /// Terrain kind: Land
    case borderguardLightBlue_AVXbor00 = "AVXbor00.def"

    /// artifact - blackshardOfTheDeadKnight
    /// Terrain kind: dirt
    case blackshardOfTheDeadKnight_AVA0008 = "AVA0008.def"

    /// artifact - targOfTheRampagingOgre
    /// Terrain kind: dirt
    case targOfTheRampagingOgre_AVA0016 = "AVA0016.def"

    /// artifact - breastplateOfPetrifiedWood
    /// Terrain kind: dirt
    case breastplateOfPetrifiedWood_AVA0025 = "AVA0025.def"

    /// borderguard - playerFour
    /// Terrain kind: Land
    case borderguardPlayerFour_AVXbor10 = "AVXbor10.def"

    /// keymastersTent - playerFour
    /// Terrain kind: Land
    case keymastersTentPlayerFour_AVXkey10 = "AVXkey10.def"

    /// borderguard - playerOne
    /// Terrain kind: Land
    case borderguardPlayerOne_AVXbor20 = "AVXbor20.def"

    /// keymastersTent - playerOne
    /// Terrain kind: Land
    case keymastersTentPlayerOne_AVXkey20 = "AVXkey20.def"

    /// borderguard - darkBlue
    /// Terrain kind: Land
    case borderguardDarkBlue_AVXbor30 = "AVXbor30.def"

    /// borderguard - brown
    /// Terrain kind: Land
    case borderguardBrown_AVXbor40 = "AVXbor40.def"

    /// borderguard - playerSix
    /// Terrain kind: Land
    case borderguardPlayerSix_AVXbor50 = "AVXbor50.def"

    /// keymastersTent - playerSix
    /// Terrain kind: Land
    case keymastersTentPlayerSix_AVXkey50 = "AVXkey50.def"

    /// prison
    /// Terrain kind: Land
    case prison_AVXprsn0 = "AVXprsn0.def"

    /// sanctuary
    /// Terrain kind: Land
    case sanctuary_AVXsanc0 = "AVXsanc0.def"

    /// redwoodObservatory
    /// Terrain kind: dirt, sand, grass, snow, swamp, rough, lava
    case redwoodObservatory_AvXRedW = "AvXRedW.def"

    /// rallyFlag
    /// Terrain kind: Land
    case rallyFlag_AVXrlly0 = "AVXrlly0.def"

    /// mine - crystalCavern
    /// Terrain kind: Land
    case crystalCavern_AVMcrys0 = "AVMcrys0.def"

    /// magicWell
    /// Terrain kind: sand, rough, subterranean, lava
    case magicWell_AVXwelr0 = "AVXwelr0.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG10 = "AvLRG10.def"

    /// refugeeCamp
    /// Terrain kind: Land
    case refugeeCamp_AVGrefg0 = "AVGrefg0.def"

    /// waterWheel
    /// Terrain kind: snow
    case waterWheel_AVMwwsn0 = "AVMwwsn0.def"

    /// crater
    /// Terrain kind: lava
    case crater_AVLct6l0 = "AVLct6l0.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca080 = "AVLca080.def"

    /// artifact - titansGladius
    /// Terrain kind: dirt
    case titansGladius_AVA0012 = "AVA0012.def"

    /// artifact - ribCage
    /// Terrain kind: dirt
    case ribCage_AVA0026 = "AVA0026.def"

    /// artifact - hellstormHelmet
    /// Terrain kind: dirt
    case hellstormHelmet_AVA0023 = "AVA0023.def"

    /// artifact - bootsOfPolarity
    /// Terrain kind: dirt
    case bootsOfPolarity_AVA0059 = "AVA0059.def"

    /// artifact - scalesOfTheGreaterBasilisk
    /// Terrain kind: dirt
    case scalesOfTheGreaterBasilisk_AVA0027 = "AVA0027.def"

    /// artifact - helmOfTheAlabasterUnicorn
    /// Terrain kind: dirt
    case helmOfTheAlabasterUnicorn_AVA0019 = "AVA0019.def"

    /// artifact - breastplateOfBrimstone
    /// Terrain kind: dirt
    case breastplateOfBrimstone_AVA0029 = "AVA0029.def"

    /// artifact - swordOfHellfire
    /// Terrain kind: dirt
    case swordOfHellfire_AVA0011 = "AVA0011.def"

    /// hero - knight
    /// Terrain kind: Land
    case heroKnight_ah00_e = "ah00_e.def"

    /// hero - alchemist
    /// Terrain kind: Land
    case heroAlchemist_ah04_e = "ah04_e.def"

    /// hero - heretic
    /// Terrain kind: Land
    case heroHeretic_ah07_e = "ah07_e.def"

    /// hero - witch
    /// Terrain kind: Land
    case heroWitch_ah15_e = "ah15_e.def"

    /// hero - barbarian
    /// Terrain kind: Land
    case heroBarbarian_ah12_e = "ah12_e.def"

    /// crater
    /// Terrain kind: rough
    case crater_AVLct7r0 = "AVLct7r0.def"

    /// mandrake
    /// Terrain kind: swamp
    case mandrake_AVLman20 = "AVLman20.def"

    /// mandrake
    /// Terrain kind: swamp
    case mandrake_AVLman10 = "AVLman10.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs11s0 = "AVLs11s0.def"

    /// shrub
    /// Terrain kind: swamp
    case shrub_AVLs08s0 = "AVLs08s0.def"

    /// artifact - swordOfJudgement
    /// Terrain kind: dirt
    case swordOfJudgement_AVA0035 = "AVA0035.def"

    /// artifact - thunderHelmet
    /// Terrain kind: dirt
    case thunderHelmet_AVA0024 = "AVA0024.def"

    /// randomMonsterLevel4
    /// Terrain kind: dirt
    case randomMonsterLevel4_AVWmon4 = "AVWmon4.def"

    /// artifact - mysticOrbOfMana
    /// Terrain kind: dirt
    case mysticOrbOfMana_AVA0075 = "AVA0075.def"

    /// artifact - ringOfTheWayfarer
    /// Terrain kind: dirt
    case ringOfTheWayfarer_AVA0069 = "AVA0069.def"

    /// crater
    /// Terrain kind: rough
    case crater_AVLct1r0 = "AVLct1r0.def"

    /// creatureBank - medusaStores
    /// Terrain kind: dirt, sand, grass, snow, swamp, rough, lava
    case medusaStores_AVXbnk50 = "AVXbnk50.def"

    /// artifact - ogresClubOfHavoc
    /// Terrain kind: dirt
    case ogresClubOfHavoc_AVA0010 = "AVA0010.def"

    /// mine - alchemistsLab
    /// Terrain kind: snow
    case alchemistsLab_AVMalcs0 = "AVMalcs0.def"

    /// creatureGenerator1 - workshop
    /// Terrain kind: Land
    case workshop_AVGgrem0 = "AVGgrem0.def"

    /// creatureGenerator1 - parapet
    /// Terrain kind: Land
    case parapet_AVGgarg0 = "AVGgarg0.def"

    /// creatureGenerator1 - impCrucible
    /// Terrain kind: Land
    case impCrucible_AVGimp0 = "AVGimp0.def"

    /// creatureGenerator1 - hallOfSins
    /// Terrain kind: Land
    case hallOfSins_AVGgogs0 = "AVGgogs0.def"

    /// monolithOneWayEntrance - red
    /// Terrain kind: Land
    case monolithOneWayEntranceRed_AVXmn1r0 = "AVXmn1r0.def"

    /// randomMonsterLevel5
    /// Terrain kind: dirt
    case randomMonsterLevel5_AVWmon5 = "AVWmon5.def"

    /// shrub
    /// Terrain kind: grass
    case shrub_AVLsh4g0 = "AVLsh4g0.def"

    /// rock
    /// Terrain kind: grass
    case rock_AvLRG09 = "AvLRG09.def"

    /// shrub
    /// Terrain kind: grass
    case shrub_AVLsh5g0 = "AVLsh5g0.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv230 = "AVLlv230.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv240 = "AVLlv240.def"

    /// campfire
    /// Terrain kind: lava
    case campfire_AVXcflv0 = "AVXcflv0.def"

    /// lavaLake
    /// Terrain kind: lava
    case lavaLake_AVLlav10 = "AVLlav10.def"

    /// campfire
    /// Terrain kind: sand, subterranean
    case campfire_AVXcfds0 = "AVXcfds0.def"

    /// oasis
    /// Terrain kind: sand
    case oasis_AVXosis0 = "AVXosis0.def"

    /// artifact - armorOfWonder
    /// Terrain kind: dirt
    case armorOfWonder_AVA0031 = "AVA0031.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca050 = "AVLca050.def"

    /// monster - genie
    /// Terrain kind: dirt
    case genie_AVWgeni0 = "AVWgeni0.def"

    /// flowers
    /// Terrain kind: dirt
    case flowers_AVLfl1d0 = "AVLfl1d0.def"

    /// rock
    /// Terrain kind: dirt
    case rock_AvLRD04 = "AvLRD04.def"

    /// monster - archMage
    /// Terrain kind: dirt
    case archMage_AVWmagx0 = "AVWmagx0.def"

    /// mine - orePit
    /// Terrain kind: lava
    case orePit_AVMorlv0 = "AVMorlv0.def"

    /// hole
    /// Terrain kind: swamp
    case hole_AVLhols0 = "AVLhols0.def"

    /// cartographer
    /// Terrain kind: Water
    case cartographer_AVXmapw0 = "AVXmapw0.def"

    /// riverDelta
    /// Terrain kind: dirt, sand, grass
    case riverDelta_clrdelt3 = "clrdelt3.def"

    /// mine - crystalCavern
    /// Terrain kind: dirt
    case crystalCavern_AVMcrdr0 = "AVMcrdr0.def"

    /// flowers
    /// Terrain kind: grass
    case flowers_AVLf10g0 = "AVLf10g0.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv220 = "AVLlv220.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv140 = "AVLlv140.def"

    /// mine - crystalCavern
    /// Terrain kind: lava
    case crystalCavern_AVMcrvo0 = "AVMcrvo0.def"

    /// lavaFlow
    /// Terrain kind: lava
    case lavaFlow_AVLlv150 = "AVLlv150.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLstg60 = "AVLstg60.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr15u0 = "AVLr15u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr06u0 = "AVLr06u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr03u0 = "AVLr03u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLr14u0 = "AVLr14u0.def"

    /// rock
    /// Terrain kind: subterranean
    case rock_AVLstg40 = "AVLstg40.def"

    /// shrub
    /// Terrain kind: rough
    case shrub_avlsh7r0 = "avlsh7r0.def"

    /// trees
    /// Terrain kind: sand, rough
    case trees_AVLyuc30 = "AVLyuc30.def"

    /// witchHut - pathfinding
    /// Terrain kind: Land
    case witchHutPathfinding_AVSwtch0 = "AVSwtch0.def"

    /// treeofKnowledge
    /// Terrain kind: dirt, grass
    case treeofKnowledge_AVXtrek0 = "AVXtrek0.def"

    /// keymastersTent - lightBlue
    /// Terrain kind: Land
    case keymastersTentLightBlue_AVXkey00 = "AVXkey00.def"

    /// creatureBank - dwarvenTreasury
    /// Terrain kind: Land
    case dwarvenTreasury_AVXbnk20 = "AVXbnk20.def"

    /// obelisk
    /// Terrain kind: snow
    case obelisk_AvXOblP = "AvXOblP.def"

    /// obelisk
    /// Terrain kind: grass
    case obelisk_AvXOblW = "AvXOblW.def"

    /// creatureGenerator1 - gnollHut
    /// Terrain kind: Land
    case gnollHut_AVGgnll0 = "AVGgnll0.def"

    /// monolithOneWayExit - blue
    /// Terrain kind: Land
    case monolithOneWayExitBlue_AVXmx1b0 = "AVXmx1b0.def"

    /// monolithOneWayExit - red
    /// Terrain kind: Land
    case monolithOneWayExitRed_AVXmx1r0 = "AVXmx1r0.def"

    /// boat
    /// Terrain kind: Water
    case boat_AVXboat1 = "AVXboat1.def"

    /// randomMonsterLevel6
    /// Terrain kind: dirt
    case randomMonsterLevel6_AVWmon6 = "AVWmon6.def"

    /// artifact - crownOfTheSupremeMagi
    /// Terrain kind: dirt
    case crownOfTheSupremeMagi_AVA0022 = "AVA0022.def"

    /// creatureGenerator1 - orcTower
    /// Terrain kind: Land
    case orcTower_AVGorcg0 = "AVGorcg0.def"

    /// windmill
    /// Terrain kind: Land
    case windmill_AVMwndd0 = "AVMwndd0.def"

    /// windmill
    /// Terrain kind: snow
    case windmill_AVMwmsn0 = "AVMwmsn0.def"

    /// creatureGenerator1 - wolfPen
    /// Terrain kind: Land
    case wolfPen_AVGwolf0 = "AVGwolf0.def"

    /// cursedGround
    /// Terrain kind: Land
    case cursedGround_AVXcrsd0 = "AVXcrsd0.def"

    /// creatureBank - nagaBank
    /// Terrain kind: Land
    case nagaBank_AVXbnk60 = "AVXbnk60.def"

    /// creatureBank - dragonFlyHive
    /// Terrain kind: Land
    case dragonFlyHive_AVXbnk70 = "AVXbnk70.def"

    /// keymastersTent - darkBlue
    /// Terrain kind: Land
    case keymastersTentDarkBlue_AVXkey30 = "AVXkey30.def"

    /// keymastersTent - brown
    /// Terrain kind: Land
    case keymastersTentBrown_AVXkey40 = "AVXkey40.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca010 = "AVLca010.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca040 = "AVLca040.def"

    /// cactus
    /// Terrain kind: sand
    case cactus_AVLca070 = "AVLca070.def"
    
    /// creatureGenerator1 - cyclopsCave
    /// Terrain kind: Land
    case cyclopsCave_AVGcycl0 = "AVGcycl0.def"

    /// artifact - amuletOfTheUndertaker
    /// Terrain kind: dirt
    case amuletOfTheUndertaker_AVA0054 = "AVA0054.def"

    /// artifact - ringOfConjuring
    /// Terrain kind: dirt
    case ringOfConjuring_AVA0077 = "AVA0077.def"
    
    /// town - conflux
    /// Terrain kind: Land
    case townConflux_avchforx = "avchforx.def"

    /// creatureGenerator1 - altarOfEarth
    /// Terrain kind: Land
    case altarOfEarth_AVG2ele = "AVG2ele.def"

    /// creatureGenerator1 - gorgonLair
    /// Terrain kind: Land
    case gorgonLair_AVGgorg0 = "AVGgorg0.def"

    /// creatureGenerator1 - magicLantern
    /// Terrain kind: Land
    case magicLantern_AVGpixie = "AVGpixie.def"
    
    /// creatureGenerator1 - altarOfAir
    /// Terrain kind: Land
    case altarOfAir_AVG2ela = "AVG2ela.def"

    /// creatureGenerator1 - altarOfFire
    /// Terrain kind: Land
    case altarOfFire_AVG2elf = "AVG2elf.def"

    /// creatureGenerator1 - dragonVault
    /// Terrain kind: Land
    case dragonVault_AVGbone0 = "AVGbone0.def"
}
