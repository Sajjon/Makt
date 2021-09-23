//
//  Map+Tile+Rotation.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map.Tile {
    
    /// The rotation or mirroring of squares.
    ///
    /// Not to be confused with `Direction`.
    /// 
    /// TODO ASSERT CORRECT rawValue. this is A GUESS from Cyons cide
    enum Rotation: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
        case identity, clockwise90, rotation180, counterClockwise90
    }
}

public extension Map.Tile.Rotation {
    var debugDescription: String {
        switch self {
        case .identity: return "identity"
        case .clockwise90: return "clockwise90"
        case .rotation180: return "rotation180"
        case .counterClockwise90: return "counterClockwise90"
        }
    }
}
