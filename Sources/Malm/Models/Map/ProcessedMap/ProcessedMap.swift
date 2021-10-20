//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-23.
//

import Foundation
import Common

public struct ProcessedMap: Hashable {
    private let map: Map
    public let aboveGround: Level
    public let underground: Level?
    
    public init(
        map: Map,
        aboveGround: Level,
        underground: Level? = nil
    ) {
        self.map = map
        self.aboveGround = aboveGround
        self.underground = underground
    }
}

public extension ProcessedMap {
    var size: Size {
        map.basicInformation.size
    }
    
    var width: Size.Scalar { size.width }
}

// MARK: Level
public extension ProcessedMap {
    struct Level: Hashable {
        public let tiles: [Tile]
        public let objects: [Object]
        public let isUnderground: Bool
        
        public init(tiles: [Tile], objects: [Object], isUnderground: Bool = false) {
            self.tiles = tiles
            self.objects = objects // not sorted by Z
            self.isUnderground = isUnderground
        }
    }
}

// MARK: Tile
public extension ProcessedMap {
    struct Tile: Hashable {
        public let position: Position
        public let mapTile: Map.Tile
        
        public let images: [AnyCachedImage]

        public init(
            mapTile: Map.Tile,
            groundImage: GroundImage,
            riverImage: RiverImage?,
            roadImage: RoadImage?
        ) {
            self.position = mapTile.position
            self.mapTile = mapTile
 
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

// MARK: Object
public extension ProcessedMap {
    struct Object: Hashable, RenderZAxisIndexing {
        
        /// The kind of object this wrapper wraps.s
        public let mapObject: Map.Object

        /// Image of map object
        public let image: ObjectImage
        
        public init(
            mapObject: Map.Object,
            image: ObjectImage
        ) {
            self.mapObject = mapObject
            self.image = image
        }
    }
}

public extension ProcessedMap.Object {
    /// Number of tiles this object occupies, i.e. `width * height`.
    var size: Position.Scalar { width * height }
    
    /// Top most left most coordinate of the object
    var position: Position { mapObject.position }
    
    /// How many tile columns this object occupies.
    var width: Position.Scalar { mapObject.width }
    
    /// How many tile rows this object occupies.
    var height: Position.Scalar { mapObject.height }
    
    var zAxisIndex: Int {
        mapObject.attributes.zAxisRenderingPriority
    }
}

public extension CGFloat {
    static let pixelsPerTile = Self(Image.pixelsPerTile)
}
