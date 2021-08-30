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
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded, sorting: Sorting = .byLevel
    ) -> [Self] {
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
    
    static func castle(_ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: castleNonUpgraded,
            upgraded: castleUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func rampart(_ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: rampartNonUpgraded,
            upgraded: rampartUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func tower(_ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: towerNonUpgraded,
            upgraded: towerUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func inferno(_ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: infernoNonUpgraded,
            upgraded: infernoUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func necropolis(_ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: necropolisNonUpgraded,
            upgraded: necropolisUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func dungeon(_ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: dungeonNonUpgraded,
            upgraded: dungeonUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    static func stronghold(_ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: strongholdNonUpgraded,
            upgraded: strongholdUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    
    static func fortress(_ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded, sorting: Sorting = .byLevel) -> [Self] {
        creatureIDs(
            nonUpgraded: fortressNonUpgraded,
            upgraded: fortressUpgraded,
            upgradedOrNot, sorting: sorting
        )
    }
    
    
    static func conflux(_ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded, sorting: Sorting = .byLevel) -> [Self] {
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
        .dendroidGuard,
        .unicorn,
        .greenDragon
    ]
    
    static let rampartUpgraded: [Self] = {
        var ids: [Self] = [
            .centaurCaptain,
            .battleDwarf,
            .grandElf,
            .silverPegasus,
            .dendroidSoldier,
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
        case upgradedOnly, nonUpgradedOnly, nonUpgradedAndUpgraded
        var includeUpgraded: Bool {
            switch self {
            case .nonUpgradedOnly: return false
            case .upgradedOnly, .nonUpgradedAndUpgraded: return true
            }
        }
        var includeNonUpgraded: Bool {
            switch self {
            case .upgradedOnly: return false
            case .nonUpgradedOnly, .nonUpgradedAndUpgraded: return true
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
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedAndUpgraded,
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
        case .random: fatalError("no creatures")
        }
    }
    
    static func at(
        level: Creature.Level,
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedOnly,
        sorting: Sorting = .byUpgradedOrNot
    ) -> [Self] {
        switch level {
        case .one: return level1(upgradedOrNot, sorting: sorting)
        case .two: return level2(upgradedOrNot, sorting: sorting)
        case .three: return level3(upgradedOrNot, sorting: sorting)
        case .four: return level4(upgradedOrNot, sorting: sorting)
        case .five: return level5(upgradedOrNot, sorting: sorting)
        case .six: return level6(upgradedOrNot, sorting: sorting)
        case .seven: return level7(upgradedOrNot, sorting: sorting)
            #if WOG
        case .eight: return level8(upgradedOrNot, sorting: sorting)
            #endif // WOG
        }
    }
    
    private static func atLevel(
        nonUpgradedAtLevel: [Self],
        upgradedAtLevel: [Self],
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedOnly,
        sorting: Sorting = .byUpgradedOrNot
    ) -> [Self] {
        var ids = [Self]()
        if upgradedOrNot.includeNonUpgraded {
            ids.append(contentsOf: level1NonUpgraded)
        }
        if upgradedOrNot.includeUpgraded {
            ids.append(contentsOf: level1Upgraded)
        }
        
        switch sorting {
        case .byUpgradedOrNot: break
        case .byLevel: ids.sort(by: { $0.rawValue < $1.rawValue })
        }
        
        return ids
    }
    
    static func level1(
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedOnly,
        sorting: Sorting = .byUpgradedOrNot
    ) -> [Self] {
        atLevel(
            nonUpgradedAtLevel: level1NonUpgraded,
            upgradedAtLevel: level1Upgraded,
            upgradedOrNot,
            sorting: sorting
        )
    }
    
    static func level2(
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedOnly,
        sorting: Sorting = .byUpgradedOrNot
    ) -> [Self] {
        atLevel(
            nonUpgradedAtLevel: level2NonUpgraded,
            upgradedAtLevel: level2Upgraded,
            upgradedOrNot,
            sorting: sorting
        )
    }
    
    static func level3(
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedOnly,
        sorting: Sorting = .byUpgradedOrNot
    ) -> [Self] {
        atLevel(
            nonUpgradedAtLevel: level3NonUpgraded,
            upgradedAtLevel: level3Upgraded,
            upgradedOrNot,
            sorting: sorting
        )
    }
    
    
    static func level4(
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedOnly,
        sorting: Sorting = .byUpgradedOrNot
    ) -> [Self] {
        atLevel(
            nonUpgradedAtLevel: level4NonUpgraded,
            upgradedAtLevel: level4Upgraded,
            upgradedOrNot,
            sorting: sorting
        )
    }
    
    
    static func level5(
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedOnly,
        sorting: Sorting = .byUpgradedOrNot
    ) -> [Self] {
        atLevel(
            nonUpgradedAtLevel: level5NonUpgraded,
            upgradedAtLevel: level5Upgraded,
            upgradedOrNot,
            sorting: sorting
        )
    }
    
    static func level6(
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedOnly,
        sorting: Sorting = .byUpgradedOrNot
    ) -> [Self] {
        atLevel(
            nonUpgradedAtLevel: level6NonUpgraded,
            upgradedAtLevel: level6Upgraded,
            upgradedOrNot,
            sorting: sorting
        )
    }
    
    
    static func level7(
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedOnly,
        sorting: Sorting = .byUpgradedOrNot
    ) -> [Self] {
        atLevel(
            nonUpgradedAtLevel: level7NonUpgraded,
            upgradedAtLevel: level7Upgraded,
            upgradedOrNot,
            sorting: sorting
        )
    }
    
    #if WOG
    
    static func level8(
        _ upgradedOrNot: UpgradedOrNot = .nonUpgradedOnly,
        sorting: Sorting = .byUpgradedOrNot
    ) -> [Self] {
        atLevel(
            nonUpgradedAtLevel: level8NonUpgraded,
            upgradedAtLevel: level8Upgraded,
            upgradedOrNot,
            sorting: sorting
        )
    }
    #endif // WOG
    
    static let level1NonUpgraded: [Self] = [
        .pikeman,
        .centaur,
        .gremlin,
        .imp,
        .skeleton,
        .troglodyte,
        .goblin,
        .gnoll,
        .pixie
    ]
    
    static let level1Upgraded: [Self] = [
        .halberdier,
        .centaurCaptain,
        .masterGremlin,
        .familiar,
        .skeletonWarrior,
        .infernalTroglodyte,
        .hobgoblin,
        .gnollMarauder,
        .sprite
    ]
    
    static let level2NonUpgraded: [Self] = [
        .archer,
        .dwarf,
        .stoneGargoyle,
        .gog,
        .walkingDead,
        .harpy,
        .wolfRider,
        .lizardman,
        .airElemental
    ]
    
    static let level2Upgraded: [Self] = [
        .marksman,
        .battleDwarf,
        .obsidianGargoyle,
        .magog,
        .zombie,
        .harpyHag,
        .wolfRaider,
        .lizardWarrior,
        .stormElemental
    ]
    
    
    static let level3NonUpgraded: [Self] = [
        .griffin,
        .woodElf,
        .stoneGolem,
        .hellHound,
        .wight,
        .evilEye,
        .orc,
        .serpentFly,
        .waterElemental
    ]
    
    static let level3Upgraded: [Self] = [
        .royalGriffin,
        .grandElf,
        .ironGolem,
        .cerberus,
        .wraith,
        .beholder,
        .orcChieftain,
        .dragonFly,
        .iceElemental
    ]
    
    
    static let level4NonUpgraded: [Self] = [
        .swordsman,
        .pegasus,
        .mage,
        .demon,
        .vampire,
        .medusa,
        .ogre,
        .basilisk,
        .fireElemental
    ]
    
    static let level4Upgraded: [Self] = [
        .crusader,
        .silverPegasus,
        .archMage,
        .hornedDemon,
        .vampireLord,
        .medusaQueen,
        .ogreMage,
        .greaterBasilisk,
        .energyElemental
    ]
    
    
    static let level5NonUpgraded: [Self] = [
        .monk,
        .dendroidGuard,
        .genie,
        .pitFiend,
        .lich,
        .minotaur,
        .roc,
        .gorgon,
        .earthElemental
    ]
    
    static let level5Upgraded: [Self] = [
        .zealot,
        .dendroidSoldier,
        .masterGenie,
        .pitLord,
        .powerLich,
        .minotaurKing,
        .thunderbird,
        .mightyGorgon,
        .magmaElemental
    ]
    
    static let level6NonUpgraded: [Self] = [
        .cavalier,
        .unicorn,
        .naga,
        .efreeti,
        .blackKnight,
        .manticore,
        .cyclops,
        .wyvern,
        .psychicElemental
    ]
    
    static let level6Upgraded: [Self] = [
        .champion,
        .warUnicorn,
        .nagaQueen,
        .efreetSultan,
        .dreadKnight,
        .scorpicore,
        .cyclopsKing,
        .wyvernMonarch,
        .magicElemental
    ]
    
    static let level7NonUpgraded: [Self] = [
        .angel,
        .greenDragon,
        .giant,
        .devil,
        .boneDragon,
        .redDragon,
        .behemoth,
        .hydra,
        .firebird
    ]
    
    static let level7Upgraded: [Self] = [
        .archangel,
        .goldDragon,
        .titan,
        .archDevil,
        .ghostDragon,
        .blackDragon,
        .ancientBehemoth,
        .chaosHydra,
        .phoenix
    ]
    
    #if WOG
    static let level8: [Self] = [
        .supremeArchangel,
        .diamondDragon,
        .lordOfThunder,
        .antiChrist,
        .bloodDragon,
        .darknessDragon,
        .ghostBehemoth,
        .hellHydra,
        .sacredPhoenix
    ]
    #endif // WOG
    
    enum QueryUpgraded {
        case yes, no, random
    }
    
    static func creatureID(at level: Creature.Level, of faction: Faction, upgraded: QueryUpgraded) -> Creature.ID {
        let creaturesOfFaction = of(faction: faction)
        let creaturesAtLevel = at(level: level)
        let matches = Array(Set(creaturesAtLevel).intersection(Set(creaturesOfFaction))).sorted(by: { $0.rawValue < $1.rawValue })
        assert(matches.count == 2)
        switch upgraded {
        case .no: return matches[0]
        case .yes: return matches[1]
        case .random: return matches.randomElement()!
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
        dendroidGuard = 22,
        dendroidSoldier = 23,
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
