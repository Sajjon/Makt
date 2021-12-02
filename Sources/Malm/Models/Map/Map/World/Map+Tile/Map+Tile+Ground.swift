//
//  Map+Tile+Terrain.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map.Tile {
    struct Ground: TileLayer, CustomDebugStringConvertible, Codable {
        
        enum CodingKeys: String, CodingKey {
            case terrain, mirroring, frameIndex
        }
        
        static let defaultTerrain: Map.Terrain = .water
        private static let defaultTerrainLowerLevel: Map.Terrain = .subterranean
        private static let defaultTerrainUpperLevel: Map.Terrain = .water
        
        public static func `default`(isLowerLevel: Bool) -> Ground {
            .init(
                terrain: isLowerLevel ? Self.defaultTerrainLowerLevel : Self.defaultTerrainUpperLevel,
                mirroring: .identity,
                frameIndex: Self.defaultFrameIndex
            )
        }
        static let `default` = Self.default(isLowerLevel: false)
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            if mirroring != .identity {
                try container.encode(mirroring, forKey: .mirroring)
            }
            if terrain != Self.defaultTerrain {
                try container.encode(terrain, forKey: .terrain)
            }
            
            if frameIndex != Self.defaultFrameIndex {
                try container.encode(frameIndex, forKey: .frameIndex)
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.mirroring = try container.decodeIfPresent(Mirroring.self, forKey: .mirroring) ?? .identity
            self.terrain = try container.decodeIfPresent(Map.Terrain.self, forKey: .terrain) ?? .water
            self.frameIndex = try container.decodeIfPresent(Int.self, forKey: .frameIndex) ?? Self.defaultFrameIndex
        }
        
        public static let layerKind: TileLayerKind = .ground
        public let terrain: Map.Terrain
        
        public let mirroring: Mirroring
        
        static let defaultFrameIndex: Int = 0
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


