//
//  Map+Tile+Terrain.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map.Tile {
    struct Terrain: Equatable, CustomDebugStringConvertible {
        public let kind: Kind
        public let viewID: ViewID
        public let rotation: Rotation
    }
}


public extension Map.Tile.Terrain {
    var debugDescription: String {
        """
        kind: \(kind)
        viewID: \(viewID.view)
        rotation: \(rotation)
        """
    }
}

public extension Map.Tile.Terrain {
    var isBlocked: Bool { kind == .rock }
}

public extension Map.Tile.Terrain.Kind {
    var debugDescription: String {
        switch self {
        case .dirt: return "dirt"
        case .sand: return "sand"
        case .grass: return "grass"
        case .snow: return "snow"
        case .swamp: return "swamp"
        case .rough: return "rough"
        case .subterranean: return "subterranean"
        case .lava: return "lava"
        case .water: return "water"
        case .rock: return "rock"
        }
    }
}

/// MARK: Kind
public extension Map.Tile.Terrain {
    enum Kind: UInt8, Equatable, CustomDebugStringConvertible, CaseIterable {
        case dirt, sand, grass, snow, swamp, rough, subterranean, lava, water, rock
    }
}

/// MARK: Surface
public extension Map.Tile.Terrain {
    
    struct ViewID: Equatable {
        public let view: UInt8
    }
}
