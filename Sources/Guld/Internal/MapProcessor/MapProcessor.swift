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
    public init() {}
}

public extension MapProcessor {
    func process(map: Map) -> AnyPublisher<ProcessedMap, Never> {
        return Future<ProcessedMap, Never> { promise in
            DispatchQueue.init(label: "ProcessMap", qos: .background).async {
                print("✨ Processing map \"\(map.basicInformation.name)\"")
                let start = CFAbsoluteTimeGetCurrent()
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
                
                func tilesAt(level: Map.Level) -> [ProcessedMap.Tile] {
                    let mapTiles = level.tiles
                    return mapTiles.map { mapTile in
                        ProcessedMap.Tile(
                            mapTile: mapTile,
                            objects: objects(at: mapTile.position)
                        )
                    }
                }
                
                let aboveGroundTiles = tilesAt(level: map.world.above)
                assert(aboveGroundTiles.count == map.basicInformation.size.tileCount)
                let undergroundTiles = map.world.underground.map {
                    tilesAt(level: $0)
                }
                
                let processedMap = ProcessedMap(
                    map: map,
                    aboveGroundTiles: aboveGroundTiles,
                    undergroundTiles: undergroundTiles
                )
                
                let diff = CFAbsoluteTimeGetCurrent() - start
                print(String(format: "✨✅ Successfully processed for map '%@', took %.1f seconds", map.basicInformation.name, diff))
                
                promise(.success(processedMap))
            }
        }
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

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
