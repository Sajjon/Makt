//
//  Map+Loader+Parser+H3M+Object+PandorasBox.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-27.
//

import Foundation
import Malm

internal extension H3M {
    
    func parsePandorasBox(format: Map.Format) throws -> Map.PandorasBox {
        
        let (message, guardians) = try parseMessageAndGuardians(format: format)
        
        let experiencePointsToBeGained = try reader.readUInt32()
        let spellPointsToBeGainedOrDrained = try reader.readInt32()
        let moraleToBeGainedOrDrained = try reader.readInt8()
        let luckToBeGainedOrDrained = try reader.readInt8()
        let resources = try parseResources()
        let primarySkills = try parsePrimarySkills()
        let secondarySkills = try parseSecondarySkills(amount: reader.readUInt8())
        let artifactIDs = try parseArtifactIDs(format: format)
        let spellIDs = try parseSpellCountAndIDs()
        let creaturesGained = try parseCreatureStacks(format: format, count: reader.readUInt8())
        
        try reader.skip(byteCount: 8) // unknown?
        
        return .init(
            message: message,
            guardians: guardians,
            experiencePointsToBeGained: experiencePointsToBeGained == 0 ? nil : experiencePointsToBeGained,
            spellPointsToBeGainedOrDrained: spellPointsToBeGainedOrDrained == 0 ? nil : spellPointsToBeGainedOrDrained,
            moraleToBeGainedOrDrained: moraleToBeGainedOrDrained == 0 ? nil : moraleToBeGainedOrDrained,
            luckToBeGainedOrDrained: luckToBeGainedOrDrained == 0 ? nil : luckToBeGainedOrDrained,
            resources: (resources?.resources.isEmpty ?? true) ? nil : resources,
            primarySkills: primarySkills,
            secondarySkills: secondarySkills.isEmpty ? nil : .init(values: secondarySkills),
            artifactIDs: artifactIDs.isEmpty ? nil : .init(values: artifactIDs),
            spellIDs: spellIDs.isEmpty ? nil : .init(values: spellIDs),
            creaturesGained: creaturesGained
        )
    }
    
    func parseSpellCountAndIDs() throws -> [Spell.ID] {
        try reader.readUInt8().nTimes {
            try Spell.ID(integer: reader.readInt8())
        }
    }
}


