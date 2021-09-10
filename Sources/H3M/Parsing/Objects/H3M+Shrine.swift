//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension H3M {
    func parseShrine() throws -> Map.Shrine {
        let spellID = try parseSpellID()
        try reader.skip(byteCount: 3)
        return .init(spell: spellID)
    }
}
