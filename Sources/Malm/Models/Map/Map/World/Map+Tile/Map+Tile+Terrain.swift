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
        
        public init(
            kind: Kind,
            viewID: ViewID,
            rotation: Rotation
        ) {
            self.kind = kind
            self.viewID = viewID
            self.rotation = rotation
        }
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
    enum Kind: UInt8, Hashable, CustomDebugStringConvertible, CaseIterable {
        case dirt, sand, grass, snow, swamp, rough, subterranean, lava, water, rock
    }
}

/// MARK: ViewID (Surface)
public extension Map.Tile.Terrain {
    
    /// ID for a view to be rendered as a surface.
    struct ViewID: Equatable {
        public let view: UInt8
        
        public init(view: UInt8) {
            self.view = view
        }
    }
}
