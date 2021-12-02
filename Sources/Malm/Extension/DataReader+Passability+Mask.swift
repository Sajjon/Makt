//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-19.
//

import Foundation
import Common

public extension DataReader {
    
    func readPathfindingMask() throws -> Map.Object.Attributes.Pathfinding.RelativePositionOfTiles {
        let bitmask = try readBitArray(byteCount: Map.Object.Attributes.Pathfinding.rowCount)
        return try .init(bitmask: bitmask)
    }
}
