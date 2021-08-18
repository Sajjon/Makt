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
        greaterGnollsFlail,
        ogresClubOfHavoc,
        swordOfHellfire,
        titansGladius,
        shieldOfTheDwarvenLords,
        shieldOfTheYawningDead,
        bucklerOfTheGnollKing,
        targOfTheRampagingOgre,
        shieldOfTheDamned,
        sentinelsShield,
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
        titansCuirass,
        armorOfWonder,
        sandalsOfTheSaint,
        celestialNecklaceOfBliss,
        lionsShieldOfCourage,
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
        vampiresCowl,
        deadMansBoots,
        garnitureOfInterference,
        surcoatOfCounterpoise,
        bootsOfPolarity,
        bowOfElvenCherrywood,
        bowstringOfTheUnicornsMane,
        angelFeatherArrows,
        birdOfPerception,
        stoicWatchman,
        emblemOfCognizance,
        statesmansMedal,
        diplomatsRing,
        ambassadorsSash,
        ringOfTheWayfarer,
        equestriansGloves,
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
        recantersCloak,
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
        seaCaptainsHat,
        spellbindersHat,
        shacklesOfWar,
        orbOfInhibition, // 126
        
        /// AB
        vialOfDragonBlood, // 127
        // AB
        armageddonsBlade, // 128
        
        /// SOD
        angelicAlliance, // 129
        
        /// SOD
        cloakOfTheUndeadKing,
        /// SOD
        elixirOfLife,
        /// SOD
        armorOfTheDamned,
        /// SOD
        statueOfLegion,
        
        /// SOD
        powerOfTheDragonFather,
        
        /// SOD
        titansThunder,
        
        /// SOD
        admiralHat,
        /// SOD
        bowOfTheSharpshooter,
        /// SOD
        wizardWell,
        /// SOD
        ringOfTheMagi,
        /// SOD
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

public extension Artifact.ID {
    static func available(in format: Map.Format) -> [Self] {
        switch format {
        case .restorationOfErathia: return Array(Self.allCases.prefix(127))
        case .armageddonsBlade: return Array(Self.allCases.prefix(129))
        case .shadowOfDeath: return Array(Self.allCases.prefix(141))
            
        }
    }
}
