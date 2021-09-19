//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-19.
//

import Foundation
import Util

public extension DataReader {
    
    func readPathfindingMask() throws -> Set<Map.Object.Attributes.Pathfinding.RelativePosition> {
        
        let bitmask = try readBitArray(byteCount: Map.Object.Attributes.Pathfinding.rowCount)
        
        var index = 0
        var set = Set<Map.Object.Attributes.Pathfinding.RelativePosition>()
        for row in 0..<Map.Object.Attributes.Pathfinding.rowCount {
            for column in 0..<Map.Object.Attributes.Pathfinding.columnCount {
                defer { index += 1 }
                let relativePosition: Map.Object.Attributes.Pathfinding.RelativePosition = .init(column: .init(column), row: .init(row))
                let allowed = bitmask[index]
                if allowed {
                    set.insert(relativePosition)
                }
            }
        }
        return set
    }
}
