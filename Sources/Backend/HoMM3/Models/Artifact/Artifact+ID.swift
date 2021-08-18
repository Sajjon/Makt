//
//  Artifact+ID.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Artifact {
    
    /// From: http://heroescommunity.com/viewthread.php3?TID=46589&PID=1529923#focus
    enum ID: UInt8, Hashable, CaseIterable {
        case spellBook,
        spellScroll,
        grail,
        catapult,
        ballista,
        ammoCart,
        firstAidTent,
        centaurAxe,
        blackshardOfTheDeadKnight,
        greaterGnollSFlail,
        ogreSClubOfHavoc,
        swordOfHellfire,
        titanSGladius,
        shieldOfTheDwarvenLords,
        shieldOfTheYawningDead,
        bucklerOfTheGnollKing,
        targOfTheRampagingOgre,
        shieldOfTheDamned,
        sentinelSShield,
        helmOfTheAlabasterUnicorn,
        skullHelmet,
        helmOfChaos,
        crownOfTheSupremeMagi,
        hellstormHelmet,
        thunderHelmet,
        breastplateOfPetrifiedWood,
        ribCage,
        scalesOfTheGreaterBasilisk,
        tunicOfTheCyclopsKing,
        breastplateOfBrimstone,
        titanSCuirass,
        armorOfWonder,
        sandalsOfTheSaint,
        celestialNecklaceOfBliss,
        lionSShieldOfCourage,
        swordOfJudgement,
        helmOfHeavenlyEnlightenment,
        quietEyeOfTheDragon,
        redDragonFlameTongue,
        dragonScaleShield,
        dragonScaleArmor,
        dragonboneGreaves,
        dragonWingTabard,
        necklaceOfDragonteeth,
        crownOfDragontooth,
        stillEyeOfTheDragon,
        cloverOfFortune,
        cardsOfProphecy,
        ladybirdOfLuck,
        badgeOfCourage,
        crestOfValor,
        glyphOfGallantry,
        speculum,
        spyglass,
        amuletOfTheUndertaker,
        vampireSCowl,
        deadManSBoots,
        garnitureOfInterference,
        surcoatOfCounterpoise,
        bootsOfPolarity,
        bowOfElvenCherrywood,
        bowstringOfTheUnicornSMane,
        angelFeatherArrows,
        birdOfPerception,
        stoicWatchman,
        emblemOfCognizance,
        statesmanSMedal,
        diplomatSRing,
        ambassadorSSash,
        ringOfTheWayfarer,
        equestrianSGloves,
        necklaceOfOceanGuidance,
        angelWings,
        charmOfMana,
        talismanOfMana,
        mysticOrbOfMana,
        collarOfConjuring,
        ringOfConjuring,
        capeOfConjuring,
        orbOfTheFirmament,
        orbOfSilt,
        orbOfTempestuousFire,
        orbOfDrivingRain,
        recanterSCloak,
        spiritOfOppression,
        hourglassOfTheEvilHour,
        tomeOfFireMagic,
        tomeOfAirMagic,
        tomeOfWaterMagic,
        tomeOfEarthMagic,
        bootsOfLevitation,
        goldenBow,
        sphereOfPermanence,
        orbOfVulnerability,
        ringOfVitality,
        ringOfLife,
        vialOfLifeblood,
        necklaceOfSwiftness,
        bootsOfSpeed,
        capeOfVelocity,
        pendantOfDispassion,
        pendantOfSecondSight,
        pendantOfHoliness,
        pendantOfLife,
        pendantOfDeath,
        pendantOfFreeWill,
        pendantOfNegativity,
        pendantOfTotalRecall,
        pendantOfCourage,
        everflowingCrystalCloak,
        ringOfInfiniteGems,
        everpouringVialOfMercury,
        inexhaustibleCartOfOre,
        eversmokingRingOfSulfur,
        inexhaustibleCartOfLumber,
        endlessSackOfGold,
        endlessBagOfGold,
        endlessPurseOfGold,
        legsOfLegion,
        loinsOfLegion,
        torsoOfLegion,
        armsOfLegion,
        headOfLegion,
        seaCaptainSHat,
        spellbinderSHat,
        shacklesOfWar,
        orbOfInhibition,
        vialOfDragonBlood,
        armageddonSBlade,
        angelicAlliance,
        cloakOfTheUndeadKing,
        elixirOfLife,
        armorOfTheDamned,
        statueOfLegion,
        powerOfTheDragonFather,
        titansThunder,
        admiralSHat,
        bowOfTheSharpshooter,
        wizardSWell,
        ringOfTheMagi,
        cornucopia // 140

        #if WOG
        /// WoG Only
        case magicWand,

        /// WoG Only
        goldTowerArrow,

        /// WoG Only
        monstersPower,

        /// NOT AN ARTIFACT. INTERNAL USE ONLY
        highlightedSlot,
        /// NOT AN ARTIFACT. INTERNAL USE ONLY
        artifactLock,

        /// WoG Only: COMMANDER Artifact
        axeOfSmashing,

        /// WoG Only: COMMANDER Artifact
        mithrilMail,

        /// WoG Only: COMMANDER Artifact
        swordOfSharpness,

        /// WoG Only: COMMANDER Artifact
        helmOfImmortality,

        /// WoG Only: COMMANDER Artifact
        pendantOfSorcery,

        /// WoG Only: COMMANDER Artifact
        bootsOfHaste,

        /// WoG Only: COMMANDER Artifact
        bowOfSeeking,

        /// WoG Only: COMMANDER Artifact
        dragonEyeRing,

        /// WoG Only: COMMANDER Artifact
        hardenedShield,

        /// WoG Only: COMMANDER Artifact
        slavasRingOfPower,

        /// WoG Only
        warlordsBanner,

        /// WoG Only
        crimsonShieldOfRetribution,

        /// WoG Only
        barbarianLordsAxeOfFerocity,

        /// WoG Only
        dragonheart,

        /// WoG Only
        gateKey,

        /// BLANK (Placeholder?) Artifact
        blankHelmet,

        /// BLANK (Placeholder?) Artifact
        blankSword,

        /// BLANK (Placeholder?) Artifact
        blankShield,

        /// BLANK (Placeholder?) Artifact
        blankHornedRing,

        /// BLANK (Placeholder?) Artifact
        blankGemmedRing,

        /// BLANK (Placeholder?) Artifact
        blankNeckBroach,

        /// BLANK (Placeholder?) Artifact
        blankArmor,

        /// BLANK (Placeholder?) Artifact
        blankSurcoat,

        /// BLANK (Placeholder?) Artifact
        blankBoots,

        /// BLANK (Placeholder?) Artifact
        blankHorn // 170
        #endif // WoG
    }
}
