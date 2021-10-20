//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Util
import Malm

public extension Scenario.Map.Level {
    struct Tile: Hashable {
        public let position: Position
        public let ground: Ground
        public let road: Road?
        public let river: River?
        
        @NullEncodable
        public private(set) var objects: Scenario.Map.Level.Objects?
        
        public init(
            position: Position,
            ground: Ground,
            road: Road? = nil,
            river: River? = nil,
            objects: Scenario.Map.Level.Objects? = nil
        ) {
            self.position = position
            self.ground = ground
            self.road = road
            self.river = river
            if let objects = objects, !objects.isEmpty {
                self.objects = objects
            } 
        }
    }
    
    typealias Tiles = ArrayOf<Tile>
    typealias Objects = ArrayOf<Scenario.Map.Object>
}

public extension Scenario.Map.Level.Tile {
    init(
        position: Position,
        ground: Ground,
        road: Road? = nil,
        river: River? = nil,
        objects nonSortedObjects: [Scenario.Map.Object]? = nil
    ) {
        self.init(
            position: position,
            ground: ground,
            road: road,
            river: river,
            objects: nonSortedObjects.map { .init(values: $0) }
        )
    }
}

@propertyWrapper
public struct NullEncodable<T>: Encodable where T: Encodable {
    
    public var wrappedValue: T?

    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch wrappedValue {
        case .some(let value): try container.encode(value)
        case .none: try container.encodeNil()
        }
    }
}
extension NullEncodable: Equatable where T: Equatable {}
extension NullEncodable: Hashable where T: Hashable {}
