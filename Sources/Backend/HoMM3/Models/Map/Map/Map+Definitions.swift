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
    struct Attributes: Equatable, CustomDebugStringConvertible {
        public let animationFileName: String
        public let supportedLandscapes: [Map.Tile.Terrain.Kind]
        public let mapEditorLandscapeGroup: [Map.Tile.Terrain.Kind]

        /// We REALLY dont want this to be optional. But the H3M parser parsed Map.Object.ID.Stripped with rawValue `50` and `199` which don't exist in the list. This is most likely due to incorrect implementation of the parser. But compared to both VCMI and homm3tools it looks correct. Hmm... more debugging is needed! Might be better to not at all initiialize the Map.Object.Attributes, and just skip it all together when objectID is nil?! At least we should debug and have a look at the values of the other properties!
        public let objectID: Map.Object.ID?

        public let group: Group?
        public let pathfinding: Pathfinding
        public let zRenderingPosition: UInt8
    }
}



public extension Map.Object.Attributes {
    
    var debugDescription: String {
        """
        animationFileName: \(animationFileName)
        objectID: \(objectID.map{ $0.debugDescription } ?? "nil")
        group: \(group.map{ $0.debugDescription } ?? "nil")
        supportedLandscapes: \(supportedLandscapes)
        mapEditorLandscapeGroup: \(mapEditorLandscapeGroup)
        """
    }
    
    struct Pathfinding: Equatable {
        public let visitability: Visitability
        public let passability: Passability
    }

    
     enum Group: UInt8, Equatable, CaseIterable, CustomDebugStringConvertible {
        case towns = 1
        case monsters
        case heroes
        case artifacts
        case treasure
    }
}

public extension Map.Object.Attributes.Group {
    var debugDescription: String {
        switch self {
        case .towns: return "towns"
        case .monsters: return "monsters"
        case .heroes: return "heroes"
        case .artifacts: return "artifacts"
        case .treasure: return "treasure"            
        }
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
