//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension Map.Loader.Parser.H3M {
    func parseGarrison(format: Map.Format) throws -> Map.Garrison {
        let owner = try parseOwner()
        try reader.skip(byteCount: 3)
        let creatures = try parseCreatureStacks(format: format, count: 7)
        let areCreaturesRemovable = try format > .restorationOfErathia ? reader.readBool() : true
        try reader.skip(byteCount: 8)
        return .init(
            areCreaturesRemovable: areCreaturesRemovable,
            owner: owner,
            creatures: creatures
        )
    }
}
