//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-28.
//

import Foundation

// MARK: CachedImage
public struct CachedImage<Key: Hashable>: CacheableImage, Identifiable, Hashable {
    public let key: Key
    public let image: Image
    public init(key: Key, image: Image) {
        self.key = key
        self.image = image
    }
}

public extension CachedImage {
    typealias ID = Key
    var id: ID { key }
}

// MARK: Cached Images
public typealias GroundImage = CachedImage<Map.Tile.Ground>
public typealias RoadImage = CachedImage<Map.Tile.Road>
public typealias RiverImage = CachedImage<Map.Tile.River>
