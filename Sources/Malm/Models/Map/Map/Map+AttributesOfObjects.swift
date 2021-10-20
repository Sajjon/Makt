//
//  Map+Attributes.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation
import Common

public extension Map {
    struct AttributesOfObjects: Hashable, Codable {
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
    
    struct Attributes: Hashable, CustomDebugStringConvertible, Codable {
        
        public enum CodingKeys: String, CodingKey {
            case sprite, supportedLandscapes, mapEditorLandscapeGroup, objectID, group, pathfinding, zAxisRenderingPriority = "z"
        }
        
        static let defaultSupportedLandscapes = Map.Terrain.allCases.all(but: [.rock])
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.sprite = try container.decode(Sprite.self, forKey: .sprite)
            
            self.supportedLandscapes = try container.decodeIfPresent([Map.Terrain].self, forKey: .supportedLandscapes) ?? Self.defaultSupportedLandscapes
            self.mapEditorLandscapeGroup = try container.decode([Map.Terrain].self, forKey: .mapEditorLandscapeGroup)
            
            self.objectID = try container.decode(Map.Object.ID.self, forKey: .objectID)
            self.group = try container.decodeIfPresent(Group.self, forKey: .group)
            
            self.pathfinding = try container.decodeIfPresent(Pathfinding.self, forKey: .pathfinding) ?? .default
            self.zAxisRenderingPriority = try container.decode(Int.self, forKey: .zAxisRenderingPriority)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            if pathfinding != .default {
                try container.encode(pathfinding, forKey: .pathfinding)
            }
            
            if supportedLandscapes != Self.defaultSupportedLandscapes {
                try container.encode(supportedLandscapes, forKey: .supportedLandscapes)
            }
            
            try container.encode(sprite, forKey: .sprite)
            try container.encode(zAxisRenderingPriority, forKey: .zAxisRenderingPriority)
            try container.encodeIfPresent(group, forKey: .group)
            try container.encode(objectID, forKey: .objectID)
            try container.encode(mapEditorLandscapeGroup, forKey: .mapEditorLandscapeGroup)
            
        }
        
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

public extension Map.Object.Attributes.Pathfinding.RelativePositionOfTiles {
    
    init(bitmaskData: Data) throws {
        assert(bitmaskData.count == Map.Object.Attributes.Pathfinding.rowCount)
        let bitmask = BitArray(data: bitmaskData)
        try self.init(bitmask: bitmask)
    }
    
    init(bitmask: BitArray) throws {
        var index = 0
        var array = [Map.Object.Attributes.Pathfinding.RelativePosition]()
        for row in 0..<Map.Object.Attributes.Pathfinding.rowCount {
            for column in 0..<Map.Object.Attributes.Pathfinding.columnCount {
                defer { index += 1 }
                let relativePosition: Map.Object.Attributes.Pathfinding.RelativePosition = .init(column: .init(column), row: .init(row))
                let allowed = bitmask[index]
                if allowed {
                    array.append(relativePosition)
                }
            }
        }
        self.values = array
    }
    
    static let allZero: Self = try! .init(bitmask: .init(repeating: false, count: Map.Object.Attributes.Pathfinding.rowCount * Map.Object.Attributes.Pathfinding.columnCount))
    static let allSet: Self = try! .init(bitmask: .init(repeating: true, count: Map.Object.Attributes.Pathfinding.rowCount * Map.Object.Attributes.Pathfinding.columnCount))
}

public extension Map.Object.Attributes {
    
    struct Pathfinding: Hashable, CustomDebugStringConvertible, Codable {
        
        static let `default`: Self = .init(visitability: .allZero, passability: .allSet)
        
        public let visitability: RelativePositionOfTiles
        public let passability: RelativePositionOfTiles
        
        static func encodeAsBitmask(_ relativePositionOfTiles: RelativePositionOfTiles) -> Data {
            var bitArray = BitArray(repeating: false, count: Self.rowCount * Self.columnCount)
            var bitArrayIndex = 0
            for row in 0..<Self.rowCount {
                for column in 0..<Self.columnCount {
                    defer { bitArrayIndex += 1 }
                    guard relativePositionOfTiles.contains(where: { $0.x == column && $0.y == row }) else { continue }
                    bitArray[bitArrayIndex] = true
                }
            }
            return bitArray.asData()
        }
        
        enum CodingKeys: String, CodingKey {
            case visitability, passability
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            if visitability != .allZero {
                let visitabilityBitmask = Self.encodeAsBitmask(visitability)
                try container.encode(visitabilityBitmask.hexEncodedString(), forKey: .visitability)
            }
            if passability != .allSet {
                let passabilityBitmask = Self.encodeAsBitmask(passability)
                try container.encode(passabilityBitmask.hexEncodedString(), forKey: .passability)
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let visitabilityBitmaskHex = try container.decodeIfPresent(String.self, forKey: .visitability) {
                let visitabilityBitmask = try Data(hex: visitabilityBitmaskHex)
                self.visitability = try .init(bitmaskData: visitabilityBitmask)
            } else {
                self.visitability = .allZero
            }
            
            if let passabilityBitmaskHex = try container.decodeIfPresent(String.self, forKey: .passability) {
                let passabilityBitmask = try Data(hex: passabilityBitmaskHex)
                self.passability = try .init(bitmaskData: passabilityBitmask)
            } else {
                self.passability = .allSet
            }

        }
        
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
    
    
    enum Group: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible, Codable {
        case towns = 1
        case monsters
        case heroes
        case artifacts
        case treasure
    }
    
    
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
    
    typealias RelativePositionOfTiles = ArrayOf<RelativePosition>
    static let columnCount = 8
    static let rowCount = 6
    
    /// A relative position on adventure map, two dimensions (x: Int, y: Int)
    struct RelativePosition: Hashable, Comparable, CustomDebugStringConvertible, Codable {
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
