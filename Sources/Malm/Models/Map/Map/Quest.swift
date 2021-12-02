//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Common


public struct Quest: Hashable, CustomDebugStringConvertible, Codable {
    public let kind: Kind
    public let messages: Messages?
    
    /// last day, `nil` means no deadline
    public let deadline: Date?
    
    public init(
        kind: Kind,
        messages: Messages? = nil,
        deadline: Date? = nil
    ) {
        self.kind = kind
        self.messages = messages
        self.deadline = deadline
    }
}


// MARK: Deadline
public extension Quest {
    
    var debugDescription: String {
        let optionalStrings: [String?] = [
            "kind: \(kind)",
            messages.map({ "messages: \($0)" }),
            deadline.map({ "deadline: \($0)" })
        ]
        return optionalStrings.filterNils().joined(separator: "\n")
    }
    
}

// MARK: Identifier
public extension Quest {
    /// An identifier identifying some object/entity relating to this quest, e.g. a quest identifier for an hero (not Hero.ID (?)) or for a wandering monster (not just a Creature.ID).
    struct Identifier: Hashable, Codable {
        public let id: UInt32
        public init(id: UInt32) {
            self.id = id
        }
    }
    
}

// MARK: Messages
public extension Quest {
    struct Messages: Hashable, CustomDebugStringConvertible, Codable {
        public let proposalMessage: String?
        public let progressMessage: String?
        public let completionMessage: String?
        
        public init?(
            proposalMessage: String?,
            progressMessage: String?,
            completionMessage: String?
        ) {
            guard !(proposalMessage == nil && progressMessage == nil && completionMessage == nil) else {
                return nil
            }
            self.proposalMessage = proposalMessage
            self.progressMessage = progressMessage
            self.completionMessage = completionMessage
        }
    }
    
}

public extension Quest.Messages {
    var debugDescription: String {
        if proposalMessage == nil && progressMessage == nil && completionMessage == nil {
            return "No messages."
        }
        let optionalStrings: [String?] = [
            proposalMessage.map({ "proposal: \($0)" }),
            progressMessage.map({ "progress: \($0)" }),
            completionMessage.map({ "completion: \($0)" }),
        ]
        return optionalStrings.filterNils().joined(separator: "\n")
    }
}


// MARK: Kind
public extension Quest {
    
    
    enum Kind: Hashable, CustomDebugStringConvertible, Codable {
        case archievePrimarySkillLevels(Hero.PrimarySkills)
        case archieveExperienceLevel(Int)
        case defeatHero(Identifier)
        
        case defeatCreature(Identifier)
        
        case returnWithArtifacts([Artifact.ID])
        case returnWithCreatures(CreatureStacks)
        case returnWithResources(Resources)
        case beHero(Hero.ID)
        case belongToPlayer(Player)
    }
}


// MARK: Kind Stripped
public extension Quest.Kind {
    
    var debugDescription: String {
        switch self {
        case .archievePrimarySkillLevels(let primarySkills): return "archievePrimarySkillLevels(\(primarySkills))"
        case .archieveExperienceLevel(let level): return "archieveExperienceLevel(\(level))"
        case .defeatHero(let hero): return "defeatHero(\(hero))"
        case .defeatCreature(let creature): return "defeatCreature(\(creature))"
        case .returnWithArtifacts(let artifact): return "returnWithArtifacts(\(artifact))"
        case .returnWithCreatures(let army): return "returnWithCreatures(\(army))"
        case .returnWithResources(let resources): return "returnWithResources(\(resources))"
        case .beHero(let hero): return "beHero(\(hero))"
        case .belongToPlayer(let player): return "belongToPlayer(\(player))"
        }
    }
    
    enum Stripped: UInt8, Hashable, CaseIterable {
        case archieveExperienceLevel = 1
        case archievePrimarySkillLevels
        case defeatHero
        case defeatCreature
        case returnWithArtifacts
        case returnWithCreatures
        case returnWithResources
        case beHero
        case belongToPlayer
        case aquireKey
    }
    
}
