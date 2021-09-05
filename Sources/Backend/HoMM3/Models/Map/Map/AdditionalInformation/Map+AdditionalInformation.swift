//
//  Map+AdditionalInformation.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-28.
//

import Foundation

public extension Map {
    struct AdditionalInformation: Hashable {
        
        public let victoryLossConditions: VictoryLossConditions
        public let teamInfo: TeamInfo
        public let availableHeroes: AvailableHeroes
        
        /// SOD feature only
        public let customHeroes: CustomHeroes?
        
        /// AB/SOD feature only
        public let availableArtifacts: AvailableArtifacts?
        
        /// SOD feature only
        public let availableSpells: AvailableSpells?
        
        /// SOD feature only
        public let availableSecondarySkills: AvailableSecondarySkills?
        
        public let rumors: Rumors
        
        /// SOD feature onlu
        public let heroSettings: HeroSettings?
    }
}

public extension Map.AdditionalInformation {
    struct AvailableSpells: Hashable {
        public let spells: [Spell.ID]
    }
    
    struct AvailableSecondarySkills: Hashable {
        public let secondarySkills: [Hero.SecondarySkill.Kind]
    }
    
    struct AvailableArtifacts: Hashable {
        public let artifacts: [Artifact.ID]
    }
    
    struct Rumors: Hashable {
        public let rumors: [Map.Rumor]
    }
    
    struct HeroSettings: Hashable {
        public let settingsForHeroes: [SettingsForHero]
    }
}
