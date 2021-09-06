//
//  H3M+Parse+Inspector+AdditionalInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-29.
//

import Foundation

public extension Map.Loader.Parser.Inspector {
    final class AdditionalInfoInspector {
        internal let victoryLossInspector: VictoryLossInspector?
        
        private let onParseAvailableHeroes: OnParseAvailableHeroes?
        private let onParseTeamInfo: OnParseTeamInfo?
        private let onParseCustomHeroes: OnParseCustomHeroes?
        private let onParseAvailableArtifacts: OnParseAvailableArtifacts?
        private let onParseAvailableSpells: OnParseAvailableSpells?
        private let onParseAvailableSecondarySkills: OnParseAvailableSecondarySkills?
        private let onParseRumors: OnParseRumors?
        private let onParseHeroSettings: OnParseHeroSettings?
        
        public init(
            victoryLossInspector: VictoryLossInspector? = nil,
            onParseTeamInfo: OnParseTeamInfo? = nil,
            onParseAvailableHeroes: OnParseAvailableHeroes? = nil,
            onParseCustomHeroes: OnParseCustomHeroes? = nil,
            onParseAvailableArtifacts: OnParseAvailableArtifacts? = nil,
            onParseAvailableSpells: OnParseAvailableSpells? = nil,
            onParseAvailableSecondarySkills: OnParseAvailableSecondarySkills? = nil,
            
            onParseRumors: OnParseRumors? = nil,
            onParseHeroSettings: OnParseHeroSettings? = nil
        ) {
            
            self.victoryLossInspector = victoryLossInspector
            self.onParseAvailableHeroes = onParseAvailableHeroes
            self.onParseTeamInfo = onParseTeamInfo
            self.onParseCustomHeroes = onParseCustomHeroes
            self.onParseAvailableArtifacts = onParseAvailableArtifacts
            self.onParseAvailableSpells = onParseAvailableSpells
            self.onParseAvailableSecondarySkills = onParseAvailableSecondarySkills
            self.onParseRumors = onParseRumors
            self.onParseHeroSettings = onParseHeroSettings
        }
    }
}

public extension Map.Loader.Parser.Inspector.AdditionalInfoInspector {
    
    func didParseTeamInfo(_ teamInfo: Map.TeamInfo) {
        onParseTeamInfo?(teamInfo)
    }
    
    func didParseAvailableHeroes(_ availableHeroes: Map.AvailableHeroes) {
        onParseAvailableHeroes?(availableHeroes)
    }
    
    func didParseCustomHeroes(_ customHeroes: Map.AdditionalInformation.CustomHeroes?) {
        onParseCustomHeroes?(customHeroes)
    }
    
    func didParseAvailableArtifacts(_ availableArtifacts: Map.AdditionalInformation.AvailableArtifacts?) {
        onParseAvailableArtifacts?(availableArtifacts)
    }
    
    func didParseAvailableSpells(_ availableSpells: Map.AdditionalInformation.AvailableSpells?) {
        onParseAvailableSpells?(availableSpells)
    }
    
    func didParseAvailableSecondarySkills(_ availableSecondarySkills: Map.AdditionalInformation.AvailableSecondarySkills?) {
        onParseAvailableSecondarySkills?(availableSecondarySkills)
    }
    
    func didParseRumors(_ rumors: Map.AdditionalInformation.Rumors) {
        onParseRumors?(rumors)
    }
    
    func didParseHeroSettings(_ heroSettings: Map.AdditionalInformation.HeroSettings) {
        onParseHeroSettings?(heroSettings)
    }
}

public extension Map.Loader.Parser.Inspector.AdditionalInfoInspector {
    
    typealias OnParseAvailableHeroes = (Map.AvailableHeroes) -> Void
    typealias OnParseTeamInfo = (Map.TeamInfo) -> Void
    typealias OnParseCustomHeroes = (_ customHeroes: Map.AdditionalInformation.CustomHeroes?) -> Void
    typealias OnParseAvailableArtifacts = (_ availableArtifacts: Map.AdditionalInformation.AvailableArtifacts?) -> Void
    typealias OnParseAvailableSpells = (_ availableSpells:  Map.AdditionalInformation.AvailableSpells?) -> Void
    typealias OnParseAvailableSecondarySkills = (_ availableSecondarySkills:  Map.AdditionalInformation.AvailableSecondarySkills?) -> Void
    typealias OnParseRumors = (Map.AdditionalInformation.Rumors) -> Void
    typealias OnParseHeroSettings = (Map.AdditionalInformation.HeroSettings) -> Void
    
    
}

// MARK: Victory/Loss Inspector
public extension Map.Loader.Parser.Inspector.AdditionalInfoInspector {
    final class VictoryLossInspector {

        private let onParseVictoryConditions: OnParseVictoryConditions?
        private let onParseLossConditions: OnParseLossConditions?
        
        public init(
            onParseVictoryConditions: OnParseVictoryConditions? = nil,
            onParseLossConditions: OnParseLossConditions? = nil
        ) {
            self.onParseVictoryConditions = onParseVictoryConditions
            self.onParseLossConditions = onParseLossConditions
        }
    }
}

public extension Map.Loader.Parser.Inspector.AdditionalInfoInspector.VictoryLossInspector {
    
    typealias OnParseVictoryConditions = ([Map.VictoryCondition]) -> Void
    typealias OnParseLossConditions = ([Map.LossCondition]) -> Void
    
    func didParseVictoryConditions(_ victoryConditions: [Map.VictoryCondition]) {
        onParseVictoryConditions?(victoryConditions)
    }
    
    func didParseLossConditions(_ lossConditions: [Map.LossCondition]) {
        onParseLossConditions?(lossConditions)
    }
}
