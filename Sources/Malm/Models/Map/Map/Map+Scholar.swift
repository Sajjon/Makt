//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

public extension Map {
    struct Scholar: Hashable, CustomDebugStringConvertible, Codable {
        public let bonus: Bonus
        public init(bonus: Bonus) {
            self.bonus = bonus
        }
    }
}

// MARK: CustomDebugStringConvertible
public extension Map.Scholar {
    var debugDescription: String {
        "bonus: \(bonus)"
    }
}

// MARK: Bonus
public extension Map.Scholar {
    enum Bonus: Hashable, CustomDebugStringConvertible, Codable {
        case primarySkill(Hero.PrimarySkill.Kind)
        case secondarySkill(Hero.SecondarySkill.Kind)
        case spell(Spell.ID)
        case random
    }
}

// MARK: Bonus + CustomDebugStringConvertible
public extension Map.Scholar.Bonus {
    var debugDescription: String {
        switch self {
        case .primarySkill(let ps): return "primarySkill: \(ps)"
        case .secondarySkill(let ss): return "secondarySkill: \(ss)"
        case .spell(let spell): return "spell: \(spell)"
        case .random: return "random"
        }
    }
}


// MARK: Bonus + Stripped
public extension Map.Scholar.Bonus {
    enum Stripped: UInt8, Hashable, CaseIterable, Codable {
        case primarySkill
        case secondarySkill
        case spell
        case random = 255
    }
}
