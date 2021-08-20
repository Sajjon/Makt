//
//  Map+Definitions.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct Definitions: Equatable {
        public let objectAttributes: [Map.Object.Attributes]
    }
}

public extension Map.Object {
    struct Attributes: Equatable {
        public let animationFileName: String
        public let supportedLandscapes: [Map.Tile.Terrain.Kind]
        public let mapEditorLandscapeGroup: [Map.Tile.Terrain.Kind]
        public let objectID: Map.Object.ID
        public let group: Group?
        public let pathfinding: Pathfinding
        public let zRenderingPosition: UInt8
    }
}



public extension Map.Object.Attributes {
    
    struct Pathfinding: Equatable {
        public let visitability: Visitability
        public let passability: Passability
    }

    
     enum Group: UInt8, Equatable, CaseIterable {
        case towns = 1
        case monsters
        case heroes
        case artifacts
        case treasure
    }
}

public extension Map.Object.Attributes.Pathfinding {
    
    struct Visitability: Equatable {
        public let visitablilityPerTileRelativePositionMap: [RelativePosition: IsVisitable]
    }
    struct Passability: Equatable {
        public let passabilityPerTileRelativePositionMap: [RelativePosition: IsPassable]
    }
    
    static let columnCount = 8
    static let rowCount = 6
    
    /// A relative position on adventure map, two dimensions (x: Int, y: Int)
    struct RelativePosition: Hashable {
        public typealias Scalar = Int32
        public let x: Scalar
        public let y: Scalar
        public init(x: Scalar, y: Scalar) {
            self.x = x
            self.y = y
        }
        public init(column: Scalar, row: Scalar) {
            self.init(x: column, y: row)
        }
    }

    typealias IsPassable = Bool
    typealias IsVisitable = Bool
}
