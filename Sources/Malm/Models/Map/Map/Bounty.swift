//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

/// Used in `Map.PandorasBox` and `Map.GeoEvent`
public struct Bounty: Hashable, CustomDebugStringConvertible, Codable {
    internal let experiencePointsToBeGained: UInt32?
    internal let spellPointsToBeGainedOrDrained: Int32?
    internal let moraleToBeGainedOrDrained: Int8?
    internal let luckToBeGainedOrDrained: Int8?
    internal let resources: Resources?
    internal let primarySkills: Hero.PrimarySkills?
    internal let secondarySkills: Hero.SecondarySkills?
    internal let artifactIDs: ArtifactIDs?
    internal let spellIDs: SpellIDs?
    internal let creaturesGained: CreatureStacks?
    
    public init?(
        experiencePointsToBeGained: UInt32? = nil,
        spellPointsToBeGainedOrDrained: Int32? = nil,
        moraleToBeGainedOrDrained: Int8? = nil,
        luckToBeGainedOrDrained: Int8? = nil,
        resources: Resources? = nil,
        primarySkills: Hero.PrimarySkills? = nil,
        secondarySkills: Hero.SecondarySkills? = nil,
        artifactIDs: ArtifactIDs? = nil,
        spellIDs: SpellIDs? = nil,
        creaturesGained: CreatureStacks? = nil
    ) {
        self.experiencePointsToBeGained = experiencePointsToBeGained
        self.spellPointsToBeGainedOrDrained = spellPointsToBeGainedOrDrained
        self.moraleToBeGainedOrDrained = moraleToBeGainedOrDrained
        self.luckToBeGainedOrDrained = luckToBeGainedOrDrained
        self.resources = resources
        self.primarySkills = primarySkills
        self.secondarySkills = secondarySkills
        self.artifactIDs = artifactIDs
        self.spellIDs = spellIDs
        self.creaturesGained = (creaturesGained?.creatureStackAtSlot.isEmpty == true || creaturesGained?.creatureStackAtSlot.allSatisfy({ $0.value?.quantity == 0 }) == true) ? nil : creaturesGained
        if
            self.experiencePointsToBeGained == nil &&
                self.spellPointsToBeGainedOrDrained == nil &&
                self.moraleToBeGainedOrDrained == nil &&
                self.luckToBeGainedOrDrained == nil &&
                self.resources == nil &&
                self.primarySkills == nil &&
                self.secondarySkills == nil &&
                self.artifactIDs == nil &&
                self.spellIDs == nil &&
                self.creaturesGained == nil {
            return nil
        }
    }
    

    public var debugDescription: String {
        let stringOptionals: [String?] = [
            experiencePointsToBeGained.map { xp -> String? in
                guard xp > 0 else { return nil }
                return "xp: \(xp)"
            } ?? nil,
            spellPointsToBeGainedOrDrained.map { mana -> String? in guard mana > 0 else { return nil }; return "mana: \(mana)" } ?? nil,
            moraleToBeGainedOrDrained.map { morale -> String? in guard morale > 0 else { return nil }; return "morale: \(morale)" } ?? nil,
            luckToBeGainedOrDrained.map { luck -> String? in guard luck > 0 else { return nil }; return "luck: \(luck)" } ?? nil,
            resources.map { res -> String? in guard !res.resources.isEmpty else { return nil }; return "resources: \(res)" } ?? nil,
            primarySkills.map { "primary: \($0)" },
            secondarySkills.map { ss -> String? in guard !ss.isEmpty else { return nil }; return "secondary: \(ss)" } ?? nil,
            artifactIDs.map { a -> String? in guard !a.isEmpty else { return nil }; return "artifactIDs: \(a)" } ?? nil,
            spellIDs.map { s  -> String? in guard !s.isEmpty else { return nil }; return "spells: \(s)" } ?? nil,
            creaturesGained.map { c -> String? in  guard !c.creatureStackAtSlot.isEmpty else { return nil }; return "creaturesGained: \(c)" } ?? nil
       ]
            
        return stringOptionals.compactMap({ $0 }).joined(separator: "\n")
    }
}
