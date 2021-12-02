//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-29.
//

import Foundation

/// MARK: Terrain
public extension Map {
    enum Terrain: UInt8, Hashable, CustomDebugStringConvertible, CaseIterable, Codable {
        case dirt, sand, grass, snow, swamp, rough, subterranean, lava, water, rock
    }
}

public extension Map.Terrain {
    var debugDescription: String {
        name
    }
    
    var name: String {
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
