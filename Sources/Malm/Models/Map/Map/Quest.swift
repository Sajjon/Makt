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
        public let firstVisitText: String?
        public let nextVisitText: String?
        public let completedText: String?
        
        public init?(
            firstVisitText: String?,
            nextVisitText: String?,
            completedText: String?
        ) {
            guard !(firstVisitText == nil && nextVisitText == nil && completedText == nil) else {
                return nil
            }
            self.firstVisitText = firstVisitText
            self.nextVisitText = nextVisitText
            self.completedText = completedText
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
