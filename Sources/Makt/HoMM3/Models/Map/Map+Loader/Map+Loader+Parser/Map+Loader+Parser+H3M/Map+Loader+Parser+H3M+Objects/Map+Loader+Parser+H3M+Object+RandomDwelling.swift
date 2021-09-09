//
//  Map+Loader+Parser+H3M+Object+RandomDwelling.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-27.
//

import Foundation


extension Map.Loader.Parser.H3M {
    func parseBitmask<Case>(of cases: [Case], byteCount maybeByteCount: Int? = nil) throws -> [Case] where Case: CaseIterable, Case.AllCases == [Case] {
        
        let caseCount = cases.count
        let qor = caseCount.quotientAndRemainder(dividingBy: 8)
        let byteCount = maybeByteCount ?? (qor.remainder == 0 ? qor.quotient : qor.quotient + 1)
        
        return try Array(
            reader
                .readBitArray(byteCount: byteCount)
                .reversed()
                .prefix(caseCount)
        )
        .enumerated()
        .compactMap { (index, available) in
            guard available else { return nil }
            return cases[index]
        }
    }
    
    func parseBitmask<Enum>(as enum: Enum.Type, byteCount: Int? = nil) throws -> [Enum] where Enum: CaseIterable, Enum.AllCases == [Enum] {
        try parseBitmask(of: `enum`.allCases, byteCount: byteCount)
    }
    
    func parseBitmaskOfEnum<Enum>(byteCount: Int? = nil) throws -> [Enum] where Enum: CaseIterable, Enum.AllCases == [Enum] {
        try parseBitmask(of: Enum.allCases, byteCount: byteCount)
    }
}


internal extension Map.Loader.Parser.H3M {
  
    func parseDwelling(objectID: Map.Object.ID) throws -> Map.Dwelling {
        let owner = try parseOwner()
        try reader.skip(byteCount: 3)
        
        func getAllowedFaction_OR_WHAT_SHOULD_THIS_FUNC_DO() throws -> [Faction] {
            let identifier = try reader.readUInt32()
            if identifier == 0 {
                let availableFactions = Faction.playable(in: .restorationOfErathia)
                assert(availableFactions.count == 8)
                
                func readAllowedFactions() throws -> [Faction] {
                    try reader.readBitArray(byteCount: 1).prefix(availableFactions.count).enumerated().compactMap({ factionIndex, available in
                        guard available else { return nil }
                        return availableFactions[factionIndex]
                    })
                }
                
                let allowedFactions = try Set(readAllowedFactions()).intersection(readAllowedFactions())
                return Array(allowedFactions)
            } else {
                return [.castle]
            }
        }
        
        func getLevelRange() throws -> (min: Creature.Level, max: Creature.Level) {
            let minLevel = try  Creature.Level(integer: reader.readUInt8())
            let maxLevel = try  Creature.Level(integer: reader.readUInt8())
            return (min: minLevel, max: maxLevel)
        }
        
        switch objectID {
        case .randomDwelling: // 216
            let allowedFactions = try getAllowedFaction_OR_WHAT_SHOULD_THIS_FUNC_DO()
            let levels = try getLevelRange()
        case .randomDwellingAtLevel(let level): // 217
            let allowedFactions = try getAllowedFaction_OR_WHAT_SHOULD_THIS_FUNC_DO()
        case .randomDwellingOfFaction(let faction): // 218
            let levels = try getLevelRange()
        case .creatureGenerator1(let id): break
        case .creatureGenerator2: break
        case .creatureGenerator3: break
        case .creatureGenerator4(let unknownBool):
            break
        default: fatalError("incorrect implementation, unhandled objectID: \(objectID)")
        }
      
        let dwellng = Map.Dwelling(owner: owner, id: objectID)
        // TODO fix creature dwelling above...
        return dwellng
    }
}
