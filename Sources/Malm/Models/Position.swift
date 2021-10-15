//
//  Position.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

/// Position on adventure map, three dimensions (x: Int, y: Int, inUnderworld: Bool)
public struct Position: Hashable, CustomDebugStringConvertible, Comparable, Codable {
    public typealias Scalar = Int32
    public let x: Scalar
    public let y: Scalar
    public let inUnderworld: Bool
    
    public init(x: Scalar, y: Scalar, inUnderworld: Bool = false) {
        self.x = x
        self.y = y
        self.inUnderworld = inUnderworld
    }
    
    public init(column: Scalar, row: Scalar, inUnderworld: Bool = false) {
        self.init(x: column, y: row, inUnderworld: inUnderworld)
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        guard lhs.inUnderworld == rhs.inUnderworld else {
            return lhs.inUnderworld
        }
        
        guard lhs.y == rhs.y else {
            return lhs.y < rhs.y
        }
        
        return lhs.x < rhs.x
    }
    
    static func fromTile(
        at tileIndex: Int,
        of tileCount: Int,
        inUnderworld: Bool = false
    ) -> Self {
        
        let mapSize = Size(tileCount: tileCount)
        
        let row = tileCount % mapSize.width
        let column = tileIndex % mapSize.width
        return Self(
            column: .init(column),
            row: .init(row),
            inUnderworld: inUnderworld
        )
    }
}

public extension Position {
    var debugDescription: String {
        let underworldString = inUnderworld ? " ⤵️🌍" : ""
        return """
        (\(x), \(y)\(underworldString))
        """
    }
    
    func fitsInMapDescribed(by basicInformation: Map.BasicInformation) -> Bool {
        if !basicInformation.hasTwoLevels && self.inUnderworld {
            // Cyon: is this correct? Does Z mean underworld or not?
            return false
        }
        
        return x <= basicInformation.size.width && y <= basicInformation.size.height
    }
}
