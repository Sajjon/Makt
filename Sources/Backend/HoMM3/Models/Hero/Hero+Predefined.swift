//
//  Hero+Predefined.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero {
    struct Predefined: Equatable {
        public let heroID: ID
        public let startingExperiencePoints: Int
        public let startingSecondarySkills: [SecondarySkill]
        public let artifacts: [ArtifactInSlot]
        public let biography: String?
        public let gender: Gender
        public let customSpells: [Spell.ID]?
        public let customPrimarySkills: [PrimarySkill]?
    }
}

public extension Hero.Predefined {
    struct ArtifactInSlot: Equatable {
        public let slot: Artifact.Slot
        public let artifactID: Artifact.ID
    }
}
