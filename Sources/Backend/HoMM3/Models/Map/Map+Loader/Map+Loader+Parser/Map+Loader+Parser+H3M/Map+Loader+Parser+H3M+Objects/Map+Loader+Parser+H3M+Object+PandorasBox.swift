//
//  Map+Loader+Parser+H3M+Object+PandorasBox.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-27.
//

import Foundation

public extension Map {
    struct PandorasBox: Hashable {
        private let message: String?
        private let guards: CreatureStacks?
        private let bounty: Bounty?
        
        public init(
            message: String?,
            guards: CreatureStacks? = nil,
            experiencePointsToBeGained: UInt32 = 0,
            manaPointsToBeGainedOrDrained: UInt32 = 0,
            moraleToBeGainedOrDrained: UInt8 = 0,
            luckToBeGainedOrDrained: UInt8 = 0,
            resourcesToBeGained: Resources,
            primarySkills: [Hero.PrimarySkill] = [],
            secondarySkills: [Hero.SecondarySkill] = [],
            artifactIDs: [Artifact.ID] = [],
            spellIDs: [Spell.ID] = [],
            creaturesGained: CreatureStacks? = nil
        ) {
            self.guards = guards
            self.message = message
            self.bounty = .init(
                experiencePointsToBeGained: experiencePointsToBeGained,
                manaPointsToBeGainedOrDrained: manaPointsToBeGainedOrDrained,
                moraleToBeGainedOrDrained: moraleToBeGainedOrDrained,
                luckToBeGainedOrDrained: luckToBeGainedOrDrained,
                resourcesToBeGained: resourcesToBeGained,
                primarySkills: primarySkills,
                secondarySkills: secondarySkills,
                artifactIDs: artifactIDs,
                spellIDs: spellIDs,
                creaturesGained: creaturesGained
            )
            
            
        }
    }
}

public extension Map.PandorasBox {
    
    
    struct Bounty: Hashable {
        private let experiencePointsToBeGained: UInt32?
        private let manaPointsToBeGainedOrDrained: UInt32?
        private let moraleToBeGainedOrDrained: UInt8?
        private let luckToBeGainedOrDrained: UInt8?
        private let resourcesToBeGained: Resources?
        private let primarySkills: [Hero.PrimarySkill]?
        private let secondarySkills: [Hero.SecondarySkill]?
        private let artifactIDs: [Artifact.ID]?
        private let spellIDs: [Spell.ID]?
        private let creaturesGained: CreatureStacks?
        
        public init?(
            experiencePointsToBeGained: UInt32,
            manaPointsToBeGainedOrDrained: UInt32,
            moraleToBeGainedOrDrained: UInt8,
            luckToBeGainedOrDrained: UInt8,
            resourcesToBeGained: Resources,
            primarySkills: [Hero.PrimarySkill],
            secondarySkills: [Hero.SecondarySkill],
            artifactIDs: [Artifact.ID],
            spellIDs: [Spell.ID],
            creaturesGained: CreatureStacks?
        ) {
            self.experiencePointsToBeGained = experiencePointsToBeGained == 0 ? nil : experiencePointsToBeGained
            self.manaPointsToBeGainedOrDrained = manaPointsToBeGainedOrDrained == 0 ? nil : manaPointsToBeGainedOrDrained
            self.moraleToBeGainedOrDrained = moraleToBeGainedOrDrained == 0 ? nil : moraleToBeGainedOrDrained
            self.luckToBeGainedOrDrained = luckToBeGainedOrDrained == 0 ? nil : luckToBeGainedOrDrained
            self.resourcesToBeGained = resourcesToBeGained.resources.count == 0 ? nil : resourcesToBeGained
            self.primarySkills = primarySkills.count == 0 ? nil : primarySkills
            self.secondarySkills = secondarySkills.count == 0 ? nil : secondarySkills
            self.artifactIDs = artifactIDs.count == 0 ? nil : artifactIDs
            self.spellIDs = spellIDs.count == 0 ? nil : spellIDs
            self.creaturesGained = creaturesGained
            if
                self.experiencePointsToBeGained == nil &&
                    self.manaPointsToBeGainedOrDrained == nil &&
                    self.moraleToBeGainedOrDrained == nil &&
                    self.luckToBeGainedOrDrained == nil &&
                    self.resourcesToBeGained == nil &&
                    self.primarySkills == nil &&
                    self.secondarySkills == nil &&
                    self.artifactIDs == nil &&
                    self.spellIDs == nil &&
                    self.creaturesGained == nil {
                return nil
            }
        }
    }
    
}

internal extension Map.Loader.Parser.H3M {
    
    // TODO merge with `parseEvent` ?
    func parsePandorasBox(format: Map.Format) throws -> Map.PandorasBox {
        
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
        
        return .init(
            message: message,
            guards: guards,
            experiencePointsToBeGained: experiencePointsToBeGained,
            manaPointsToBeGainedOrDrained: manaPointsToBeGainedOrDrained,
            moraleToBeGainedOrDrained: moraleToBeGainedOrDrained,
            luckToBeGainedOrDrained: luckToBeGainedOrDrained,
            resourcesToBeGained: resourcesToBeGained,
            primarySkills: primarySkills,
            secondarySkills: secondarySkills,
            artifactIDs: artifactIDs,
            spellIDs: spellIDSs,
            creaturesGained: creaturesGained
        )
    }
}
