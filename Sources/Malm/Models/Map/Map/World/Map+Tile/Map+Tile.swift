//
//  Map+Tile.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation
import Common

public extension Map {
    struct Tile: Hashable, CustomDebugStringConvertible, Codable {
        
        enum CodingKeys: String, CodingKey {
            case ground, river, road, isCoastal, hasFavourableWindEffect = "wind", waterGroundWithFrameIndex = "w"
        }
        
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let waterWithIndex = try container.decodeIfPresent(Int.self, forKey: .waterGroundWithFrameIndex) {
                self.ground = .init(terrain: .water, mirroring: .identity, frameIndex: waterWithIndex)
            } else {
                self.ground = try container.decodeIfPresent(Ground.self, forKey: .ground) ?? .default
            }
            
            self.river = try container.decodeIfPresent(River.self, forKey: .river)
            self.road = try container.decodeIfPresent(Road.self, forKey: .road)
            /* We will derive position from index in [Tile] array in Level  */
            self._position = nil
            self.isCoastal = try container.decodeIfPresent(Bool.self, forKey: .isCoastal) ?? false
            self.hasFavourableWindEffect = try container.decodeIfPresent(Bool.self, forKey: .hasFavourableWindEffect) ?? false
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            if ground != .default {
                try container.encode(ground, forKey: .ground)
            } else if ground.terrain == Ground.defaultTerrain && ground.mirroring == .identity {
                assert(ground.frameIndex != Ground.defaultFrameIndex)
                try container.encode(ground.frameIndex, forKey: .waterGroundWithFrameIndex)
            }
            try container.encodeIfPresent(river, forKey: .river)
            try container.encodeIfPresent(road, forKey: .road)
            /* We skip encoding `position` since it can be derived from index in [Tile] array in Level */
            
            if isCoastal {
                try container.encode(isCoastal, forKey: .isCoastal)
            }
            
            if hasFavourableWindEffect {
                try container.encode(hasFavourableWindEffect, forKey: .hasFavourableWindEffect)
            }
        }

        public var position: Position { _position! }
        
        internal private(set) var _position: Position!
        
        internal func withPosition(_ position: Position) -> Self {
            var copy = self
            copy._position = position
            return copy
        }
        
        public let ground: Ground 
        
        public let river: River?
        public let road: Road?
        
        /// Whether tile is coastal (allows disembarking if land or block movement if water)
        public private(set) var isCoastal: Bool
        
        /// If water tile, then we might have greater speed with our boats thanks to favourable winds.
        public private(set) var hasFavourableWindEffect: Bool
        
        public init(
            position: Position,
            ground: Ground,
            river: River? = nil,
            road: Road? = nil,
            isCoastal: Bool,
            hasFavourableWindEffect: Bool
        ) {
            self._position = position
            self.ground = ground
            self.river = river
            self.road = road
            self.isCoastal = isCoastal
            self.hasFavourableWindEffect = hasFavourableWindEffect
        }
    }
}

public extension Map.Tile {
    var debugDescription: String {
        let optionalStrings: [String?] = [
            "position: \(position)",
            "ground: \(ground)",
            river.map { "river: \($0)" },
            road.map { "road: \($0)" },
            "isCoastal: \(isCoastal)",
            "hasFavourableWind: \(hasFavourableWindEffect)"
        ]
        
        return optionalStrings.filterNils().joined(separator: "\n")
   
    }
}
