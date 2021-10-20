//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm
import Util

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

private extension Map.Object {
    var zAxisIndex: Int { attributes.zAxisRenderingPriority }
}

// MARK: Private
private extension MapConverter {
    func infoFrom(map: Map) -> Scenario.Info {
        .init(
            
            summary: .init(
                id: map.id,
                version: map.basicInformation.format,
                name: map.basicInformation.name,
                size: map.basicInformation.size,
                difficulty: map.basicInformation.difficulty,
                numberOfPlayersThatCanBeHuman: map.numberOfPlayersThatCanBeHuman,
                numberOfPlayers: map.playersInfo.availablePlayers.count,
                victoryLossConditions: map.additionalInformation.victoryLossConditions
            ),
            
            playersInfo: .init(
                players: map.playersInfo.availablePlayers
            ),
            
            teamsInfo: map.additionalInformation.teamInfo
        )
    }
    
    // MARK: Objects Storage
    struct MapObjectWithGlobalZ {
        let mapObject: Map.Object
        let globalZ: Int
    }
    
    /// Helper class to construct a list of objects at a certain position,
    /// reference semantics makes this easier.
    final class Objects {
        internal private(set) var objects = [MapObjectWithGlobalZ]()
        init(object: MapObjectWithGlobalZ) {
            self.objects = [object]
        }
        func add(object: MapObjectWithGlobalZ) {
            objects.append(object)
        }
    }
    
    func scenarioMap(from map: Malm.Map) -> Scenario.Map {
        var positionToObjects: [Position: Objects] = [:]
        
        let sortedObjects = map.detailsAboutObjects.objects.sorted(by: { a, b in
            if a.zAxisIndex != b.zAxisIndex {
                return a.zAxisIndex > b.zAxisIndex
            }
            if a.position.y != b.position.y {
                return a.position.y < b.position.y
            }
            if b.objectID.stripped == .hero && a.objectID.stripped != .hero {
                return true
            }
            if b.objectID.stripped != .hero && a.objectID.stripped == .hero {
                return false
            }
            if !a.isVisitable && b.isVisitable {
                return true
            }
            if !b.isVisitable && a.isVisitable {
                return false
            }
            if a.position.x < b.position.x {
                return true
            }
            return false
        })
        
        
        
        sortedObjects.enumerated().forEach { (globalZ, mapObject) in
             let objectWithZ = MapObjectWithGlobalZ(mapObject: mapObject, globalZ: globalZ)
            let position = mapObject.position
            if let objects = positionToObjects[position] {
                objects.add(object: objectWithZ)
            } else {
                positionToObjects[position] = .init(object: objectWithZ)
            }
        }
        
        func objects(at position: Position) -> [Scenario.Map.Object] {
            guard
                let objects = positionToObjects[position],
                !objects.objects.isEmpty,
                case let mapObjectsWithZ = objects.objects
            else { return [] }
            
            let mapped: [Scenario.Map.Object ] = mapObjectsWithZ.compactMap { objectWithZ in
                let mapObject = objectWithZ.mapObject
                guard let kind = extractObjectKind(from: mapObject) else {
                    print("⚠️ WARNING discarding object: \(String(describing: mapObject))")
                    return nil
                }
                return .init(
                    kind: kind,
                    sprite: mapObject.attributes.sprite,
                    pathfinding: mapObject.attributes.pathfinding,
                    zAxisIndex: objectWithZ.globalZ //$0.attributes.zAxisRenderingPriority
                )
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
                        road: $0.road,
                        river: $0.river,
                        objects: objects(at: $0.position)
                    )
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
    
    func extractObjectKind(from mapObject: Map.Object) -> Scenario.Map.Object.Kind? {
        switch mapObject.kind {
        case .hero(let hero):
            return .interactive(.mutable(.hero(hero)))
        case .town(let town):
            return .flaggable(.town(town))
        case .abandonedMine(let abandonedMine):
            return .flaggable(.abandonedMine(abandonedMine))
        case .artifact(let guardedArtifact):
            return .conditionallyPerishable(.artifact(guardedArtifact))
        case .resourceGenerator(let resourceGenerator):
            return .flaggable(.resourceGenerator(resourceGenerator))
        case .dwelling(let dwelling):
            return .flaggable(.dwelling(dwelling))
        case .garrison(let garrison):
            return .flaggable(.garrison(garrison))
        case .geoEvent(let geoEvent):
            return .conditionallyPerishable(.geoEvent(geoEvent))
        case .grail(let grail):
            return .immediatelyPerishable(.grail(grail))
        case .lighthouse(let lighthouse):
            return .flaggable(.lighthouse(lighthouse))
        case .oceanBottle(let oceanBottle):
            return .immediatelyPerishable(.oceanBottle(oceanBottle))
        case .pandorasBox(let pandorasBox):
            return .immediatelyPerishable(.pandorasBox(pandorasBox))
        case .questGuard(let quest):
            return .conditionallyPerishable(.questGuard(quest))
        case .seershut(let seershut):
            return .visitable(.onceUntil(.critteriaMet(.seershut(seershut))))
        case .scholar(let scholar):
            return .immediatelyPerishable(.scholar(scholar))
        case .generic:
            return otherObjects(mapObject: mapObject)
        case .resource(let resource):
            return .conditionallyPerishable(.resource(resource))
        case .placeholderHero(_):
            return nil // TODO: Implement me
        case .shipyard(let shipyard):
            return .flaggable(.shipyard(shipyard))
        case .shrine(let shrine):
            return .visitable(.onceUntil(.critteriaMet(.shrine(shrine))))
        case .sign(let sign):
            return .immutable(.sign(sign))
        case .monster(let monster):
            return .conditionallyPerishable(.monster(monster))
        case .witchHut(let witchhut):
            return .visitableOncePerHero(.witchHut(witchhut))
        case .spellScroll(let spellscroll):
            return .immediatelyPerishable(.spellScroll(spellscroll))
        case .passableTerrain(let value):
            return passableTerrain(value)
        }
    }
    
    func passableTerrain(_ passableTerrain: Map.Object.Kind.PassableTerrain) -> Scenario.Map.Object.Kind? {
        
        func magicalTerrain(_ magicalTerrain: Scenario.Map.Object.Kind.NonInteractive.Effectful.MagicalTerrain) -> Scenario.Map.Object.Kind {
            .nonInteractive(.effectful(.magicalTerrain(magicalTerrain)))
        }
        
        switch passableTerrain {
        case .magicPlains, .magicPlains2:
            return magicalTerrain(.magicPlains)
        case .cursedGround, .cursedGround2:
            return magicalTerrain(.cursedGround)
        case .rocklands:
            return magicalTerrain(.rockland)
        case .fieryFields:
            return magicalTerrain(.fieryFields)
        case .lucidPools:
            return magicalTerrain(.lucidPools)
        case .magicClouds:
            return magicalTerrain(.magicClouds)
        case .holyGround:
            return magicalTerrain(.holyGround)
        case .evilFog:
            return magicalTerrain(.evilFog)
        case .cloverField:
            return magicalTerrain(.cloverField)
        case .favorableWinds:
            return magicalTerrain(.favourableWinds)
            
        case .kelp, .kelp2:
            return .nonInteractive(effectless: .kelp)
        case .hole, .hole2:
            return .nonInteractive(effectless: .hole)
        case .generic:
            return .nonInteractive(effectless: .generic)
        }
    }
    
    func otherObjects(mapObject: Map.Object) -> Scenario.Map.Object.Kind? {
        return nil
    }
}
