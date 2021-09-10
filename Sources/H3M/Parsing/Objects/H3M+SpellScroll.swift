//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension Map.Loader.Parser.H3M {
    func parseSpellScroll(format: Map.Format) throws -> Map.SpellScroll {
        let (message, guardians) = try parseMessageAndGuardians(format: format)
        let spellID = try Spell.ID(integer: reader.readUInt32())
        return .init(id: spellID, message: message, guardians: guardians)
    }
}
