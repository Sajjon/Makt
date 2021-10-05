//
//  Map+Attributes.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct AttributesOfObjects: Hashable {
        public let attributes: [Map.Object.Attributes]
        public init(attributes: [Map.Object.Attributes]) {
            self.attributes = attributes
        }
    }
}

public extension Map.Object {
    
    var width: Position.Scalar {
        attributes.width
    }
    
    var height: Position.Scalar {
        attributes.height
    }
    
    struct Attributes: Hashable, CustomDebugStringConvertible {
        
        /// Name of sprite/animation file
        public let sprite: Sprite
        
        public let supportedLandscapes: [Map.Terrain]
        public let mapEditorLandscapeGroup: [Map.Terrain]

        public let objectID: Map.Object.ID

        public let group: Group?
        public let pathfinding: Pathfinding
        public let zAxisRenderingPriority: Int
        
        public init(
            sprite: Sprite,
            supportedLandscapes: [Map.Terrain],
            mapEditorLandscapeGroup: [Map.Terrain],
            objectID: Map.Object.ID,
            group: Group?,
            pathfinding: Pathfinding,
            zAxisRenderingPriority: Int
        ) {
            self.sprite = sprite
            self.supportedLandscapes = supportedLandscapes
            self.mapEditorLandscapeGroup = mapEditorLandscapeGroup
            self.objectID = objectID
            self.group = group
            self.pathfinding = pathfinding
            self.zAxisRenderingPriority = zAxisRenderingPriority
        }
    }
}


public extension Map.Object.Attributes {
    
    var isVisitable: Bool {
        !pathfinding.visitability.isEmpty
    }
    
    var width: Position.Scalar {
        pathfinding.width
    }
    
    var height: Position.Scalar {
        pathfinding.height
    }
    
    var debugDescription: String {
        "\(objectID)"
    }
    
    struct Pathfinding: Hashable, CustomDebugStringConvertible {
        public let visitability: RelativePositionOfTiles
        public let passability: RelativePositionOfTiles
        
        public init(
            visitability: RelativePositionOfTiles,
            passability: RelativePositionOfTiles
        ) {
            self.visitability = visitability
            self.passability = passability
        }
        
        
        var width: Position.Scalar {
            max(visitability.width, passability.width)
        }
        
        var height: Position.Scalar {
            max(visitability.height, passability.height)
        }
        
        
        public var debugDescription: String {
            """
            visitable: \(visitability.values)
            passable: \(passability.values)
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

//public protocol TileAreaMeasureable {
//    var relativePositionOfTiles: [RelativePosition] { get }
////    init(relativePositionOfTiles: [RelativePosition])
//}
//extension TileAreaMeasureable where Self: ExpressibleByArrayLiteral, Self.ArrayLiteralElement == RelativePosition {
//    public init(arrayLiteral elements: ArrayLiteralElement...) {
//        assert(elements.)
//        self.init(relativePositionOfTiles: elements.map({ .init(x: $0.0, y: $0.1) }))
//    }
//}

public extension Map.Object.Attributes.Pathfinding {
    
    typealias RelativePositionOfTiles = ArrayOf<RelativePosition>
    static let columnCount = 8
    static let rowCount = 6
    
    /// A relative position on adventure map, two dimensions (x: Int, y: Int)
    struct RelativePosition: Hashable, Comparable, CustomDebugStringConvertible {
        public static func < (lhs: Self, rhs: Self) -> Bool {
            guard lhs.y == rhs.y else {
                return lhs.y < rhs.y
            }
            
            return lhs.x < rhs.x
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

extension Collection where Element: Comparable, Index == Int {
    func isSorted() -> Bool {
        guard count > 1 else { return true }
        for i in 1..<self.count {
            if self[i-1] > self[i] { return false }
        }
        return true
    }
}

extension Map.Object.Attributes.Pathfinding.RelativePositionOfTiles {
    var width: Position.Scalar {
        guard let lastPosition = values.last else {
            return 0
        }
        return lastPosition.x
    }
    
    var height: Position.Scalar {
        guard let lastPosition = values.last else {
            return 0
        }
        return lastPosition.y
    }
}
