//
//  Version.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public enum Version: String, Hashable, Comparable {
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
    
    #if WOG
    /// The community expansion "Wake of Gods", aka WOG
    case wakeOfGods
    #endif // WOG
}

// MARK: Error
public extension Version {
    enum Error: Swift.Error {
        case unrecognizedVersion(RawVersionValue)
    }
}

// MARK: Init
public extension Version {
    init(id rawValue: RawVersionValue) throws {
        guard let rawFormat = RawVersion(rawValue: rawValue) else { throw Error.unrecognizedVersion(rawValue) }
        switch rawFormat {
        case .restorationOfErathia: self = .restorationOfErathia
        case .armageddonsBlade: self = .armageddonsBlade
        case .shadowOfDeath: self = .shadowOfDeath
            #if HOTA
        case .hornOfTheAbyss_1, .hornOfTheAbyss_2, .hornOfTheAbyss_3: self = .hornOfTheAbyss
            #endif // HOTA
        
        #if WOG
        case .wakeOfGods: self = .wakeOfGods
        #endif //  WOG
        
        #if VCMI
        case .vcmi: fatalError("VCMI not supported")
        #endif // VCMI
        }
    }
}



// MARK: Comparable
public extension Version {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.id < rhs.id
    }
}

// MARK: RawVersion

public extension Version {
    typealias RawVersionValue = UInt32
}

private enum RawVersion: Version.RawVersionValue, Comparable {
    
    case restorationOfErathia = 0x0e // 14
    
    case armageddonsBlade  = 0x15 // 0d21
    
    case shadowOfDeath = 0x1c // 0d28
    
    #if HOTA
    case hornOfTheAbyss_1 = 0x1e // 0d28
    case hornOfTheAbyss_2 = 0x1f // 0d29
    case hornOfTheAbyss_3 = 0x20 // 0d30
    #endif // HOTA
    
    #if WOG
    case wakeOfGods = 0x33  // 0d51
    #endif // WOG
    
    #if VCMI
    case vcmi = 0xF0 // 0d256
    #endif // VCMI
}

private extension Version {
    var id: RawVersion {
        switch self {
        case .restorationOfErathia: return .restorationOfErathia
        case .armageddonsBlade: return .armageddonsBlade
        case .shadowOfDeath: return .shadowOfDeath
        #if HOTA
        case .hornOfTheAbyss: return .hornOfTheAbyss_1
        #endif // HOTA
        
        #if WOG
        case .wakeOfGods: return .wakeOfGods
        #endif //  WOG
        }
    }
}
