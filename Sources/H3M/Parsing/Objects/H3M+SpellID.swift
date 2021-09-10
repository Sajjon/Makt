//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

internal extension H3M {
    func parseSpellID() throws -> Spell.ID? {
        let raw = try reader.readUInt8()
        return raw != Spell.ID.noneRawValue ? try Spell.ID(integer: raw) : nil
    }
}
