//
//  Map+Loader+Parser+H3M+Object+Monster.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-23.
//

import Foundation
import Malm
import Util

internal extension H3M {
  
    
    func parseMonsterObject(id objectID: Map.Object.ID, format: Map.Format) throws -> Map.Monster {
        switch objectID {
        case .monster(let creatureID):
            return try
            parseMonster(format: format, kind: .specific(creatureID: creatureID))
        case .randomMonsterLevel1:
            return try parseRandomMonster(format: format, level: .one)
        case .randomMonsterLevel2:
            return try parseRandomMonster(format: format, level: .two)
        case .randomMonsterLevel3:
            return try parseRandomMonster(format: format, level: .three)
        case .randomMonsterLevel4:
            return try
            parseRandomMonster(format: format, level: .four)
        case .randomMonsterLevel5:
            return try parseRandomMonster(format: format, level: .five)
        case .randomMonsterLevel6:
            return try  parseRandomMonster(format: format, level: .six)
        case .randomMonsterLevel7:
            return try parseRandomMonster(format: format, level: .seven)
        case .randomMonster:
            return try parseRandomMonster(format: format)
        default: incorrectImplementation(shouldAlreadyHave: "handled object id: \(objectID) in an earlier switch.")
        }
    }
    
    
    func parseRandomMonster(format: Map.Format, level: Creature.Level? = .any) throws -> Map.Monster {
        try parseMonster(
            format: format,
            kind: .random(level: level)
        )
    }
    
    func parseMonster(format: Map.Format, kind: Map.Monster.Kind) throws -> Map.Monster {
        let missionIdentifier: UInt32? = try {
            guard format > .restorationOfErathia else { return nil }
            return try reader.readUInt32()
        }()
        
        let quantityRaw = try reader.readUInt16()
        let quantity: Quantity = quantityRaw == 0 ? .random : .specified(.init(quantityRaw))
        let disposition = try Map.Monster.Disposition(integer: reader.readUInt8())
        let hasMessageOrResourcesOrArtifact = try reader.readBool()
        
        var message: String?
        var resources: Resources?
        var artifactID: Artifact.ID?
        
        if hasMessageOrResourcesOrArtifact {
            message = try reader.readLengthOfStringAndString(assertingMaxLength: 8192)
            resources = try parseResources()
            artifactID = try parseArtifactID(format: format)
        }
        
        let neverFlees = try reader.readBool()
        let doesNotGrowInNumber = try reader.readBool()
        
        try reader.skip(byteCount: 2)
        
        return .init(
            kind,
            quantity: quantity,
            missionIdentifier: missionIdentifier,
            message: message,
            
            bounty: .init(
                artifactID: artifactID,
                resources: resources
            ),
            
            disposition: disposition,
            mightFlee: !neverFlees,
            growsInNumbers: !doesNotGrowInNumber
        )
    }
    
}

