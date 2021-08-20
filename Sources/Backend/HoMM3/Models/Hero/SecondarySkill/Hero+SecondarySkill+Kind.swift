//
//  Hero+SecondarySkill+Kind.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero.SecondarySkill {
    enum Kind: UInt8, Hashable, CaseIterable {
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
