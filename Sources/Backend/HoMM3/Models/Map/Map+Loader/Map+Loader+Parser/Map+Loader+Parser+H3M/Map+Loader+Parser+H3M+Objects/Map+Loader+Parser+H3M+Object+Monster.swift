//
//  Map+Loader+Parser+H3M+Object+Monster.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-23.
//

import Foundation


internal extension Map.Loader.Parser.H3M {
    
    func parseRandomMonster(format: Map.Format) throws -> Map.Monster {
        try parseRandomMonster(format: format, level: .random())
    }
    
    func parseRandomMonster(format: Map.Format, level: Creature.Level) throws -> Map.Monster {
        try parseMonster(format: format, creatureID: Creature.ID.at(level: level, .nonUpgradedAndUpgraded).randomElement()!)
    }
    
    func parseMonster(format: Map.Format, creatureID: Creature.ID) throws -> Map.Monster {
        let missionIdentifier: UInt32? = try {
            guard format > .restorationOfErathia else { return nil }
            return try reader.readUInt32()
        }()
        
        let quantityRaw = try reader.readUInt16()
        let quantity: Map.Monster.Quantity = quantityRaw == 0 ? .random : .custom(quantityRaw)
        let disposition = try Map.Monster.Disposition(integer: reader.readUInt8())
        let hasMessageOrResourcesOrArtifact = try reader.readBool()
        
        var message: String?
        var resources: Resources?
        var artifactID: Artifact.ID?
        if hasMessageOrResourcesOrArtifact {
            message = try reader.readString(maxByteCount: 8192)
            resources = try parseResources()
            artifactID = try parseArtifactID(format: format)
        }
        let neverFlees = try reader.readBool()
        let doesNotGrowInNumber = try reader.readBool()

        if quantityRaw != 0 {
            print("🍄 quantityRaw: \(quantityRaw), creatureID: \(creatureID)")
        }
        
        try reader.skip(byteCount: 2)
        
        return .init(
            creatureID: creatureID,
            quantity: quantity,
            missionIdentifier: missionIdentifier,
            message: message,
            
            bounty: .init(
                artifactID: artifactID,
                resources: resources
            ),
            
            disposition: disposition,
            willNeverFlee: neverFlees,
            doesNotGrowInNumbers: doesNotGrowInNumber
        )
    }
    
}

