//
//  Map+Loader+Parser+H3M+Object+Event.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation


// MARK: Parse Event
internal extension Map.Loader.Parser.H3M {
    
    func parseMessageAndGuards(format: Map.Format) throws -> (message: String?, guards: CreatureStacks?) {
        let hasMessage = try reader.readBool()
        let message: String? = try hasMessage ? reader.readString() : nil
        let guards: CreatureStacks? = try hasMessage ? {
            let hasGuardsAsWell = try reader.readBool()
            var guards: CreatureStacks?
            if hasGuardsAsWell {
                guards = try parseCreatureStacks(format: format, count: 7)
            }
            try reader.skip(byteCount: 4) // unknown?
            return guards
        }() : nil
        return (message, guards)
    }
    
    func parseEvent(format: Map.Format) throws -> Map.Event {
        let (message, guards) = try parseMessageAndGuards(format: format)
        let experiencePointsToBeGained = try reader.readUInt32()
        let manaPointsToBeGainedOrDrained = try reader.readUInt32()
        let moraleToBeGainedOrDrained = try reader.readUInt8()
        let luckToBeGainedOrDrained = try reader.readUInt8()
        let resourcesToBeGained = try parseResources()
        let primarySkills = try parsePrimarySkills()
        let secondarySkills = try parseSecondarySkills()
        let artifactIDs = try parseArtifactIDs(format: format)
        let spellIDSs = try parseSpellCountAndIDs()
        let creaturesGained = try parseCreatureStacks(format: format, count: reader.readUInt8())
        
        try reader.skip(byteCount: 8) // unknown?
        let availableForPlayers = try parseAvailableForPlayers()
        let canBeActivatedByComputer = try reader.readBool()
        let shouldBeRemovedAfterVisit = try reader.readBool()
        try reader.skip(byteCount: 4) // unknown?
        
        return .init(
            message: message,
            guards: guards,
            experiencePointsToBeGained: .init(experiencePointsToBeGained),
            manaPointsToBeGainedOrDrained: .init(manaPointsToBeGainedOrDrained),
            moraleToBeGainedOrDrained: .init(moraleToBeGainedOrDrained),
            luckToBeGainedOrDrained: .init(luckToBeGainedOrDrained),
            resourcesToBeGained: resourcesToBeGained,
            primarySkills: primarySkills,
            secondarySkills: secondarySkills,
            artifactIDs: artifactIDs,
            spellIDs: spellIDSs,
            creaturesGained: creaturesGained,
            availableForPlayers: availableForPlayers,
            canBeActivatedByComputer: canBeActivatedByComputer,
            shouldBeRemovedAfterVisit: shouldBeRemovedAfterVisit,
            canBeActivatedByHuman: true // yes hardcoded
        )
        
    }
    
}