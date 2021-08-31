//
//  Map+Loader+Parser+H3M+Object+PandorasBox.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-27.
//

import Foundation

public extension Map {
    struct PandorasBox: Hashable {
        public let message: String?
        public let guards: CreatureStacks?
        public let bounty: Bounty?
        
        public init(
            message: String?,
            guards: CreatureStacks? = nil,
            experiencePointsToBeGained: UInt32 = 0,
            manaPointsToBeGainedOrDrained: Int32 = 0,
            moraleToBeGainedOrDrained: Int8 = 0,
            luckToBeGainedOrDrained: Int8 = 0,
            resourcesToBeGained: Resources?,
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

/// Used in `Map.PandorasBox` and `Map.Event`
public struct Bounty: Hashable {
    internal let experiencePointsToBeGained: UInt32?
    internal let manaPointsToBeGainedOrDrained: Int32?
    internal let moraleToBeGainedOrDrained: Int8?
    internal let luckToBeGainedOrDrained: Int8?
    internal let resourcesToBeGained: Resources?
    internal let primarySkills: [Hero.PrimarySkill]?
    internal let secondarySkills: [Hero.SecondarySkill]?
    internal let artifactIDs: [Artifact.ID]?
    internal let spellIDs: [Spell.ID]?
    internal let creaturesGained: CreatureStacks?
    
    public init?(
        experiencePointsToBeGained: UInt32? = nil,
        manaPointsToBeGainedOrDrained: Int32? = nil,
        moraleToBeGainedOrDrained: Int8? = nil,
        luckToBeGainedOrDrained: Int8? = nil,
        resourcesToBeGained: Resources? = nil,
        primarySkills: [Hero.PrimarySkill]? = nil,
        secondarySkills: [Hero.SecondarySkill]? = nil,
        artifactIDs: [Artifact.ID]? = nil,
        spellIDs: [Spell.ID]? = nil,
        creaturesGained: CreatureStacks? = nil
    ) {
        self.experiencePointsToBeGained = experiencePointsToBeGained
        self.manaPointsToBeGainedOrDrained = manaPointsToBeGainedOrDrained
        self.moraleToBeGainedOrDrained = moraleToBeGainedOrDrained
        self.luckToBeGainedOrDrained = luckToBeGainedOrDrained
        self.resourcesToBeGained = resourcesToBeGained
        self.primarySkills = primarySkills
        self.secondarySkills = secondarySkills
        self.artifactIDs = artifactIDs
        self.spellIDs = spellIDs
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


internal extension Map.Loader.Parser.H3M {

// TODO merge with `parseEvent` ?
func parsePandorasBox(format: Map.Format) throws -> Map.PandorasBox {
    
    let (message, guards) = try parseMessageAndGuards(format: format)
    let experiencePointsToBeGained = try reader.readUInt32()
    let manaPointsToBeGainedOrDrained = try reader.readInt32()
    let moraleToBeGainedOrDrained = try reader.readInt8()
    let luckToBeGainedOrDrained = try reader.readInt8()
    let resourcesToBeGained = try parseResources()
    let primarySkills = try parsePrimarySkills()
    let secondarySkills = try parseSecondarySkills(amount: reader.readUInt8())
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
    
   
