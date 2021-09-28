//
//  Map+Tile+Terrain.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map.Tile {
    struct Terrain: Hashable, CustomDebugStringConvertible {
        public let kind: Kind
        
        public let mirroring: Mirroring
        
        public typealias ViewID = UInt8
        public let viewID: ViewID
        
        public init(
            kind: Kind,
            mirroring: Mirroring,
            viewID: ViewID
        ) {
            self.kind = kind
            self.mirroring = mirroring
            self.viewID = viewID
        }
    }
}


public extension Map.Tile.Terrain {
    var debugDescription: String {
        """
        kind: \(kind)
        mirroring: \(mirroring)
        viewID: \(viewID)
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
