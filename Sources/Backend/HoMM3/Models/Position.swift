//
//  Position.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

/// Position on adventure map, three dimensions (x: Int, y: Int, inUnderworld: Bool)
public struct Position: Hashable {
    public typealias Scalar = Int32
    public let x: Scalar
    public let y: Scalar
    public let inUnderworld: Bool
    
    public init(x: Scalar, y: Scalar, inUnderworld: Bool) {
        self.x = x
        self.y = y
        self.inUnderworld = inUnderworld
    }
    
    public init(column: Scalar, row: Scalar, inUnderworld: Bool) {
        self.init(x: column, y: row, inUnderworld: inUnderworld)
    }
}

public extension Position {
    func fitsInMapDescribed(by summary: Map.About.Summary) -> Bool {
        if !summary.hasTwoLevels && self.inUnderworld {
            // Cyon: is this correct? Does Z mean underworld or not?
            return false
        }
        
        return x <= summary.size.width && y <= summary.size.height
    }
}
