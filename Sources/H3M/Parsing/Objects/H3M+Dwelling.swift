//
//  Map+Loader+Parser+H3M+Object+RandomDwelling.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-27.
//

import Foundation
import Malm
import Common

internal extension H3M {
  
    func parseDwelling(attributes: Map.Object.Attributes) throws -> Map.Dwelling {
        let owner = try parseOwner()
        try reader.skip(byteCount: 3)
        
        func parsePossibleFactions() throws -> Map.Dwelling.Kind.Random.PossibleFaction {
            let townIDRaw = try reader.readUInt32()
            if townIDRaw == 0 {
                return try .anyOf(.init(values: parseBitmaskOfEnum(byteCount: 2)))
            } else {
                return .sameAsTown(.fromMapFile(townIDRaw))
            }
        }
        
        func getLevelRange() throws -> Map.Dwelling.Kind.Random.PossibleLevels.Range {
            let minLevel = try  Creature.Level(integer: reader.readUInt8())
            let maxLevel = try  Creature.Level(integer: reader.readUInt8())
            return .init(min: minLevel, max: maxLevel)
        }
        
        switch attributes.objectID {
        case .randomDwelling:
            let possibleFactions = try parsePossibleFactions()
            let range = try getLevelRange()
            
            return .random(.init(
                possibleFactions: possibleFactions,
                possibleLevels: .range(range)
            ), owner: owner)
            
        case .randomDwellingAtLevel(let level):
            let possibleFactions = try parsePossibleFactions()
            return .random(.init(
                possibleFactions: possibleFactions,
                possibleLevels: .specific(level)
            ), owner: owner)
            
        case .randomDwellingOfFaction(let faction):
            let range = try getLevelRange()
            return .random(.init(
                possibleFactions: .anyOf(.init(values: [faction])),
                possibleLevels: .range(range)
            ), owner: owner)
            
        case .creatureGenerator1(let id):
            return .specificGenerator(id, owner: owner)
            
        case .creatureGenerator2:
            return .specific(.creatureGenerator2, owner: owner)
            
        case .creatureGenerator3:
            return .specific(.creatureGenerator3, owner: owner)
            
        case .creatureGenerator4(let unknownBool):
            return .specific(.creatureGenerator4(unknownBool: unknownBool), owner: owner)
        
        default:
            incorrectImplementation(shouldAlreadyHave: "Handled all cases of dwelling, object attrubutes: \(attributes)")
        }

    }
}
