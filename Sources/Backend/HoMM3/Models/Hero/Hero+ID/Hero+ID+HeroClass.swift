//
//  Hero+ID+HeroClass.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-26.
//

import Foundation

public extension Hero.ID {
    
    
    static func knights(format: Map.Format = .shadowOfDeath) -> [Self] {
        return [
            Optional<Self>.some(Self.christian),
            .edric,
            .orrin,
            .sorsha,
            .sylvia,
            .valeska,
            .tyris,
            .lordHaart,
            { format >= .armageddonsBlade ? Self.catherine : nil }(),
            { format >= .armageddonsBlade ? Self.roland : nil }(),
            { format >= .armageddonsBlade ? Self.sirMullich : nil }(),
        ].compactMap({ $0 })
    }
    
    static let clerics: [Self] = [
            .adela,
            .adelaide,
            .caitlin,
            .cuthbert,
            .ingham,
            .loynis,
            .rion,
            .sanya
    ]
    
    static func castle(format: Map.Format = .shadowOfDeath) -> [Self] { Self.knights(format: format) + Self.clerics }
    
    static func rangers(format: Map.Format = .shadowOfDeath) -> [Self] {
        return [
            Optional<Self>.some(Self.clancy),
            .ivor,
            .jenova,
            .kyrre,
            .mephala,
            .ryland,
            .thorgrim,
            .ufretin,
            { format >= .armageddonsBlade ? Self.gelu : nil }(),
        ].compactMap({ $0 })
    }
    
    static let druids: [Self] = [
        .aeris,
        .alagar,
        .coronius,
        .elleshar,
        .gem,
        .malcom,
        .melodia,
        .uland
    ]
    
    static func rampart(format: Map.Format = .shadowOfDeath) -> [Self] { Self.rangers(format: format) + Self.druids }
   
    static let alchemists: [Self] = [
        .fafner, .iona, .josephine, .neela, .piquedram, .rissa, .thane, .torosar
    ]
    
    static func wizards(format: Map.Format = .shadowOfDeath) -> [Self] {
        return [
            Optional<Self>.some(Self.aine),
            .astral, .cyra, .daremyth, .halon, .serena, .solmyr, .theodorus,
            { format >= .armageddonsBlade ? Self.dracon : nil }()
        ].compactMap({ $0 })
    }
    
    static func tower(format: Map.Format = .shadowOfDeath) -> [Self] { Self.alchemists + Self.wizards(format: format) }
    
    static func demoniacs(format: Map.Format = .shadowOfDeath) -> [Self] { [
    Optional<Self>.some(.calh), .fiona, .ignatius, .marius, .nymus, .octavia, .pyre, .rashka,
        { format >= .armageddonsBlade ? Self.xeron : nil }()
    ].compactMap({ $0 }) }
    
    static let heretics: [Self] = [
        .ash, .axsis, .ayden, .calid, .olema, .xarfax, .xyron, .zydar
    ]
    
    static func inferno(format: Map.Format = .shadowOfDeath) -> [Self] { Self.demoniacs(format: format) + Self.heretics }
    
    static func deathKnights(format: Map.Format = .shadowOfDeath) -> [Self] {
        return [
            Optional<Self>.some(Self.charna),
            .clavius, .galthran, .isra, .moandor, .straker, .tamika, .vokial,
            { format >= .armageddonsBlade ? Self.lordHaartTheDeathKnight : nil }(),
        ].compactMap({ $0 })
    }
    
    static let necromancers: [Self] = [
        .aislinn, .nagash,. nimbus, .sandro, .septienna, .thant, .vidomina, .xsi
    ]
    
    static func overlord(format: Map.Format = .shadowOfDeath) -> [Self] {
        return [
            Optional<Self>.some(Self.ajit),
            .arlach, .dace, .damacon, .gunnar, .lorelei, .shakti, .synca,
            { format >= .armageddonsBlade ? Self.mutare : nil }(),
            { format >= .armageddonsBlade ? Self.mutareDrake : nil }(),
        ].compactMap({ $0 })
    }
    
    static let warlocks: [Self] = [
        .alamar, .darkstorn, .deemer, .geon, .jaegar, .jeddite, .malekith, .sephinroth
    ]
    
    static func dungeon(format: Map.Format = .shadowOfDeath) -> [Self] { Self.overlord(format: format) + Self.warlocks }
    
    static func barbarians(format: Map.Format = .shadowOfDeath) -> [Self] {
        return [
            Optional<Self>.some(Self.cragHack),
            .gretchin, .gurnisson, .jabarkas, .krellion, .shiva, .tyraxor, .yog,
            { format >= .armageddonsBlade ? Self.boragus : nil }(),
            { format >= .armageddonsBlade ? Self.kilgor : nil }(),
        ].compactMap({ $0 })
    }
    
    static let battleMages: [Self] = [
        .dessa, .gird, .gundula, .oris, .saurug, .terek, .vey, .zubin
    ]
    
    static func stronghold(format: Map.Format = .shadowOfDeath) -> [Self] { Self.barbarians(format: format) + Self.battleMages }
    
    static let beastmasters: [Self] = [
        .alkin, .broghild, .bron, .drakon, .gerwulf, .korbac, .tazar, .wystan
    ]
    
    static func witches(format: Map.Format = .shadowOfDeath) -> [Self] {
        return [
            Optional<Self>.some(Self.andra),
            .merist, .mirlanda, .rosic, .styg, .tiva, .verdish, .voy,
            { format >= .armageddonsBlade ? Self.adrienne : nil }(),
        ].compactMap({ $0 })
    }
    
    static func fortress(format: Map.Format = .shadowOfDeath) -> [Self] { Self.beastmasters + Self.witches(format: format) }
    
    static let planeswalkers: [Self] = [
        .erdamon, .fiur, .ignissa, .kalt, .lacus, .monere, .pasis, .thunar
    ]
    
    static let elementalists: [Self] = [
        .aenain, .brissa, .ciele, .gelare, .grindan, .inteus, .labetha, .luna
    ]
    
    static let conflux: [Self] = Self.planeswalkers + Self.elementalists
    
    var `class`: Hero.Class {
        if Self.knights().contains(self) { return .knight }
        if Self.clerics.contains(self) { return .cleric }
        if Self.rangers().contains(self) { return .ranger }
        if Self.druids.contains(self) { return .druid }
        if Self.alchemists.contains(self) { return .alchemist }
        if Self.wizards().contains(self) { return .wizard }
        if Self.demoniacs().contains(self) { return .demoniac }
        if Self.heretics.contains(self) { return .heretic }
        if Self.deathKnights().contains(self) { return .deathKnight }
        if Self.necromancers.contains(self) { return .necromancer }
        if Self.overlord().contains(self) { return .overlord }
        if Self.warlocks.contains(self) { return .warlock }
        if Self.barbarians().contains(self) { return .barbarian }
        if Self.battleMages.contains(self) { return .battleMage }
        if Self.beastmasters.contains(self) { return .beastmaster }
        if Self.witches().contains(self) { return .witch }
        if Self.planeswalkers.contains(self) { return .planeswalker }
        if Self.elementalists.contains(self) { return .elementalist }
        
        fatalError("unhandled here. HOTA hero? Please add support for HOTA here! :D ")
        
    }
    
}
