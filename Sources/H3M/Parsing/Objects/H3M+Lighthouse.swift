//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension H3M {
    func parseLighthouse() throws -> Map.Lighthouse {
        let owner = try parseOwner()
        try reader.skip(byteCount: 3)
        return .init(owner: owner)
    }
}
