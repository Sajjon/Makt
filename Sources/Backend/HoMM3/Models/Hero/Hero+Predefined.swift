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
        public let startingExperiencePoints: UInt32
        public let startingSecondarySkills: [SecondarySkill]?
        public let artifacts: [ArtifactInSlot]?
        public let biography: String?
        public let customGender: Gender?
        public let customSpells: [Spell.ID]?
        public let customPrimarySkills: [PrimarySkill]?
    }
}

public extension Hero.Predefined {
    var isCustomized: Bool {
        startingExperiencePoints > 0 ||
            startingSecondarySkills != nil ||
            artifacts != nil ||
            biography != nil ||
            customSpells != nil ||
            customPrimarySkills != nil
    }
}

public extension Hero {
    struct ArtifactInSlot: Hashable {
        public let slot: Artifact.Slot
        public let artifactID: Artifact.ID
    }
}
