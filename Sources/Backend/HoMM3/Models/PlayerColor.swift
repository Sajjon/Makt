//
//  PlayerColor.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public extension Comparable where Self: RawRepresentable, Self.RawValue: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

public enum PlayerColor: UInt8, Comparable, CaseIterable, CustomStringConvertible {

    
    case red, blue, tan, green, orange, purple, teal, pink
    
    public static let neutralRawValue: RawValue = 0xff
}

public extension PlayerColor {
    var description: String {
        switch self {
        case .red: return "red"
        case .blue: return "blue"
        case .tan: return "tan"
        case .green: return "green"
        case .orange: return "orange"
        case .purple: return "purple"
        case .teal: return "teal"
        case .pink: return "pink"
        }
    }
}
