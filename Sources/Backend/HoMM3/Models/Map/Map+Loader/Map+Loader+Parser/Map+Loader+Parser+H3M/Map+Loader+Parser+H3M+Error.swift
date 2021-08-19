//
//  Map+Loader+Parser+H3M+Error.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

// MARK: Error
enum Error: Swift.Error {
    case corruptMapFileTooSmall
    case failedToReadHeaderVersion
    case unsupportedFormat(Map.Format)
    case unrecognizedDifficulty(Difficulty.RawValue)
    case unrecognizedAITactic(AITactic.RawValue)
    case unrecognizedArtifactID(Artifact.ID.RawValue)
    case unrecognizedFaction(Faction.RawValue)
    case unrecognizedHeroID(Hero.ID.RawValue)
    case unrecognizedVictoryConditionKind(Map.VictoryCondition.Kind.Stripped.RawValue)
    case unrecognizedLossConditionKind(Map.VictoryCondition.Kind.Stripped.RawValue)
    case unrecognizedSecondarySkillKind(Hero.SecondarySkill.Kind.RawValue)
    case unrecognizedSecondarySkillLevel(Hero.SecondarySkill.Level.RawValue)
    
    case warmachineFoundInBackback
}
