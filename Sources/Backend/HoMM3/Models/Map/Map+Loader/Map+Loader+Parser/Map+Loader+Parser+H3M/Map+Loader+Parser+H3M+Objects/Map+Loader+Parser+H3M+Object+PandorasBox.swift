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
            experiencePointsToBeGained: UInt32? = nil,
            manaPointsToBeGainedOrDrained: Int32? = nil,
            moraleToBeGainedOrDrained: Int8? = nil,
            luckToBeGainedOrDrained: Int8? = nil,
            resourcesToBeGained: Resources?,
            primarySkills: Hero.PrimarySkills? = nil,
            secondarySkills: Hero.SecondarySkills? = nil,
            artifactIDs: ArtifactIDs? = nil,
            spellIDs: SpellIDs? = nil,
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

/// Used in `Map.PandorasBox` and `Map.GeoEvent`
public struct Bounty: Hashable, CustomDebugStringConvertible {
    internal let experiencePointsToBeGained: UInt32?
    internal let manaPointsToBeGainedOrDrained: Int32?
    internal let moraleToBeGainedOrDrained: Int8?
    internal let luckToBeGainedOrDrained: Int8?
    internal let resourcesToBeGained: Resources?
    internal let primarySkills: Hero.PrimarySkills?
    internal let secondarySkills: Hero.SecondarySkills?
    internal let artifactIDs: ArtifactIDs?
    internal let spellIDs: SpellIDs?
    internal let creaturesGained: CreatureStacks?
    
    public init?(
        experiencePointsToBeGained: UInt32? = nil,
        manaPointsToBeGainedOrDrained: Int32? = nil,
        moraleToBeGainedOrDrained: Int8? = nil,
        luckToBeGainedOrDrained: Int8? = nil,
        resourcesToBeGained: Resources? = nil,
        primarySkills: Hero.PrimarySkills? = nil,
        secondarySkills: Hero.SecondarySkills? = nil,
        artifactIDs: ArtifactIDs? = nil,
        spellIDs: SpellIDs? = nil,
        creaturesGained: CreatureStacks? = nil
    ) {
        self.experiencePointsToBeGained = experiencePointsToBeGained
        self.manaPointsToBeGainedOrDrained = manaPointsToBeGainedOrDrained
        self.moraleToBeGainedOrDrained = moraleToBeGainedOrDrained
        self.luckToBeGainedOrDrained = luckToBeGainedOrDrained
        self.resourcesToBeGained = resourcesToBeGained
        self.primarySkills = primarySkills?.allSatisfy({ $0.level == 0 }) == true ? nil : primarySkills
        self.secondarySkills = secondarySkills
        self.artifactIDs = artifactIDs
        self.spellIDs = spellIDs
        self.creaturesGained = (creaturesGained?.creatureStackAtSlot.isEmpty == true || creaturesGained?.creatureStackAtSlot.allSatisfy({ $0.value?.quantity == 0 }) == true) ? nil : creaturesGained
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
    

    public var debugDescription: String {
        let stringOptionals: [String?] = [
            experiencePointsToBeGained.map { guard $0 > 0 else { return nil }; return "xp: \($0)" } ?? nil,
            manaPointsToBeGainedOrDrained.map { guard $0 > 0 else { return nil }; return "mana: \($0)" } ?? nil,
            moraleToBeGainedOrDrained.map { guard $0 > 0 else { return nil }; return "morale: \($0)" } ?? nil,
            luckToBeGainedOrDrained.map { guard $0 > 0 else { return nil }; return "luck: \($0)" } ?? nil,
            resourcesToBeGained.map { guard !$0.resources.isEmpty else { return nil }; return "resources: \($0)" } ?? nil,
            primarySkills.map { guard !$0.isEmpty else { return nil }; return "primary: \($0)" } ?? nil,
            secondarySkills.map { guard !$0.isEmpty else { return nil }; return "secondary: \($0)" } ?? nil,
            artifactIDs.map { guard !$0.isEmpty else { return nil }; return "artifactIDs: \($0)" } ?? nil,
            spellIDs.map { guard !$0.isEmpty else { return nil }; return "spells: \($0)" } ?? nil,
            creaturesGained.map { guard !$0.creatureStackAtSlot.isEmpty else { return nil }; return "creaturesGained: \($0)" } ?? nil
       ]
            
        return stringOptionals.compactMap({ $0 }).joined(separator: "\n")
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
    let spellIDs = try parseSpellCountAndIDs()
    let creaturesGained = try parseCreatureStacks(format: format, count: reader.readUInt8())
    
    try reader.skip(byteCount: 8) // unknown?
    
    return .init(
        message: message,
        guards: guards,
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
    
   
