//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

internal extension Map.Loader.Parser.H3M {
    func parseOwner() throws -> Player? {
        let raw = try reader.readUInt8()
        return raw != Player.neutralRawValue ? try Player(integer: raw) : nil
    }
}
