//
//  Map+Object+KeyColor.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation

public enum KeyColor: UInt8, Equatable, CaseIterable, CustomDebugStringConvertible {
   case lightBlue
   case playerFour
   case playerOne
   case darkBlue
   case brown
   case playerSix
   case white
   case black
}

public extension Map.Object {
    typealias BorderGuardTentType = KeyColor
    typealias KeymastersTentType = KeyColor
}

public extension KeyColor {
    var debugDescription: String {
        switch self {
        case .lightBlue: return "lightBlue"
        case .playerFour: return "playerFour"
        case .playerOne: return "playerOne"
        case .darkBlue: return "darkBlue"
        case .brown: return "brown"
        case .playerSix: return "playerSix"
        case .white: return "white"
        case .black: return "black"
        }
    }
}
