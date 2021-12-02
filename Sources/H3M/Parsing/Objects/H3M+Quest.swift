//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Malm
import Common

internal extension H3M {
    
    func parseQuest() throws -> Quest? {
        let questKindStrippedRaw = try reader.readUInt8()
        guard questKindStrippedRaw > 0 else {
            // A Seers Hut without any quest.
            return nil
        }
        let questKindStripped = try Quest.Kind.Stripped(integer: questKindStrippedRaw)
        let questKind: Quest.Kind
        switch questKindStripped {
        case .archievePrimarySkillLevels:
            guard let skills = try parsePrimarySkills() else {
                incorrectImplementation(reason: "Should not have all zero primary skills (which equals to nil) as quest goal?")
            }
            questKind = .archievePrimarySkillLevels(skills)
        case .archieveExperienceLevel:
            questKind = try .archieveExperienceLevel(.init(reader.readUInt32()))
        case .defeatHero:
            questKind = try .defeatHero(Quest.Identifier(id: reader.readUInt32()))
        case .defeatCreature:
            questKind = try .defeatCreature(Quest.Identifier(id: reader.readUInt32()))
        case .returnWithArtifacts:
            // For some reason the artifact IDs in the Quest is ALWAYS represented as UInt16, thus we hardcode `shadowOfDeath` as map format which will result in UInt16s being read as rawValue for each artifact.
            questKind = try .returnWithArtifacts(parseArtifactIDs(format: .shadowOfDeath))
        case .returnWithCreatures:
            // For some reason the creature IDs in the Quest is ALWAYS represented as UInt16, thus we hardcode `shadowOfDeath` as map format which will result in UInt16s being read as rawValue for each creature type.
            questKind  = try .returnWithCreatures(parseCreatureStacks(format: .shadowOfDeath, count: reader.readUInt8())!)
        case .returnWithResources:
            questKind = try .returnWithResources(parseResources()!)
        case .beHero:
            questKind = try .beHero(.init(integer: reader.readUInt8()))
        case .belongToPlayer:
            questKind = try .belongToPlayer(.init(integer: reader.readUInt8()))
        case .aquireKey:
            incorrectImplementation(reason: "Should not have Acquire Key as quest in this context.")
        }
        
        let limit = try reader.readUInt32()
        let deadline: Date? = limit == .max ? nil : Date(daysPassed: .init(limit))
        
        // Map "The story of the Fool (Traemask2.h3m") 9697 bytes...
        let maxStringLength: UInt32 = 10_000
        let proposalMessage = try reader.readLengthOfStringAndString(assertingMaxLength: maxStringLength)
        let progressMessage = try reader.readLengthOfStringAndString(assertingMaxLength: maxStringLength)
        let completionMessage = try reader.readLengthOfStringAndString(assertingMaxLength: maxStringLength)
        
       
        
        return Quest(
            kind: questKind,
            messages: .init(
                proposalMessage: proposalMessage,
                progressMessage: progressMessage,
                completionMessage: completionMessage
            ),
            deadline: deadline
        )
    }
}
