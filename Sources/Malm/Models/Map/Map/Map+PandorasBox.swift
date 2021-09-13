//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public extension Map {
    struct PandorasBox: Hashable {
        public let message: String?
        public let guardians: CreatureStacks?
        public let bounty: Bounty?
        
        public init(
            message: String? = nil,
            guardians: CreatureStacks? = nil,
            experiencePointsToBeGained: UInt32? = nil,
            manaPointsToBeGainedOrDrained: Int32? = nil,
            moraleToBeGainedOrDrained: Int8? = nil,
            luckToBeGainedOrDrained: Int8? = nil,
            resources: Resources? = nil,
            primarySkills: Hero.PrimarySkills? = nil,
            secondarySkills: Hero.SecondarySkills? = nil,
            artifactIDs: ArtifactIDs? = nil,
            spellIDs: SpellIDs? = nil,
            creaturesGained: CreatureStacks? = nil
        ) {
            self.guardians = guardians
            self.message = message
            self.bounty = .init(
                experiencePointsToBeGained: experiencePointsToBeGained,
                manaPointsToBeGainedOrDrained: manaPointsToBeGainedOrDrained,
                moraleToBeGainedOrDrained: moraleToBeGainedOrDrained,
                luckToBeGainedOrDrained: luckToBeGainedOrDrained,
                resources: resources,
                primarySkills: primarySkills,
                secondarySkills: secondarySkills,
                artifactIDs: artifactIDs,
                spellIDs: spellIDs,
                creaturesGained: creaturesGained
            )
        }
    }
}
