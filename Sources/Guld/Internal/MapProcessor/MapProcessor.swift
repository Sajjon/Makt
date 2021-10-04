//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-23.
//

import Foundation
import Combine
import Malm

public final class MapProcessor {
    private let assets: Assets
    public init(assets: Assets) {
        self.assets = assets
    }
}

// MARK: Public
public extension MapProcessor {
    func process(map: Map) throws -> ProcessedMap {
        print("✨ Processing map \"\(map.basicInformation.name)\"")
        let start = CFAbsoluteTimeGetCurrent()
        let groundImagesForTiles = try loadGroundImagesForTiles(in: map)
        let riverImagesForTiles = try loadRiverImagesForTiles(in: map)
        let roadImagesForTiles = try loadRoadImagesForTiles(in: map)
        let imageForObjects = try loadObjectImageForObjects(in: map)
        assert(map.world.above.tiles.count == map.basicInformation.size.tileCount)
        
        var positionToObjects: [Position: Objects] = [:]
        map.detailsAboutObjects.objects.forEach { object in
            let position = object.position
            if let objects = positionToObjects[position] {
                objects.add(object: object)
            } else {
                positionToObjects[position] = .init(object: object)
            }
        }
        
        func objects(at position: Position) -> [Map.Object]? {
            positionToObjects[position]?.objects
        }
        
        func groundImage(at tile: Map.Tile) -> GroundImage {
            guard let image = groundImagesForTiles[tile] else {
                fatalError("Expected to always have a ground image.")
            }
            return image
        }
        
        func riverImage(at tile: Map.Tile) -> RiverImage? {
            guard let images = riverImagesForTiles else {
                return nil
            }
            return images[tile]
        }
        
        func roadImage(at tile: Map.Tile) -> RoadImage? {
            guard let images = roadImagesForTiles else {
                return nil
            }
            return images[tile]
        }
        
        func tilesAt(level: Map.Level) -> [ProcessedMap.Tile] {
            return level.tiles.map { tile in
                ProcessedMap.Tile(
                    mapTile: tile,
                    groundImage: groundImage(at: tile),
                    riverImage: riverImage(at: tile),
                    roadImage: roadImage(at: tile)
                )
            }
        }
        
        let aboveGroundTiles = tilesAt(level: map.world.above)
        assert(aboveGroundTiles.count == map.basicInformation.size.tileCount)
//        let undergroundTiles = map.world.underground.map {
//            tilesAt(level: $0)
//        }
        
        let aboveGroundObjects: [ProcessedMap.Object] = positionToObjects.filter { $0.key.inUnderworld == false }.flatMap {
            return $0.value.objects.map { (mapObject: Map.Object) in
                return ProcessedMap.Object(
                    mapObject: mapObject,
                    image: imageForObjects[mapObject.attributes.sprite]!
                )
            }
        }
        
        let aboveGround: ProcessedMap.Level = .init(tiles: aboveGroundTiles, objects: aboveGroundObjects, isUnderground: false)
        
        let processedMap = ProcessedMap(
            map: map,
            aboveGround: aboveGround
        )
        
        let diff = CFAbsoluteTimeGetCurrent() - start
        print(String(format: "✨✅ Successfully processed for map '%@', took %.1f seconds", map.basicInformation.name, diff))
        
        return processedMap
    }
}

// MARK: Private
private extension MapProcessor {
    
    func _loadImagesForTile<K: DrawableTileLayer>(
        in map: Map,
        keyForTile: (Map.Tile) -> K?
    ) throws -> [Map.Tile: CachedImage<K>] {
        
        let tiles = map.world.above.tiles + (map.world.underground?.tiles ?? [])
        
        return Dictionary(uniqueKeysWithValues: try tiles.compactMap { tile in
            guard let key = keyForTile(tile) else {
                return nil
            }
            let image = try assets.loadImage(for: key)
            return (key: tile, value: image)
        })
    }
    
    func _loadImagesForTile<K: DrawableTileLayer>(in map: Map, keyBy keyKeyPath: KeyPath<Map.Tile, K>) throws -> [Map.Tile: CachedImage<K>] {
        try _loadImagesForTile(in: map, keyForTile: { $0[keyPath: keyKeyPath] }  )
    }
    
    func _loadImagesForTile<K: DrawableTileLayer>(in map: Map, maybeKey keyKeyPath: KeyPath<Map.Tile, K?>) throws -> [Map.Tile: CachedImage<K>] {
        try _loadImagesForTile(in: map, keyForTile: { $0[keyPath: keyKeyPath] }  )
    }
    
    func loadGroundImagesForTiles(in map: Map) throws -> [Map.Tile: GroundImage] {
        try _loadImagesForTile(in: map, keyBy: \.ground)
    }
    
    func loadRiverImagesForTiles(in map: Map) throws -> [Map.Tile: RiverImage]? {
        guard case let cache = try _loadImagesForTile(in: map, maybeKey: \.river), !cache.isEmpty else {
            return nil
        }
        return cache
    }
    
    func loadRoadImagesForTiles(in map: Map) throws -> [Map.Tile: RoadImage]? {
        guard case let cache = try _loadImagesForTile(in: map, maybeKey: \.road), !cache.isEmpty else {
            return nil
        }
        return cache
    }
    
    func loadObjectImageForObjects(in map: Map) throws -> [Sprite: ObjectImage] {
        Dictionary<Sprite, ObjectImage>(try map.detailsAboutObjects.objects.compactMap { object in
            let key = object.attributes.sprite
            return (key: key, value: try assets.loadImage(sprite: key))
        }, uniquingKeysWith: { (first, _) in first })
    }
}

// MARK: Objects Storage
private extension MapProcessor {
    
    /// Helper class to construct a list of objects at a certain position,
    /// reference semantics makes this easier.
    final class Objects {
        internal private(set) var objects = [Map.Object]()
        init(object: Map.Object) {
            self.objects = [object]
        }
        func add(object: Map.Object) {
            objects.append(object)
        }
    }
}
