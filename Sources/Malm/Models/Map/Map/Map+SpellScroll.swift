//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

public extension Map {
    
    struct SpellScroll: Hashable, Codable {
        public let spell: Spell.ID
        public let message: String?
        public let guardians: CreatureStacks?
        public init(id spellID: Spell.ID, message: String? = nil, guardians: CreatureStacks? = nil) {
            self.spell = spellID
            self.message = message
            self.guardians = guardians
        }
    }
}
