//
//  Hero+ID.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Hero {
    
    /// https://heroes.thelazy.net/index.php/Most_powerful_hero_(campaign)
    enum ID: UInt8, Hashable {
       case orrin,
            valeska,
            edric,
            sylvia,

            /// Restoration of Erathia
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

            // MARK: Armageddons Blade
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
            sirMullich,
            adrienne,
            catherine,
            dracon,
            gelu,
            kilgor,

            /// A variant of ROE Lord Haart but with red eyes. Only available Armageddon's Blade and Shadow of Death,
            lordHaartTheDeathKnight,

            mutare,
            roland,
            mutareDrake,
            boragus,
            xeron

            // MARK: Horn Of the Abyss
        
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
    }
}
