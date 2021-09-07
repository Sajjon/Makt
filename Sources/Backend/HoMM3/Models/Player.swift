//
//  Player.swift
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


public enum Player: UInt8, Comparable, CaseIterable, CustomDebugStringConvertible, ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = UInt8
    
    /// `1` is `playerOne`, `2` is `playerTwo` etc, i.e. `0` does not exist.
    public init(integerLiteral value: IntegerLiteralType) {
        try! self.init(integer: value - 1)
    }

    
    case playerOne, playerTwo, playerThree, playerFour, playerFive, playerSix, playerSeven, playerEight
    
    public static let neutralRawValue: RawValue = 0xff
}


public extension Player {
    
    enum Color: Hashable, CustomDebugStringConvertible {
        case red, blue, tan, green, orange, purple, teal, pink
        
        public var debugDescription: String {
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
    
    var color: Color {
        switch self {
        case .playerOne: return .red
        case .playerTwo: return .blue
        case .playerThree: return .tan
        case .playerFour: return .green
        case .playerFive: return .orange
        case .playerSix: return .purple
        case .playerSeven: return .teal
        case .playerEight: return .pink
        }
    }
    
    static let red: Self = .playerOne
    static let blue: Self = .playerTwo
    static let tan: Self = .playerThree
    static let green: Self = .playerFour
    static let orange: Self = .playerFive
    static let purple: Self = .playerSix
    static let teal: Self = .playerSeven
    static let pink: Self = .playerEight
    
    var debugDescription: String {
        switch self {
        case .playerOne: return "playerOne"
        case .playerTwo: return "playerTwo"
        case .playerThree: return "playerThree"
        case .playerFour: return "playerFour"
        case .playerFive: return "playerFive"
        case .playerSix: return "playerSix"
        case .playerSeven: return "playerSeven"
        case .playerEight: return "playerEight"
        }
    }
}
