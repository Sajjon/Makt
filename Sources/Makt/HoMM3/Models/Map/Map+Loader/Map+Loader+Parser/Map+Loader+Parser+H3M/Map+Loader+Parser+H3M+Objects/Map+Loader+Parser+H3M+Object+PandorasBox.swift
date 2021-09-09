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
            experiencePointsToBeGained.map { xp -> String? in
                guard xp > 0 else { return nil }
                return "xp: \(xp)"
            } ?? nil,
            manaPointsToBeGainedOrDrained.map { mana -> String? in guard mana > 0 else { return nil }; return "mana: \(mana)" } ?? nil,
            moraleToBeGainedOrDrained.map { morale -> String? in guard morale > 0 else { return nil }; return "morale: \(morale)" } ?? nil,
            luckToBeGainedOrDrained.map { luck -> String? in guard luck > 0 else { return nil }; return "luck: \(luck)" } ?? nil,
            resourcesToBeGained.map { res -> String? in guard !res.resources.isEmpty else { return nil }; return "resources: \(res)" } ?? nil,
            primarySkills.map { ps -> String? in guard !ps.isEmpty else { return nil }; return "primary: \(ps)" } ?? nil,
            secondarySkills.map { ss -> String? in guard !ss.isEmpty else { return nil }; return "secondary: \(ss)" } ?? nil,
            artifactIDs.map { a -> String? in guard !a.isEmpty else { return nil }; return "artifactIDs: \(a)" } ?? nil,
            spellIDs.map { s  -> String? in guard !s.isEmpty else { return nil }; return "spells: \(s)" } ?? nil,
            creaturesGained.map { c -> String? in  guard !c.creatureStackAtSlot.isEmpty else { return nil }; return "creaturesGained: \(c)" } ?? nil
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
    
   
