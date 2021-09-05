//
//  Hero+ID.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Hero {
    
    /// https://heroes.thelazy.net/index.php/Most_powerful_hero_(campaign)
    enum ID: UInt8, Hashable, CaseIterable, CustomStringConvertible {
        
        // MARK: Castle
        case orrin,
             valeska,
             edric,
             sylvia,
             
             /// ⚠️ Restoration of Erathia ONLY ⚠️ In AB and SoD replaced by Sir Mullich
             lordHaart,
             
             sorsha,
             christian,
             tyris,
             rion,
             adela,
             cuthbert,
             adelaide,
             ingham,
             sanya,
             loynis,
             caitlin,
             
             // MARK: Rampart
             mephala,
             ufretin,
             jenova,
             ryland,
             thorgrim,
             ivor,
             clancy,
             kyrre,
             coronius,
             uland,
             elleshar,
             gem,
             malcom,
             melodia,
             alagar,
             aeris,
             
             // MARK: Tower
             piquedram,
             thane,
             josephine,
             neela,
             torosar,
             fafner,
             rissa,
             iona,
             astral,
             halon,
             serena,
             daremyth,
             theodorus,
             solmyr,
             cyra,
             aine,
             
             // MARK: Inferno
             fiona,
             rashka,
             marius,
             ignatius,
             octavia,
             calh,
             pyre,
             nymus,
             ayden,
             xyron,
             axsis,
             olema,
             calid,
             ash,
             zydar,
             xarfax,
             
             // MARK: Necropolis
             straker,
             vokial,
             moandor,
             charna,
             tamika,
             isra,
             clavius,
             galthran,
             septienna,
             aislinn,
             sandro,
             nimbus,
             thant,
             xsi,
             vidomina,
             nagash,
             
             // MARK: Dungeon
             lorelei,
             arlach,
             dace,
             ajit,
             damacon,
             gunnar,
             synca,
             shakti,
             alamar,
             jaegar,
             malekith,
             jeddite,
             geon,
             deemer,
             sephinroth,
             darkstorn,
             
             // MARK: Stronghold
             yog,
             gurnisson,
             jabarkas,
             shiva,
             gretchin,
             krellion,
             cragHack,
             tyraxor,
             gird,
             vey,
             dessa,
             terek,
             zubin,
             gundula,
             oris,
             saurug,
             
             // MARK: Fortress
             bron,
             drakon,
             wystan,
             tazar,
             alkin,
             korbac,
             gerwulf,
             broghild,
             mirlanda,
             rosic,
             voy,
             verdish,
             merist,
             styg,
             andra,
             tiva,
             
             // MARK: Armageddons Blade - Conflux
             pasis,
             thunar,
             ignissa,
             lacus,
             monere,
             erdamon,
             fiur,
             kalt,
             luna,
             brissa,
             ciele,
             labetha,
             inteus,
             aenain,
             gelare,
             grindan,
             
             // MARK: Armageddons Blade - Mixed
             
             /// AB: Castle
             sirMullich,
             /// AB: Fortress
             adrienne,
             /// AB: Castle
             catherine,
             /// AB: Tower
             dracon,
             /// AB: Rampart
             gelu,
             /// AB: Stronghold
             kilgor,
             
             /// AB: Necreopolis. A variant of ROE Lord Haart but with red eyes. Only available Armageddon's Blade and Shadow of Death,
             lordHaartTheDeathKnight,
             
             /// AB: Dungeon
             mutare,
             /// AB: Rampart
             roland,
             /// AB: Dungeon
             mutareDrake,
             /// AB: Stronghold
             boragus,
             /// AB: Inferno
             xeron
        
        #if HOTA
        // MARK: Horn Of the Abyss - Cove
        
        /// HotA only
        case corkes,
             /// HotA only
             jeremy,
             /// HotA only
             illor,
             /// HotA only
             derek,
             /// HotA only
             leena,
             /// HotA only
             anabel,
             /// HotA only
             cassiopeia,
             /// HotA only
             miriam,
             /// HotA only
             casmetra,
             /// HotA only
             eovacius,
             /// HotA only
             spint,
             /// HotA only
             andal,
             /// HotA only
             manfred,
             /// HotA only
             zilare,
             /// HotA only
             astra,
             /// HotA only
             dargem,
             /// HotA only
             bidley,
             /// HotA only
             tark,
             /// HotA only
             elmore ,
             /// HotA only
             beatrice,
             /// HotA only
             kinkeria,
             /// HotA only
             ranloo,
             /// HotA only
             giselle
        #endif
    }
}

public extension Hero.ID {
    static func playable(in version: Version) -> [Self] {
        switch version {
        case .restorationOfErathia: return Self.allCases.prefix(while: { $0.rawValue <= Self.tiva.rawValue })
            #if WOG
            case .wakeOfGods: fallthrough
            #endif // WOG
        case .armageddonsBlade, .shadowOfDeath: return Self.allCases
        }
    }
    
    static let restorationOfErathiaPlusConflux: [Self] = {
        let roe = playable(in: .restorationOfErathia)
        return roe + Self.conflux
    }()
}

// MARK: CustomStringConvertible
public extension Hero.ID {
    var description: String {
        switch self {
        
        // Castle
        case .orrin: return "Orrin"
        case .valeska: return "Valeska"
        case .edric: return "Edric"
        case .sylvia: return "Sylvia"
            
        /// Restoration of Erathia
        case .lordHaart: return "Lord Haart"
            
        case .sorsha: return "Sorsha"
        case .christian: return "Christian"
        case .tyris: return "Tyris"
        case .rion: return "Rion"
        case .adela: return "Adela"
        case .cuthbert: return "Cuthbert"
        case .adelaide: return "Adelaide"
        case .ingham: return "Ingham"
        case .sanya: return "Sanya"
        case .loynis: return "Loynis"
        case .caitlin: return "Caitlin"
            
        // Rampart
        case .mephala: return "Mephala"
        case .ufretin: return "Ufretin"
        case .jenova: return "Jenova"
        case .ryland: return "Ryland"
        case .thorgrim: return "Thorgrim"
        case .ivor: return "Ivor"
        case .clancy: return "Clancy"
        case .kyrre: return "Kyrre"
        case .coronius: return "Coronius"
        case .uland: return "Uland"
        case .elleshar: return "Elleshar"
        case .gem: return "Gem"
        case .malcom: return "Malcom"
        case .melodia: return "Melodia"
        case .alagar: return "Alagar"
        case .aeris: return "Aeris"
            
        // Tower
        case .piquedram: return "Piquedram"
        case .thane: return "Thane"
        case .josephine: return "Josephine"
        case .neela: return "Neela"
        case .torosar: return "Torosar"
        case .fafner: return "Fafner"
        case .rissa: return "Rissa"
        case .iona: return "Iona"
        case .astral: return "Astral"
        case .halon: return "Halon"
        case .serena: return "Serena"
        case .daremyth: return "Daremyth"
        case .theodorus: return "Theodorus"
        case .solmyr: return "Solmyr"
        case .cyra: return "Cyra"
        case .aine: return "Aine"
            
        // Inferno
        case .fiona: return "Fiona"
        case .rashka: return "Rashka"
        case .marius: return "Marius"
        case .ignatius: return "Ignatius"
        case .octavia: return "Octavia"
        case .calh: return "Calh"
        case .pyre: return "Pyre"
        case .nymus: return "Nymus"
        case .ayden: return "Ayden"
        case .xyron: return "Xyron"
        case .axsis: return "Axsis"
        case .olema: return "Olema"
        case .calid: return "Calid"
        case .ash: return "Ash"
        case .zydar: return "Zydar"
        case .xarfax: return "Xarfax"
            
        // Necropolis
        case .straker: return "Straker"
        case .vokial: return "Vokial"
        case .moandor: return "Moandor"
        case .charna: return "Charna"
        case .tamika: return "Tamika"
        case .isra: return "Isra"
        case .clavius: return "Clavius"
        case .galthran: return "Galhran"
        case .septienna: return "Septienna"
        case .aislinn: return "Aislinn"
        case .sandro: return "Sandro"
        case .nimbus: return "Nimbus"
        case .thant: return "Thant"
        case .xsi: return "Xsi"
        case .vidomina: return "Vidomina"
        case .nagash: return "Nagash"
            
        // Dungeon
        case .lorelei: return "Lorelei"
        case .arlach: return "Arlach"
        case .dace: return "dace"
        case .ajit: return "Ajit"
        case .damacon: return "Damacon"
        case .gunnar: return "Gunnar"
        case .synca: return "Synca"
        case .shakti: return "Shakti"
        case .alamar: return "Alamar"
        case .jaegar: return "Jaegar"
        case .malekith: return "Malekith"
        case .jeddite: return "Jeddite"
        case .geon: return "Geon"
        case .deemer: return "Deemer"
        case .sephinroth: return "Sephinroth"
        case .darkstorn: return "Darkstorn"
            
        // Stronghold
        case .yog: return "Yog"
        case .gurnisson: return "Gurnisson"
        case .jabarkas: return "Jarkabass"
        case .shiva: return "Shiva"
        case .gretchin: return "Gretchin"
        case .krellion: return "krellion"
        case .cragHack: return "Crag Hack"
        case .tyraxor: return "Tyraxor"
        case .gird: return "Gird"
        case .vey: return "Vey"
        case .dessa: return "Dessa"
        case .terek: return "Terek"
        case .zubin: return "Zubin"
        case .gundula: return "Grundula"
        case .oris: return "Oris"
        case .saurug: return "Saurug"
            
        // Fortress
        case .bron: return "Bron"
        case .drakon: return "Drakon"
        case .wystan: return "Wystan"
        case .tazar: return "Tazar"
        case .alkin: return "Alkin"
        case .korbac: return "Korbac"
        case .gerwulf: return "Gerwulf"
        case .broghild: return "Broghild"
        case .mirlanda: return "Mirlanda"
        case .rosic: return "Rosic"
        case .voy: return "Voy"
        case .verdish: return "Verdish"
        case .merist: return "Merist"
        case .styg: return "Styg"
        case .andra: return "Andra"
        case .tiva: return "Tiva"
            
        // MARK: Armageddons Blade
        
        // Conflux
        case .pasis: return "Pasis"
        case .thunar: return "Thunar"
        case .ignissa: return "Ignissa"
        case .lacus: return "Lacus"
        case .monere: return "Monere"
        case .erdamon: return "Erdamon"
        case .fiur: return "Fiur"
        case .kalt: return "Kalt"
        case .luna: return "Luna"
        case .brissa: return "Brissa"
        case .ciele: return "Ciele"
        case .labetha: return "Labetha"
        case .inteus: return "Inteus"
        case .aenain: return "Aenain"
        case .gelare: return "Gelare"
        case .grindan: return "Grindan"
            
        // Castle
        case .sirMullich: return "Sir Mullich"
            
        // Fortress
        case .adrienne: return "Ardienne"
            
        // Castle
        case .catherine: return "Catherine"
            
        // Tower
        case .dracon: return "Dracon"
            
        // Rampart
        case .gelu: return "Gelu"
            
        // Stronghold
        case .kilgor: return "Kilgor"
            
        // Necropolis
        /// A variant of ROE Lord Haart but with red eyes. Only available Armageddon's Blade and Shadow of Death: return "_____REPLACE____ME_____"
        case .lordHaartTheDeathKnight: return "Lord Haart"
            
        // Dungeon
        case .mutare: return "Mutare"
            
        // Rampart
        case .roland: return "Roland"
            
        // Dungeon
        case .mutareDrake: return "Mutare Drake"
            
        // Stronghold
        case .boragus: return "Boragus"
            
        // Inferno
        case .xeron: return "Xeron"
            
        #if HOTA
        // MARK: Horn Of the Abyss
        case .corkes: return "Corkes"
        case .jeremy: return "Jeremy"
        case .illor: return "Illor"
        case .derek: return "Derek"
        case .leena: return "Leena"
        case .anabel: return "Anabel"
        case .cassiopeia: return "Cassiopeia"
        case .miriam: return "Miriam"
        case .casmetra: return "Casmetra"
        case .eovacius: return "Eovacius"
        case .spint: return "Spint"
        case .andal: return "Andal"
        case .manfred: return "Manfred"
        case .zilare: return "Zilare"
        case .astra: return "Astra"
        case .dargem: return "Dargem"
        case .bidley: return "Bidley"
        case .tark: return "Tark"
        case .elmore : return "Elmore"
        case .beatrice: return "Beatrice"
        case .kinkeria: return "Kinkeria"
        case .ranloo: return "Ranloo"
        case .giselle: return "Giselle"
        #endif
        }
    }
}
