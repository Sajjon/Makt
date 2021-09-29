//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-23.
//

import Foundation
import Util

public struct ProcessedMap: Hashable {
    private let map: Map
    public let aboveGroundTiles: [Tile]
    public let undergroundTiles: [Tile]?
    
    public init(
        map: Map,
        aboveGroundTiles: [Tile],
        undergroundTiles: [Tile]?
    ) {
        self.map = map
        self.aboveGroundTiles = aboveGroundTiles
        self.undergroundTiles = undergroundTiles
    }
}

public extension ProcessedMap {
    var size: Size {
        map.basicInformation.size
    }
    
    var width: Size.Scalar { size.width }
}

// MARK: Tile
public extension ProcessedMap {
    struct Tile: Hashable {
        public let position: Position
        private let mapTile: Map.Tile
        public let objects: [Map.Object]?
        private let groundImage: GroundImage
        
        public let images: [AnyCachedImage]
        
        public init(
            mapTile: Map.Tile,
            groundImage: GroundImage,
            riverImage: RiverImage?,
            roadImage: RoadImage?,
            objects: [Map.Object]?
        ) {
            self.position = mapTile.position
            self.groundImage = groundImage
            self.mapTile = mapTile
            self.objects = objects
            self.images = [
                AnyCachedImage(groundImage),            // index 0: ground terrain image (always present)
                riverImage.map { AnyCachedImage($0) },  // index 1: river image (sometimes present)
                roadImage.map { AnyCachedImage($0) }    // index 2: road image (sometimes present)
            ].filterNils()
        }
    }
}

public extension ProcessedMap.Tile {
    var terrain: Map.Terrain {
        mapTile.ground.terrain
    }
    
    var emojiString: String {
        mapTile.emojiString
    }
}
