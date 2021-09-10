//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension H3M {
    func parseOceanBottle() throws -> Map.OceanBottle {
        let message = try reader.readString(maxByteCount: 150) // Cyon 150 is confirmed in Map Editor to be max for ocean bottle.
        try reader.skip(byteCount: 4)
        return .init(message: message)
    }
}
