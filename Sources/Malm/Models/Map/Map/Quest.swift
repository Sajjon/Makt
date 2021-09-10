//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public struct Quest: Hashable {
    public let kind: Kind
    public let messages: Messages?
    
    /// last day, `nil` means no deadline
    public let deadline: Deadline?
    
    public init(
        kind: Kind,
        messages: Messages? = nil,
        deadline:Deadline? = nil
    ) {
        self.kind = kind
        self.messages = messages
        self.deadline = deadline
    }
}


// MARK: Deadline
public extension Quest {
    typealias Deadline = Int
}

// MARK: Identifier
public extension Quest {
    /// An identifier identifying some object/entity relating to this quest, e.g. a quest identifier for an hero (not Hero.ID (?)) or for a wandering monster (not just a Creature.ID).
    struct Identifier: Hashable {
        public let id: UInt32
        public init(id: UInt32) {
            self.id = id
        }
    }
    
}

// MARK: Messages
public extension Quest {
    struct Messages: Hashable {
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
// MARK: Kind
public extension Quest {
    enum Kind: Hashable {
        case reachPrimarySkillLevels([Hero.PrimarySkill])
        case reachHeroLevel(Int)
        case killHero(Identifier)
        
        case killCreature(Identifier)
        
        case acquireArtifacts([Artifact.ID])
        case raiseArmy(CreatureStacks)
        case acquireResources(Resources)
        case beHero(Hero.ID)
        case bePlayer(Player)
    }
}


// MARK: Kind Stripped
public extension Quest.Kind {
    
    enum Stripped: UInt8, Hashable, CaseIterable {
        case reachHeroLevel = 1
        case reachPrimarySkillLevels
        case killHero
        case killCreature
        case acquireArtifacts
        case raiseArmy
        case acquireResources
        case beHero
        case bePlayer
        case aquireKey
    }
    
}
