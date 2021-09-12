//
//  Map+Loader+Parser+H3M+Object+RandomDwelling.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-27.
//

import Foundation
import Malm

internal extension H3M {
  
    func parseDwelling(objectID: Map.Object.ID) throws -> Map.Dwelling {
        let owner = try parseOwner()
        try reader.skip(byteCount: 3)
        
        func parseAllowedFactions() throws -> [Faction] {
            try reader.readUInt32() != 0 ? .allCases : parseBitmaskOfEnum(byteCount: 2)
        }
        
        func getLevelRange() throws -> (min: Creature.Level, max: Creature.Level) {
            let minLevel = try  Creature.Level(integer: reader.readUInt8())
            let maxLevel = try  Creature.Level(integer: reader.readUInt8())
            return (min: minLevel, max: maxLevel)
        }
        
        switch objectID {
        case .randomDwelling:
            let allowedFactions = try parseAllowedFactions()
            let levels = try getLevelRange()
        case .randomDwellingAtLevel(let level):
            let allowedFactions = try parseAllowedFactions()
        case .randomDwellingOfFaction(let faction):
            let levels = try getLevelRange()
        case .creatureGenerator1(let id): break
        case .creatureGenerator2: break
        case .creatureGenerator3: break
        case .creatureGenerator4(let unknownBool):
            break
        default: fatalError("incorrect implementation, unhandled objectID: \(objectID)")
        }
      
        let dwellng = Map.Dwelling(id: objectID, owner: owner)
        // TODO fix creature dwelling above...
        return dwellng
    }
}
