//
//  Map+Loader+Parser+H3M+Object+PandorasBox.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-27.
//

import Foundation
import Malm



internal extension Map.Loader.Parser.H3M {

// TODO merge with `parseEvent` ?
func parsePandorasBox(format: Map.Format) throws -> Map.PandorasBox {
    
    let (message, guardians) = try parseMessageAndGuardians(format: format)
    let experiencePointsToBeGained = try reader.readUInt32()
    let manaPointsToBeGainedOrDrained = try reader.readInt32()
    let moraleToBeGainedOrDrained = try reader.readInt8()
    let luckToBeGainedOrDrained = try reader.readInt8()
    let resourcesToBeGained = try parseResources()
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
        manaPointsToBeGainedOrDrained: manaPointsToBeGainedOrDrained == 0 ? nil : manaPointsToBeGainedOrDrained,
        moraleToBeGainedOrDrained: moraleToBeGainedOrDrained == 0 ? nil : moraleToBeGainedOrDrained,
        luckToBeGainedOrDrained: luckToBeGainedOrDrained == 0 ? nil : luckToBeGainedOrDrained,
        resourcesToBeGained: (resourcesToBeGained?.resources.isEmpty ?? true) ? nil : resourcesToBeGained,
        primarySkills: primarySkills.isEmpty ? nil : .init(values: primarySkills),
        secondarySkills: secondarySkills.isEmpty ? nil : .init(values: secondarySkills),
        artifactIDs: artifactIDs.isEmpty ? nil : .init(values: artifactIDs),
        spellIDs: spellIDs.isEmpty ? nil : .init(values: spellIDs),
        creaturesGained: creaturesGained
    )
}
}
    
   
