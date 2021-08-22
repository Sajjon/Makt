//
//Creature+ID.swift
//HoMM3SwiftUI
//
//CreatedbyAlexanderCyonon2021-08-20.
//

import Foundation

public extension Creature{
    enum ID: UInt8, Hashable, CaseIterable{
        case pikeman = 0,
        halberdier = 1,
        archer = 2,
        marksman = 3,
        griffin = 4,
        royalGriffin = 5,
        swordsman = 6,
        crusader = 7,
        monk = 8,
        zealot = 9,
        cavalier = 10,
        champion = 11,
        angel = 12,
        archangel = 13,
        centaur = 14,
        centaurCaptain = 15,
        dwarf = 16,
        battleDwarf = 17,
        woodElf = 18,
        grandElf = 19,
        pegasus = 20,
        silverPegasus = 21,
        sendroidGuard = 22,
        sendroidSoldier = 23,
        unicorn = 24,
        warUnicorn = 25,
        greenDragon = 26,
        goldDragon = 27,
        gremlin = 28,
        masterGremlin = 29,
        stoneGargoyle = 30,
        obsidianGargoyle = 31,
        stoneGolem = 32,
        ironGolem = 33,
        mage = 34,
        archMage = 35,
        genie = 36,
        masterGenie = 37,
        naga = 38,
        nagaQueen = 39,
        giant = 40,
        titan = 41,
        imp = 42,
        familiar = 43,
        gog = 44,
        magog = 45,
        hellHound = 46,
        cerberus = 47,
        demon = 48,
        hornedDemon = 49,
        pitFiend = 50,
        pitLord = 51,
        efreeti = 52,
        efreetSultan = 53,
        devil = 54,
        archDevil = 55,
        skeleton = 56,
        skeletonWarrior = 57,
        walkingDead = 58,
        zombie = 59,
        wight = 60,
        wraith = 61,
        vampire = 62,
        vampireLord = 63,
        lich = 64,
        powerLich = 65,
        blackKnight = 66,
        dreadKnight = 67,
        boneDragon = 68,
        ghostDragon = 69,
        troglodyte = 70,
        infernalTroglodyte = 71,
        harpy = 72,
        harpyHag = 73,
        beholder = 74,
        evilEye = 75,
        medusa = 76,
        medusaQueen = 77,
        minotaur = 78,
        minotaurKing = 79,
        manticore = 80,
        scorpicore = 81,
        redDragon = 82,
        blackDragon = 83,
        goblin = 84,
        hobgoblin = 85,
        wolfRider = 86,
        wolfRaider = 87,
        orc = 88,
        orcChieftain = 89,
        ogre = 90,
        ogreMage = 91,
        roc = 92,
        thunderbird = 93,
        cyclops = 94,
        cyclopsKing = 95,
        behemoth = 96,
        ancientBehemoth = 97,
        gnoll = 98,
        gnollMarauder = 99,
        lizardman = 100,
        lizardWarrior = 101,
        gorgon = 102,
        mightyGorgon = 103,
        serpentFly = 104,
        dragonFly = 105,
        basilisk = 106,
        greaterBasilisk = 107,
        wyvern = 108,
        wyvernMonarch = 109,
        hydra = 110,
        chaosHydra = 111,
        airElemental = 112,
        earthElemental = 113,
        fireElemental = 114,
        waterElemental = 115,
        goldGolem = 116,
        diamondGolem = 117,
        pixie = 118,
        sprite = 119,
        psychicElemental = 120,
        magicElemental = 121,
//        NOTUSED(attacker) = 122,
        iceElemental = 123,
//        NOTUSED(defender) = 124,
        magmaElemental = 125,
//        NOTUSED(3) = 126,
        stormElemental = 127,
//        NOTUSED(4) = 128,
        energyElemental = 129,
        firebird = 130,
        phoenix = 131,
        azureDragon = 132,
        crystalDragon = 133,
        faerieDragon = 134,
        rustDragon = 135,
        enchanter = 136,
        sharpshooter = 137,
        halfling = 138,
        peasant = 139,
        boar = 140,
        mummy = 141,
        nomad = 142,
        rogue = 143,
        troll = 144
        
        #if WOG
//        Catapult(specialtyX1) = 145,
//        Ballista(specialtyX1) = 146,
//        FirstAidTent(specialtyX1) = 147,
//        AmmoCart(specialtyX1) = 148,
//        ArrowTowers(specialtyX1) = 149,
        case supremeArchangel = 150,
        DiamondDragon = 151,
        LordofThunder = 152,
        Antichrist = 153,
        BloodDragon = 154,
        DarknessDragon = 155,
        GhostBehemoth = 156,
        HellHydra = 157,
        SacredPhoenix = 158,
        Ghost = 159,
        EmissaryofWar = 160,
        EmissaryofPeace = 161,
        EmissaryofMana = 162,
        EmissaryofLore = 163,
        FireMessenger = 164,
        EarthMessenger = 165,
        AirMessenger = 166,
        WaterMessenger = 167,
        Gorynych = 168,
        Warzealot = 169,
        ArcticSharpshooter = 170,
        LavaSharpshooter = 171,
        Nightmare = 172,
        SantaGremlin = 173,
//        Paladin(attacker) = 174,
//        Hierophant(attacker) = 175,
//        TempleGuardian(attacker) = 176,
//        Succubus(attacker) = 177,
//        SoulEater(attacker) = 178,
//        Brute(attacker) = 179,
//        OgreLeader(attacker) = 180,
//        Shaman(attacker) = 181,
//        AstralSpirit(attacker) = 182,
//        Paladin(defender) = 183,
//        Hierophant(defender) = 184,
//        TempleGuardian(defender) = 185,
//        Succubus(defender) = 186,
//        SoulEater(defender) = 187,
//        Brute(defender) = 188,
//        OgreLeader(defender) = 189,
//        Shaman(defender) = 190,
//        AstralSpirit(defender) = 191,
        SylvanCentaur = 192,
        Sorceress = 193,
        Werewolf = 194,
        HellSteed = 195,
        Dracolich = 196
        #endif
    }
}
