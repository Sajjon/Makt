//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

public extension Map {
    struct Shrine: Hashable, Codable {
        public let spell: Spell.ID?
        
        public init(spell: Spell.ID?) {
            self.spell = spell
        }
    }
}
