//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Malm
import Util

internal extension H3M {
    
    func parseQuest() throws -> Quest {
        let questKindStripped = try Quest.Kind.Stripped(integer: reader.readUInt8())
        let questKind: Quest.Kind
        switch questKindStripped {
        case .reachPrimarySkillLevels:
            guard let skills = try parsePrimarySkills() else {
                incorrectImplementation(reason: "Should not have all zero primary skills (which equals to nil) as quest goal?")
            }
            questKind = .reachPrimarySkillLevels(skills)
        case .reachHeroLevel:
            questKind = try .reachHeroLevel(.init(reader.readUInt32()))
        case .killHero:
            questKind = try .killHero(Quest.Identifier(id: reader.readUInt32()))
        case .killCreature:
            questKind = try .killCreature(Quest.Identifier(id: reader.readUInt32()))
        case .acquireArtifacts:
            // For some reason the artifact IDs in the Quest is ALWAYS represented as UInt16, thus we hardcode `shadowOfDeath` as map format which will result in UInt16s being read as rawValue for each artifact.
            questKind = try .acquireArtifacts(parseArtifactIDs(format: .shadowOfDeath))
        case .raiseArmy:
            // For some reason the creature IDs in the Quest is ALWAYS represented as UInt16, thus we hardcode `shadowOfDeath` as map format which will result in UInt16s being read as rawValue for each creature type.
            questKind  = try .raiseArmy(parseCreatureStacks(format: .shadowOfDeath, count: reader.readUInt8())!)
        case .acquireResources:
            questKind = try .acquireResources(parseResources()!)
        case .beHero:
            questKind = try .beHero(.init(integer: reader.readUInt8()))
        case .bePlayer:
            questKind = try .bePlayer(.init(integer: reader.readUInt8()))
        case .aquireKey:
            incorrectImplementation(reason: "Should not have Acquire Key as quest in this context.")
        }
        
        let limit = try reader.readUInt32()
        let deadline: Int? = limit == .max ? nil : .init(limit)
        
        // Map "The story of the Fool (Traemask2.h3m") 9697 bytes...
        let maxStringLength: UInt32 = 10_000
        let proposalMessage = try reader.readString(maxByteCount: maxStringLength)
        let progressMessage = try reader.readString(maxByteCount: maxStringLength)
        let completionMessage = try reader.readString(maxByteCount: maxStringLength)
        
       
        
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
