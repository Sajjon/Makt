//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

/// NOT USED (yet)
/// Here follows some ides on how to more effectively represent a map, here called "Scenario"
/// in JSON format. The idea is that we want to avoid DUPLICATION of long arrays with sparse objects
/// in Map format parse from H3M (Malm.Map) we have store ObjectAttributes twice, and we store separate arrays for
/// World.Tiles and ObjectDetails. Down below we put the the ObjectDetails inside the tile(s). And of
/// course we use the very efficient optimization of not encoding position in tiles, but rather
/// derive it from the tile's index inside the tile array. The solution is just a POC but seems promising
/// and the model is more attractive than the Malm.Map one.
public final class MapConverter {
    
    private let jsonEncoder: JSONEncoder
    private let outputURL: URL
    
    public init(
        outputURL: URL,
        jsonEncoder: JSONEncoder? = nil
    ) {
        self.outputURL = outputURL
        
        self.jsonEncoder = jsonEncoder ?? {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .withoutEscapingSlashes
            return jsonEncoder
        }()
    }
}

public extension MapConverter {
    
    @discardableResult
    func convert(map: Map) throws -> Scenario {
        let info = infoFrom(map: map)
        let scenarioMap = scenarioMap(from: map)
       
        let converted = Scenario(
            info: info,
            map: scenarioMap
        )
        
        let jsonData = try jsonEncoder.encode(converted)
        let fileName = "\(converted.info.summary.name).scenario.json"
        let fileUrl = outputURL.appendingPathComponent(fileName)
        try jsonData.write(to: fileUrl)
        
        
        return converted
    }
}

// MARK: Private
private extension MapConverter {
    func infoFrom(map: Map) -> Scenario.Info {
        .init(
            
            summary: .init(
                name: map.basicInformation.name,
                size: map.basicInformation.size
            ),
            
            playersInfo: .init(
                players: map.playersInfo.availablePlayers
            )
        )
    }
    
    // MARK: Objects Storage
    
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
    
    func scenarioMap(from map: Malm.Map) -> Scenario.Map {
        var positionToObjects: [Position: Objects] = [:]
        
        map.detailsAboutObjects.objects.forEach { object in
            let position = object.position
            if let objects = positionToObjects[position] {
                objects.add(object: object)
            } else {
                positionToObjects[position] = .init(object: object)
            }
        }
        
        func objects(at position: Position) -> [Scenario.Map.Object]? {
            guard
                let apa = positionToObjects[position],
                !apa.objects.isEmpty,
                case let malmObjects = apa.objects
            else { return nil }
            
            let mapped: [Scenario.Map.Object ] = malmObjects.map { (malmObject) in
                
                switch malmObject.kind {
                case .hero(let hero): return .hero(hero)
                case .resource(let guardedResource): return .resource(guardedResource)
                default:
                    guard let entity = malmObject.kind.entity else {
                        return .unsupported(nil)
                    }
                    return .unsupported(String(describing: entity))
                }
            }
       
            return mapped
        }
        
        func level(
            `in`: (Malm.Map.World) -> Malm.Map.Level?
        ) -> Scenario.Map.Level? {
            guard let level = `in`(map.world) else { return nil }
            
            return .init(
                isLowerLevel: level.isUnderworld,
                tiles: level.tiles.map {
                    .init(
                        position: $0.position,
                        ground: $0.ground,
                        objects: objects(at: $0.position))
                }
            )
        }
        
        func level(
            keyPath levelKeyPath: KeyPath<Map.World, Map.Level?>
        ) -> Scenario.Map.Level? {
            level(in: { $0[keyPath: levelKeyPath] })
        }
        
        return Scenario.Map(
            upperLevel: level(in: { $0.above })!,
            lowerLevel: level(keyPath: \.underground)
        )
    }
}
