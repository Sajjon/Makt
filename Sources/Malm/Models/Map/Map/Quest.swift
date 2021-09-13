//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Util

public struct Quest: Hashable, CustomDebugStringConvertible {
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
    
    var debugDescription: String {
        let optionalStrings: [String?] = [
            "kind: \(kind)",
            messages.map({ "messages: \($0)" }),
            deadline.map({ "deadline: \($0)" })
        ]
        return optionalStrings.filterNils().joined(separator: "\n")
    }
    
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
    struct Messages: Hashable, CustomDebugStringConvertible {
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
    
    
    enum Kind: Hashable, CustomDebugStringConvertible {
        case reachPrimarySkillLevels(Hero.PrimarySkills)
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
    
    var debugDescription: String {
        switch self {
        case .reachPrimarySkillLevels(let primarySkills): return "reachPrimarySkillLevels(\(primarySkills))"
        case .reachHeroLevel(let level): return "reachHeroLevel(\(level))"
        case .killHero(let hero): return "killHero(\(hero))"
        case .killCreature(let creature): return "killCreature(\(creature))"
        case .acquireArtifacts(let artifact): return "acquireArtifacts(\(artifact))"
        case .raiseArmy(let army): return "raiseArmy(\(army))"
        case .acquireResources(let resources): return "acquireResources(\(resources))"
        case .beHero(let hero): return "beHero(\(hero))"
        case .bePlayer(let player): return "bePlayer(\(player))"
        }
    }
    
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
