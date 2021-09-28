//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-25.
//

import Foundation

public final class LoadedTerrainImage: CachedImage, Hashable, Identifiable, CustomDebugStringConvertible {
    public typealias Key = Map.Tile.Terrain
    public let key: Key
    public let image: Image
    
    public init(key: Key, image: Image) {
        self.key = key
        self.image = image
    }
}

public extension LoadedTerrainImage {
    var terrain: Map.Tile.Terrain { key }
}

// MARK: Equatable
public extension LoadedTerrainImage {
    static func == (lhs: LoadedTerrainImage, rhs: LoadedTerrainImage) -> Bool {
        if lhs.terrain == rhs.terrain {
            assert(lhs.image == rhs.image)
            return true
        } else {
            assert(lhs.image != rhs.image)
            return false
        }
    }
}

// MARK: Hashable
public extension LoadedTerrainImage {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: CustomDebugStringConvertible
public extension LoadedTerrainImage {
    var debugDescription: String {
        """
        terrain: \(String(describing: terrain))
        image: \(String(describing: image))
        """
    }
}
