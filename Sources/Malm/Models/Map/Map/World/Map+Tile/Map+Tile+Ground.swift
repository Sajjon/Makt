//
//  Map+Tile+Terrain.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map.Tile {
    struct Ground: TileLayer, CustomDebugStringConvertible, Codable {
        public static let layerKind: TileLayerKind = .ground
        public let terrain: Map.Terrain
        
        public let mirroring: Mirroring
        
        public let frameIndex: Int
        
        public init(
            terrain: Map.Terrain,
            mirroring: Mirroring,
            frameIndex: Int
        ) {
            self.terrain = terrain
            self.mirroring = mirroring
            self.frameIndex = frameIndex
        }
    }
}


public extension Map.Tile.Ground {
    var zAxisIndex: Int { 0 }
    var debugDescription: String {
        """
        terrain: \(terrain)
        mirroring: \(mirroring)
        frameIndex: \(frameIndex)
        """
    }
}

public extension Map.Tile.Ground {
    var isBlocked: Bool { terrain == .rock }
}


