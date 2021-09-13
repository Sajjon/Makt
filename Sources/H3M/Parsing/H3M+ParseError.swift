//
//  Map+Loader+Parser+H3M+Error.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation
import Malm

// MARK: Error
enum H3MError: Swift.Error {
    case corruptMapFileTooSmall
    case failedToReadHeaderVersion
    case unsupportedFormat(Map.Format)
    case unrecognizedDifficulty(Difficulty.RawValue)
    case unrecognizedBehaviour(Behaviour.RawValue)
    case unrecognizedFaction(Faction.RawValue)
    case unrecognizedTerrainKind(Map.Tile.Terrain.Kind.RawValue)
    case unrecognizedHeroID(Hero.ID.RawValue)
    case unrecognizedVictoryConditionKind(Map.VictoryCondition.Kind.Stripped.RawValue)
    case unrecognizedLossConditionKind(Map.VictoryCondition.Kind.Stripped.RawValue)
    case unrecognizedSecondarySkillKind(Hero.SecondarySkill.Kind.RawValue)
    case unrecognizedSecondarySkillLevel(Hero.SecondarySkill.Level.RawValue)
    
    case unrecognizedObjectGroup(Map.Object.Attributes.Group.RawValue)
    
    case objectAttributesIndexTooLarge(Int, maxIndex: Int)
    
    case warmachineFoundInBackback
    case unknownSpriteName(String)
}
