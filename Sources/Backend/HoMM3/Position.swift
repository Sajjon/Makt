//
//  Position.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

/// Position on adventure map, three dimensions (x, y, z)
public struct Position: Equatable {
    public typealias Scalar = Int32
    public let x: Scalar
    public let y: Scalar
    public let z: Scalar
}

public extension Position {
    func fitsInMapDescribed(by summary: Map.About.Summary) -> Bool {
        if !summary.hasTwoLevels && z > 1 {
            // Cyon: is this correct? Does Z mean underworld or not?
            return false
        }
        
        return [x, y, z].allSatisfy({ $0 <= summary.size.height && $0 <= summary.size.width })
    }
}
