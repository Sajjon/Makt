//
//  Position.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

/// Position on adventure map, three dimensions (x: Int, y: Int, inUnderworld: Bool)
public struct Position: Hashable, CustomDebugStringConvertible {
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
