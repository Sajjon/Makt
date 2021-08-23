//
//Creature+ID.swift
//HoMM3SwiftUI
//
//CreatedbyAlexanderCyonon2021-08-20.
//

import Foundation

public extension Creature.ID {
    
    static let castleNonUpgraded: [Self] = [
        .pikeman,
        .archer,
        .griffin,
        .swordsman,
        .monk,
        .cavalier,
        .angel
    ]
    
    static let castleUpgraded: [Self] = {
        var ids: [Self] = [
            .halberdier,
            .marksman,
            .royalGriffin,
            .crusader,
            .zealot,
            .champion,
            .archangel
        ]
        #if WOG
        ids.append(.supremeArchangel)
        #endif // WOG
        return ids
    }()
    
    static func creatureIDs(
        nonUpgraded: [Self],
        upgraded: [Self],
        _ upgradedOrNot: UpgradedOrNot = .both, sorting: Sorting = .byLevel
    ) -> [Self] {
        precondition(upgradedOrNot != .both && sorting == .byUpgradedOrNot)
        var creatureIDs = [Self]()
        if upgradedOrNot.includeNonUpgraded {
            creatureIDs.append(contentsOf: nonUpgraded)
        }
        if upgradedOrNot.includeUpgraded {
            creatureIDs.append(contentsOf: upgraded)
        }
        
        switch sorting {
        case .byLevel: creatureIDs = creatureIDs.sorted(by: { $0.rawValue < $1.rawValue })
        case .byUpgradedOrNot: break
        }
        return creatureIDs
    }
    
    static func castle(_ upgradedOrNot: UpgradedOrNot = .both, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: castleNonUpgraded,
            upgraded: castleUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func rampart(_ upgradedOrNot: UpgradedOrNot = .both, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: rampartNonUpgraded,
            upgraded: rampartUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func tower(_ upgradedOrNot: UpgradedOrNot = .both, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: towerNonUpgraded,
            upgraded: towerUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func inferno(_ upgradedOrNot: UpgradedOrNot = .both, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: infernoNonUpgraded,
            upgraded: infernoUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func necropolis(_ upgradedOrNot: UpgradedOrNot = .both, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: necropolisNonUpgraded,
            upgraded: necropolisUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func dungeon(_ upgradedOrNot: UpgradedOrNot = .both, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: dungeonNonUpgraded,
            upgraded: dungeonUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func stronghold(_ upgradedOrNot: UpgradedOrNot = .both, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: strongholdNonUpgraded,
            upgraded: strongholdUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    
    static func fortress(_ upgradedOrNot: UpgradedOrNot = .both, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: fortressNonUpgraded,
            upgraded: fortressUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    
    static func conflux(_ upgradedOrNot: UpgradedOrNot = .both, sorting: Sorting = .byLevel) -> [Self] {
        // TODO when using sorting `.byLevel` on Conflux things get messed up because of their creature IDs... come up with a good solution here.
        creatureIDs(
            nonUpgraded: confluxNonUpgraded,
            upgraded: confluxUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static let rampartNonUpgraded: [Self] = [
        .centaur,
        .dwarf,
        .woodElf,
        .pegasus,
        .sendroidGuard,
        .unicorn,
        .greenDragon
    ]
    
    static let rampartUpgraded: [Self] = {
        var ids: [Self] = [
            .centaurCaptain,
            .battleDwarf,
            .grandElf,
            .silverPegasus,
            .sendroidSoldier,
            .warUnicorn,
            .goldDragon
        ]
        #if WOG
        ids.append(.diamondDragon)
        #endif // WOG
        return ids
    }()
    
    
    static let towerNonUpgraded: [Self] = [
        .gremlin,
        .stoneGargoyle,
        .stoneGolem,
        .mage,
        .genie,
        .naga,
        .giant
    ]
    
    static let towerUpgraded: [Self] = {
        var ids: [Self] = [
            .masterGremlin,
            .obsidianGargoyle,
            .ironGolem,
            .archMage,
            .masterGenie,
            .nagaQueen,
            .titan
        ]
        #if WOG
        ids.append(.lordOfThunder)
        #endif // WOG
        return ids
    }()
    
    
    static let infernoNonUpgraded: [Self] = [
        .imp,
        .gog,
        .hellHound,
        .demon,
        .pitFiend,
        .efreeti,
        .devil
    ]
    
    static let infernoUpgraded: [Self] = {
        var ids: [Self] = [
            .familiar,
            .magog,
            .cerberus,
            .hornedDemon,
            .pitLord,
            .efreetSultan,
            .archDevil
        ]
        #if WOG
        ids.append(.antiChrist)
        #endif // WOG
        return ids
    }()
    
    static let necropolisNonUpgraded: [Self] = [
        .skeleton,
        .walkingDead,
        .wight,
        .vampire,
        .lich,
        .blackKnight,
        .boneDragon
    ]
    
    static let necropolisUpgraded: [Self] = {
        var ids: [Self] = [
            .skeletonWarrior,
            .zombie,
            .wraith,
            .vampireLord,
            .powerLich,
            .dreadKnight,
            .ghostDragon
        ]
        #if WOG
        ids.append(.bloodDragon)
        #endif // WOG
        return ids
    }()

    
    static let dungeonNonUpgraded: [Self] = [
        .troglodyte,
        .harpy,
        .beholder,
        .medusa,
        .minotaur,
        .manticore,
        .redDragon
    ]
    
    static let dungeonUpgraded: [Self] = {
        var ids: [Self] = [
            .infernalTroglodyte,
            .harpyHag,
            .evilEye,
            .medusaQueen,
            .minotaurKing,
            .scorpicore,
            .blackDragon
        ]
        #if WOG
        ids.append(.darknessDragon)
        #endif // WOG
        return ids
    }()
    
    static let strongholdNonUpgraded: [Self] = [
        .goblin,
        .wolfRider,
        .orc,
        .ogre,
        .roc,
        .cyclops,
        .behemoth
    ]
    
    static let strongholdUpgraded: [Self] = {
        var ids: [Self] = [
            .hobgoblin,
            .wolfRaider,
            .orcChieftain,
            .ogreMage,
            .thunderbird,
            .cyclopsKing,
            .ancientBehemoth
        ]
        #if WOG
        ids.append(.ghostBehemoth)
        #endif // WOG
        return ids
    }()
    
    
    static let fortressNonUpgraded: [Self] = [
        .gnoll,
        .lizardman,
        .gorgon,
        .serpentFly,
        .basilisk,
        .wyvern,
        .hydra
    ]
    
    static let fortressUpgraded: [Self] = {
        var ids: [Self] = [
            .gnollMarauder,
            .lizardWarrior,
            .mightyGorgon,
            .dragonFly,
            .greaterBasilisk,
            .wyvernMonarch,
            .chaosHydra
        ]
        #if WOG
        ids.append(.hellHydra)
        #endif // WOG
        return ids
    }()
    
    
    static let confluxNonUpgraded: [Self] = [
        .pixie,
        .airElemental,
        .waterElemental,
        .fireElemental,
        .earthElemental,
        .psychicElemental,
        .firebird
    ]
    
    static let confluxUpgraded: [Self] = {
        var ids: [Self] = [
            .sprite,
            .stormElemental,
            .iceElemental,
            .energyElemental,
            .magmaElemental,
            .magicElemental,
            .phoenix
        ]
        #if WOG
        ids.append(.sacredPhoenix)
        #endif // WOG
        return ids
    }()
    
    enum UpgradedOrNot: Equatable {
        case upgradedOnly, nonUpgradedOnly, both
        var includeUpgraded: Bool {
            switch self {
            case .nonUpgradedOnly: return false
            case .upgradedOnly, .both: return true
            }
        }
        var includeNonUpgraded: Bool {
            switch self {
            case .upgradedOnly: return false
            case .nonUpgradedOnly, .both: return true
            }
        }
    }
    
    static let neutral: [Self] = [
        .peasant,
        .halfling,
        .boar,
        .rogue,
        .mummy,
        .nomad,
        .troll,
        .sharpshooter,
        .enchanter,
        .faerieDragon,
        .crystalDragon,
        .rustDragon,
        .azureDragon
    ]
    
    enum Sorting: Equatable {
        case byLevel, byUpgradedOrNot
    }
    
    static func of(
        faction: Faction,
        _ upgradedOrNot: UpgradedOrNot = .both,
        sorting: Sorting = .byLevel
    ) -> [Self] {
        switch faction {
        case .castle: return castle(upgradedOrNot, sorting: sorting)
        case .rampart: return rampart(upgradedOrNot, sorting: sorting)
        case .tower: return tower(upgradedOrNot, sorting: sorting)
        case .inferno: return inferno(upgradedOrNot, sorting: sorting)
        case .necropolis: return necropolis(upgradedOrNot, sorting: sorting)
        case .dungeon: return dungeon(upgradedOrNot, sorting: sorting)
        case .stronghold: return stronghold(upgradedOrNot, sorting: sorting)
        case .fortress: return fortress(upgradedOrNot, sorting: sorting)
        case .conflux: return conflux(upgradedOrNot, sorting: sorting)
        case .neutral: return Self.neutral
        }
    }
}

public extension Creature {
    
    
    enum ID: UInt8, Hashable, CaseIterable {
        // MARK: Castle
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
        
        // MARK: Rampart
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
        
        // MARK: Tower
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
        
        // MARK: Inferno
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
        
        // MARK: Necropolis
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
        
        // MARK: Dungeon
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
        
        // MARK: Stronghold
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
        
        // MARK: Fortress
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
        
        // MARK: Conflux
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
        
        // MARK: Neutral
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
        diamondDragon = 151,
        lordOfThunder = 152,
        antiChrist = 153,
        bloodDragon = 154,
        darknessDragon = 155,
        ghostBehemoth = 156,
        hellHydra = 157,
        sacredPhoenix = 158,
        
        ghost = 159,
        emissaryofWar = 160,
        emissaryofPeace = 161,
        emissaryofMana = 162,
        emissaryofLore = 163,
        fireMessenger = 164,
        earthMessenger = 165,
        airMessenger = 166,
        waterMessenger = 167,
        gorynych = 168,
        warzealot = 169,
        arcticSharpshooter = 170,
        lavaSharpshooter = 171,
        nightmare = 172,
        santaGremlin = 173,
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
        sylvanCentaur = 192,
        sorceress = 193,
        werewolf = 194,
        hellSteed = 195,
        dracolich = 196
        #endif
    }
}
