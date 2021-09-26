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
        
        /// The rawValue of the rotation is the index of the `block` within the `.def` file.
        /// The block might contain many `frames` and the `defFileFrameIndexWithinRotationBlock`
        /// property below is the `frameIndex` within this block.
        public let rotation: Rotation
        
        /// Index of frame within block, indexed by `rotation` above.
        public let defFileFrameIndexWithinRotationBlock: UInt8
        
        public init(
            kind: Kind,
            rotation: Rotation,
            defFileFrameIndexWithinRotationBlock: UInt8
        ) {
            self.kind = kind
            self.rotation = rotation
            self.defFileFrameIndexWithinRotationBlock = defFileFrameIndexWithinRotationBlock
        }
    }
}


public extension Map.Tile.Terrain {
    var debugDescription: String {
        """
        kind: \(kind)
        rotation: \(rotation)
        defFileFrameIndexWithinRotationBlock: \(defFileFrameIndexWithinRotationBlock)
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
