//
//  ArtifactIDTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation
import XCTest
import HoMM3SwiftUI

final class ArtifactIDTest: XCTestCase {
    
    private func doTest(artifactId: Artifact.ID, is rawValue: Artifact.ID.RawValue) {
        XCTAssertEqual(artifactId.rawValue, rawValue)
    }
    
    func testCentaurAxe() {
        doTest(artifactId: .centaurAxe, is: 7)
    }
    
    func testOrbOfInhibition() {
        doTest(artifactId: .orbOfInhibition, is: 126)
    }
    
    func testVialOfDragonBlood() {
        doTest(artifactId: .vialOfDragonBlood, is: 127)
    }
    
    func testArmageddonsBlade() {
        doTest(artifactId: .armageddonsBlade, is: 128)
    }
    
    func testAngelicAlliance() {
        doTest(artifactId: .angelicAlliance, is: 129)
    }
    
    func testTitansThunder() {
        // https://github.com/vcmi/vcmi/blob/b1db6e2/lib/GameConstants.h#L1066
        doTest(artifactId: .titansThunder, is: 135)
    }
    
    func testCornucopia() {
        doTest(artifactId: .cornucopia, is: 140)
    }
    
    func testRoe() {
        XCTAssertEqual(Artifact.ID.available(in: .restorationOfErathia), [.spellBook,
                       .spellScroll,
                       .grail,
                       .catapult,
                       .ballista,
                       .ammoCart,
                       .firstAidTent,
                       .centaurAxe,
                       .blackshardOfTheDeadKnight,
                       .greaterGnollsFlail,
                       .ogresClubOfHavoc,
                       .swordOfHellfire,
                       .titansGladius,
                       .shieldOfTheDwarvenLords,
                       .shieldOfTheYawningDead,
                       .bucklerOfTheGnollKing,
                       .targOfTheRampagingOgre,
                       .shieldOfTheDamned,
                       .sentinelsShield,
                       .helmOfTheAlabasterUnicorn,
                       .skullHelmet,
                       .helmOfChaos,
                       .crownOfTheSupremeMagi,
                       .hellstormHelmet,
                       .thunderHelmet,
                       .breastplateOfPetrifiedWood,
                       .ribCage,
                       .scalesOfTheGreaterBasilisk,
                       .tunicOfTheCyclopsKing,
                       .breastplateOfBrimstone,
                       .titansCuirass,
                       .armorOfWonder,
                       .sandalsOfTheSaint,
                       .celestialNecklaceOfBliss,
                       .lionsShieldOfCourage,
                       .swordOfJudgement,
                       .helmOfHeavenlyEnlightenment,
                       .quietEyeOfTheDragon,
                       .redDragonFlameTongue,
                       .dragonScaleShield,
                       .dragonScaleArmor,
                       .dragonboneGreaves,
                       .dragonWingTabard,
                       .necklaceOfDragonteeth,
                       .crownOfDragontooth,
                       .stillEyeOfTheDragon,
                       .cloverOfFortune,
                       .cardsOfProphecy,
                       .ladybirdOfLuck,
                       .badgeOfCourage,
                       .crestOfValor,
                       .glyphOfGallantry,
                       .speculum,
                       .spyglass,
                       .amuletOfTheUndertaker,
                       .vampiresCowl,
                       .deadMansBoots,
                       .garnitureOfInterference,
                       .surcoatOfCounterpoise,
                       .bootsOfPolarity,
                       .bowOfElvenCherrywood,
                       .bowstringOfTheUnicornsMane,
                       .angelFeatherArrows,
                       .birdOfPerception,
                       .stoicWatchman,
                       .emblemOfCognizance,
                       .statesmansMedal,
                       .diplomatsRing,
                       .ambassadorsSash,
                       .ringOfTheWayfarer,
                       .equestriansGloves,
                       .necklaceOfOceanGuidance,
                       .angelWings,
                       .charmOfMana,
                       .talismanOfMana,
                       .mysticOrbOfMana,
                       .collarOfConjuring,
                       .ringOfConjuring,
                       .capeOfConjuring,
                       .orbOfTheFirmament,
                       .orbOfSilt,
                       .orbOfTempestuousFire,
                       .orbOfDrivingRain,
                       .recantersCloak,
                       .spiritOfOppression,
                       .hourglassOfTheEvilHour,
                       .tomeOfFireMagic,
                       .tomeOfAirMagic,
                       .tomeOfWaterMagic,
                       .tomeOfEarthMagic,
                       .bootsOfLevitation,
                       .goldenBow,
                       .sphereOfPermanence,
                       .orbOfVulnerability,
                       .ringOfVitality,
                       .ringOfLife,
                       .vialOfLifeblood,
                       .necklaceOfSwiftness,
                       .bootsOfSpeed,
                       .capeOfVelocity,
                       .pendantOfDispassion,
                       .pendantOfSecondSight,
                       .pendantOfHoliness,
                       .pendantOfLife,
                       .pendantOfDeath,
                       .pendantOfFreeWill,
                       .pendantOfNegativity,
                       .pendantOfTotalRecall,
                       .pendantOfCourage,
                       .everflowingCrystalCloak,
                       .ringOfInfiniteGems,
                       .everpouringVialOfMercury,
                       .inexhaustibleCartOfOre,
                       .eversmokingRingOfSulfur,
                       .inexhaustibleCartOfLumber,
                       .endlessSackOfGold,
                       .endlessBagOfGold,
                       .endlessPurseOfGold,
                       .legsOfLegion,
                       .loinsOfLegion,
                       .torsoOfLegion,
                       .armsOfLegion,
                       .headOfLegion,
                       .seaCaptainsHat,
                       .spellbindersHat,
                       .shacklesOfWar,
                       .orbOfInhibition
                       ])
    }
    
    #if WOG
    func testArtifactSelection() {
        // https://github.com/vcmi/vcmi/blob/b1db6e2/lib/GameConstants.h#L1069
        doTest(heroId: .artifactSelection, is: 144)
    }
    func testArtifactLock() {
        // https://github.com/vcmi/vcmi/blob/b1db6e2/lib/GameConstants.h#L1070
        doTest(heroId: .artifactLock, is: 145)
    }
    func testMithrilMail() {
        // https://github.com/vcmi/vcmi/blob/b1db6e2/lib/GameConstants.h#L1072
        doTest(heroId: .mithrilMail, is: 147)
    }
    func testSlavasRingOfPower() {
        // https://github.com/vcmi/vcmi/blob/b1db6e2/lib/GameConstants.h#L1080
        doTest(heroId: .slavasRingOfPower, is: 155)
    }
    #endif // WOG
    
    
}
