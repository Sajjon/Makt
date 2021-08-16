//
//  Map+Format.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public extension Map {
    
    enum Format: UInt32, Equatable {
        
        /// A "well known"/standardized unique header number idenitfying a file as a "gzip" file.
        ///
        /// Source1: https://github.com/vcmi/vcmi/blob/develop/lib/mapping/CMapService.cpp#L105
        /// Source2: https://github.com/brgl/busybox/blob/master/archival/gzip.c#L2081
        /// Source3: https://stackoverflow.com/a/33378248/1311272
        /// Source4: https://zenhax.com/viewtopic.php?p=62470#p62470
        case gzip = 0x00088b1f
        
        /// The original game, without any expansion pack, aka "ROE"
        case restorationOfErathia = 0x0e // 14
        
        /// The expansion "Armageddon's Blade", aka AB
        case armageddonsBlade  = 0x15 // 0d21
        
        /// The expansion "The Shadow of Death", aka SOD
        case shadowOfDeath = 0x1c // 0d28
        
        /// The community expansion "Horn of the Abyss", aka HOTA, identifier of HOTA 1/3
        case hornOfTheAbyss_1 = 0x1e // 0d28
        /// The community expansion "Horn of the Abyss", aka HOTA, identifier of HOTA 2/3
        case hornOfTheAbyss_2 = 0x1f // 0d29
        /// The community expansion "Horn of the Abyss", aka HOTA, identifier of HOTA 3/3
        case hornOfTheAbyss_3 = 0x20 // 0d30
        
        /// The community expansion "Wake of Gods", aka WOG
        case wakeOGods = 0x33  // 0d51
        
        /// The community re-implementation "VCMI".
        case vcmi = 0xF0 // 0d256
    }
}
