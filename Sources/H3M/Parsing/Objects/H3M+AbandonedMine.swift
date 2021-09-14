//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-14.
//

import Foundation
import Malm
import Util

extension H3M {
    
    func parseAbandonedMine() throws -> Map.AbandonedMine {
        let potentialResources: [Resource.Kind] = try parseBitmaskOfEnum()
        try reader.skip(byteCount: 3)
        return Map.AbandonedMine(potentialResources: potentialResources)
    }
}
