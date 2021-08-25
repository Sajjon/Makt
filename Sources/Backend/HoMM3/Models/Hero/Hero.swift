//
//  Hero.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public struct Hero: Hashable {
    public let `class`: Hero.Class?
    public let questIdentifier: UInt32?
    public let portraitID: ID?
    public let name: String?
    public let owner: PlayerColor?
    public let army: Army?
    public let patrolRadius: Int
    public let isPatroling: Bool
    public let startingExperiencePoints: UInt32
    public let startingSecondarySkills: [SecondarySkill]?
    public let artifacts: [ArtifactInSlot]?
    public let biography: String?
    public let gender: Gender?
    public let spells: [Spell.ID]?
    public let primarySkills: [PrimarySkill]?
}

public extension Hero {
    enum Class: UInt8, Hashable, CaseIterable {
        case
        knight,
        cleric,
        ranger,
        druid,
        alchemist,
        wizard,
        demoniac,
        heretic,
        deathKnight,
        necromancer,
        overlord,
        warlock,
        barbarian,
        battleMage,
        beastmaster,
        witch,
        planeswalker,
        elementalist
        #if HOTA
        case captain,
        navigator
        #endif // HOTA
    }
}
