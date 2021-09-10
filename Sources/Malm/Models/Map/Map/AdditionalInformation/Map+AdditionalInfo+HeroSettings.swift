//
//  Hero+Settings.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Map.AdditionalInformation {
    struct SettingsForHero: Hashable, CustomDebugStringConvertible {
        public let heroID: Hero.ID
        public let startingExperiencePoints: UInt32
        public let startingSecondarySkills: Hero.SecondarySkills?
        public let artifacts: [Hero.ArtifactInSlot]?
        public let biography: String?
        public let customGender: Hero.Gender?
        public let customSpells: SpellIDs?
        public let customPrimarySkills: Hero.PrimarySkills?
        
        public init(
            heroID: Hero.ID,
            startingExperiencePoints: UInt32 = 0,
            startingSecondarySkills: Hero.SecondarySkills? = nil,
            artifacts: [Hero.ArtifactInSlot]? = nil,
            biography: String? = nil,
            customGender: Hero.Gender? = .defaultGender,
            customSpells: SpellIDs? = nil,
            customPrimarySkills: Hero.PrimarySkills? = nil
        ) {
            self.heroID = heroID
            self.startingExperiencePoints = startingExperiencePoints
            self.startingSecondarySkills = startingSecondarySkills
            self.artifacts = artifacts
            self.biography = biography
            self.customGender = customGender
            self.customSpells = customSpells
            self.customPrimarySkills = customPrimarySkills
        }
    }
}


// MARK: CustomDebugStringConvertible
public extension Map.AdditionalInformation.SettingsForHero {
    
    var debugDescription: String {
        let optionalStrings: [String?] = [
            "heroID: \(heroID)",
            "xp: \(startingExperiencePoints)",
            startingSecondarySkills.map { "secondarySkills: \($0)" },
            artifacts.map { "artifacts: \($0)" },
            biography.map { "biography: \($0)" },
            customGender.map { "gender: \($0)" },
            customSpells.map { "spells: \($0)" },
            customPrimarySkills.map { "primarySkills: \($0)" }
        ]
        
        return optionalStrings.filterNils().joined(separator: "\n")
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
