//
//  Map+Format.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public extension Map {
    
    enum Format: String, Comparable {
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.id < rhs.id
        }
        
        
        /// The original game, without any expansion pack, aka "ROE"
        case restorationOfErathia
        
        /// The expansion "Armageddon's Blade", aka AB
        case armageddonsBlade
        
        /// The expansion "The Shadow of Death", aka SOD
        case shadowOfDeath
        
        #if HOTA
        /// The community expansion "Horn of the Abyss", aka HOTA
        case hornOfTheAbyss
        #endif // HOTA
        
        /// The community expansion "Wake of Gods", aka WOG
        case wakeOfGods
        
        public typealias RawFormatValue = UInt32
        
        public enum Error: Swift.Error {
            case unrecognizedFormat(RawFormatValue)
        }
        
        public init(id rawValue: RawFormatValue) throws {
            guard let rawFormat = RawFormat(rawValue: rawValue) else { throw Error.unrecognizedFormat(rawValue) }
            switch rawFormat {
            case .restorationOfErathia: self = .restorationOfErathia
            case .armageddonsBlade: self = .armageddonsBlade
            case .shadowOfDeath: self = .shadowOfDeath
                #if HOTA
            case .hornOfTheAbyss_1, .hornOfTheAbyss_2, .hornOfTheAbyss_3: self = .hornOfTheAbyss
                #endif // HOTA
            case .wakeOfGods: self = .wakeOfGods
            case .vcmi: fatalError("VCMI not supported")
            }
        }
        
        private var id: RawFormat {
            switch self {
            case .restorationOfErathia: return .restorationOfErathia
            case .armageddonsBlade: return .armageddonsBlade
            case .shadowOfDeath: return .shadowOfDeath
            #if HOTA
            case .hornOfTheAbyss: return .hornOfTheAbyss_1
            #endif // HOTA
            case .wakeOfGods: return .wakeOfGods
            }
        }
    }
}

private enum RawFormat: Map.Format.RawFormatValue, Comparable {
    
    case restorationOfErathia = 0x0e // 14
    
    case armageddonsBlade  = 0x15 // 0d21
    
    case shadowOfDeath = 0x1c // 0d28
    
    #if HOTA
    case hornOfTheAbyss_1 = 0x1e // 0d28
    case hornOfTheAbyss_2 = 0x1f // 0d29
    case hornOfTheAbyss_3 = 0x20 // 0d30
    #endif // HOTA
    
    case wakeOfGods = 0x33  // 0d51
    case vcmi = 0xF0 // 0d256
}
