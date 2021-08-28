//
//  Hero+Settings.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Map.AdditionalInformation {
    struct SettingsForHero: Hashable {
        public let heroID: Hero.ID
        public let startingExperiencePoints: UInt32
        public let startingSecondarySkills: [Hero.SecondarySkill]?
        public let artifacts: [Hero.ArtifactInSlot]?
        public let biography: String?
        public let customGender: Hero.Gender?
        public let customSpells: [Spell.ID]?
        public let customPrimarySkills: [Hero.PrimarySkill]?
    }
}

public extension Map.AdditionalInformation.SettingsForHero {
    var isCustomized: Bool {
        startingExperiencePoints > 0 ||
            startingSecondarySkills != nil ||
            artifacts != nil ||
            biography != nil ||
            customSpells != nil ||
            customPrimarySkills != nil
    }
}
