//
//  Map+Format.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public extension Map {
    
    enum Format: String, Equatable {
        
        /// The original game, without any expansion pack, aka "ROE"
        case restorationOfErathia
        
        /// The expansion "Armageddon's Blade", aka AB
        case armageddonsBlade
        
        /// The expansion "The Shadow of Death", aka SOD
        case shadowOfDeath
        
        /// The community expansion "Horn of the Abyss", aka HOTA
        case hornOfTheAbyss
        
        /// The community expansion "Wake of Gods", aka WOG
        case wakeOfGods
        
        public init?(id rawValue: UInt32) {
            guard let rawFormat = RawFormat(rawValue: rawValue) else { return nil }
            switch rawFormat {
            case .restorationOfErathia: self = .restorationOfErathia
            case .armageddonsBlade: self = .armageddonsBlade
            case .shadowOfDeath: self = .shadowOfDeath
            case .hornOfTheAbyss_1, .hornOfTheAbyss_2, .hornOfTheAbyss_3: self = .hornOfTheAbyss
            case .wakeOfGods: self = .wakeOfGods
            case .vcmi: fatalError("VCMI not supported")
            }
        }
    }
}

private enum RawFormat: UInt32, Equatable {
    
    case restorationOfErathia = 0x0e // 14
    
    case armageddonsBlade  = 0x15 // 0d21
    
    case shadowOfDeath = 0x1c // 0d28
    
    case hornOfTheAbyss_1 = 0x1e // 0d28
    case hornOfTheAbyss_2 = 0x1f // 0d29
    case hornOfTheAbyss_3 = 0x20 // 0d30
    
    case wakeOfGods = 0x33  // 0d51
    case vcmi = 0xF0 // 0d256
}
