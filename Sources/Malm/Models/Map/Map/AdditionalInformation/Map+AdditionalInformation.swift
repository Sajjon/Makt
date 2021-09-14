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
        
        /// Nil means no teams
        public let teamInfo: TeamInfo
        
        public let availableHeroes: HeroIDs
        
        /// SOD feature only
        public let customHeroes: CustomHeroes?
        
        /// AB/SOD feature only
        public let availableArtifacts: ArtifactIDs?
        
        /// SOD feature only
        public let availableSpells: SpellIDs?
        
        /// SOD feature only
        public let availableSecondarySkills: SecondarySkillKinds?
        
        public let rumors: Rumors?
        
        /// SOD feature only
        public let settingsForHeroes: SettingsForHeroes?
        
        public init(
            victoryLossConditions: VictoryLossConditions,
            teamInfo: TeamInfo,
            availableHeroes: HeroIDs,
            customHeroes: CustomHeroes? = nil,
            availableArtifacts: ArtifactIDs? = nil,
            availableSpells: SpellIDs? = nil,
            availableSecondarySkills: SecondarySkillKinds? = nil,
            rumors: Rumors? = nil,
            settingsForHeroes: SettingsForHeroes? = nil
        ) {
            self.victoryLossConditions = victoryLossConditions
            self.teamInfo = teamInfo
            self.availableHeroes = availableHeroes
            self.customHeroes = customHeroes
            self.availableArtifacts = availableArtifacts
            self.availableSpells = availableSpells
            self.availableSecondarySkills = availableSecondarySkills
            self.rumors = rumors
            self.settingsForHeroes = settingsForHeroes
        }
    }
}

public extension Map.AdditionalInformation {
    typealias Rumors = ArrayOf<Map.Rumor>
    typealias SettingsForHeroes = ArrayOf<SettingsForHero>
}

