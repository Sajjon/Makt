//
//  Hero+SecondarySkill+Kind.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero.SecondarySkill {
    enum Kind: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
        case pathfinding
        case archery
        case logistics
        case scouting
        case diplomacy
        case navigation
        case leadership
        case wisdom
        case mysticism
        case luck
        case ballistics
        case eagleEye
        case necromancy
        case estates
        case fireMagic
        case airMagic
        case waterMagic
        case earthMagic
        case scholar
        case tactics
        case artillery
        case learning
        case offence
        case armorer
        case intelligence
        case sorcery
        case resistance
        case firstAid
    }
}

public extension Hero.SecondarySkill.Kind {
    var debugDescription: String {
        switch self {
        case .pathfinding: return "pathfinding"
        case .archery: return "archery"
        case .logistics: return "logistics"
        case .scouting: return "scouting"
        case .diplomacy: return "diplomacy"
        case .navigation: return "navigation"
        case .leadership: return "leadership"
        case .wisdom: return "wisdom"
        case .mysticism: return "mysticism"
        case .luck: return "luck"
        case .ballistics: return "ballistics"
        case .eagleEye: return "eagleEye"
        case .necromancy: return "necromancy"
        case .estates: return "estates"
        case .fireMagic: return "fireMagic"
        case .airMagic: return "airMagic"
        case .waterMagic: return "waterMagic"
        case .earthMagic: return "earthMagic"
        case .scholar: return "scholar"
        case .tactics: return "tactics"
        case .artillery: return "artillery"
        case .learning: return "learning"
        case .offence: return "offence"
        case .armorer: return "armorer"
        case .intelligence: return "intelligence"
        case .sorcery: return "sorcery"
        case .resistance: return "resistance"
        case .firstAid: return "firstAid"
        }
    }
}
