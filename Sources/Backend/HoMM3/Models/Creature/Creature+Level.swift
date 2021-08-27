//
//  Creature+Level.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation

public extension Creature {
    enum Level: UInt8, Comparable, CaseIterable, CustomDebugStringConvertible {
        
        case one = 0
        case two
        case three
        case four
        case five
        case six
        case seven
        #if WOG
        case eight
        #endif // WOG
    }
}

public extension Creature.Level {
    var debugDescription: String {
        switch self {
        case .one: return "level1"
        case .two: return "level2"
        case .three: return "level3"
        case .four: return "level4"
        case .five: return "level5"
        case .six: return "level6"
        case .seven: return "level7"
        #if WOG
        case .eight: return "level8"
        #endif // WOG
        }
    }
    
}
