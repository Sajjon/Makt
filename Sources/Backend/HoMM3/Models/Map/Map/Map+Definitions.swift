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
    struct Attributes: Hashable, CustomDebugStringConvertible {
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
    
    var debugDescription: String {
        "\(objectID)"
    }
    
    struct Pathfinding: Hashable, CustomDebugStringConvertible {
        public let visitability: Visitability
        public let passability: Passability
        
        
        public var debugDescription: String {
            """
            visitable: \(visitability.relativePositionsOfVisitableTiles)
            passable: \(passability.relativePositionsOfPassableTiles)
            """
        }
    }

    
     enum Group: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
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
    
    struct Visitability: Hashable, ExpressibleByArrayLiteral {
        public let relativePositionsOfVisitableTiles: Set<RelativePosition>
        public typealias ArrayLiteralElement = (RelativePosition.Scalar, RelativePosition.Scalar)
        public init(arrayLiteral elements: ArrayLiteralElement...) {
            self.init(relativePositionsOfVisitableTiles: Set(elements.map({ .init(x: $0.0, y: $0.1) })))
        }
        public init(relativePositionsOfVisitableTiles: Set<RelativePosition>) {
            self.relativePositionsOfVisitableTiles = relativePositionsOfVisitableTiles
        }
    }
    struct Passability: Hashable, ExpressibleByArrayLiteral {
        public let relativePositionsOfPassableTiles: Set<RelativePosition>
        
        public typealias ArrayLiteralElement = (RelativePosition.Scalar, RelativePosition.Scalar)
        public init(arrayLiteral elements: ArrayLiteralElement...) {
            self.init(relativePositionsOfPassableTiles: Set(elements.map({ .init(x: $0.0, y: $0.1) })))
        }
        public init(relativePositionsOfPassableTiles: Set<RelativePosition>) {
            self.relativePositionsOfPassableTiles = relativePositionsOfPassableTiles
        }
        
     
    }
    
    static let columnCount = 8
    static let rowCount = 6
    
    /// A relative position on adventure map, two dimensions (x: Int, y: Int)
    struct RelativePosition: Hashable, Comparable, CustomDebugStringConvertible {
        public static func < (lhs: Self, rhs: Self) -> Bool {
            if lhs.x < rhs.x { return true }
            return lhs.y < rhs.y
        }
        
        public var debugDescription: String {
            "(\(x), \(y))"
        }
        
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
