//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-23.
//

import Foundation

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
        public let surfaceImage: LoadedTerrainImage
        
        public init(
            mapTile: Map.Tile,
            surfaceImage: LoadedTerrainImage,
            objects: [Map.Object]?
        ) {
            self.position = mapTile.position
            self.surfaceImage = surfaceImage
            self.mapTile = mapTile
            self.objects = objects
        }
    }
}

public extension ProcessedMap.Tile {
    var terrain: Map.Tile.Terrain {
        mapTile.terrain
    }
    
    var emojiString: String {
        mapTile.emojiString
    }
}
