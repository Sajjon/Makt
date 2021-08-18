//
//  Hero+SecondarySkill+Kind.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero.SecondarySkill {
    enum Kind: UInt8, Hashable, CaseIterable {
        case pathfinding,
        archery,
        logistics,
        scouting,
        diplomacy,
        navigation,
        leadership,
        wisdom,
        mysticism,
        luck,
        ballistics,
        eagleEye,
        necromancy,
        estates,
        fireMagic,
        airMagic,
        waterMagic,
        earthMagic,
        scholar,
        tactics,
        artillery,
        learning,
        offence,
        armorer,
        intelligence,
        sorcery,
        resistance,
        firstAid
    }
}
