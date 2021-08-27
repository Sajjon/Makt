//
//  Map+Object.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct DetailsAboutObjects: Hashable {
        public let objects: [Object]
    }
    
    struct GlobalEvents: Hashable {
        public let events: [Event]
    }
  
    struct Object: Hashable, CustomDebugStringConvertible {
        public let position: Position
        public let attributes: Map.Object.Attributes
        public let kind: Kind
    }
    
    
    struct GuardedArtifact: Hashable {
        public let message: String?
        public let guards: CreatureStacks?
        public let artifact: Artifact
    }
    
    struct Dwelling: Hashable {
        public let owner: PlayerColor?
        public let id: Object.ID
    }
    
    struct GuardedResource: Hashable {
        public let message: String?
        public let guards: CreatureStacks?
        public let resource: Resource
    }
    
    struct Garrison: Hashable {
        let owner: PlayerColor?
        let creatures: CreatureStacks?
        let areCreaturesRemovable: Bool
    }
    
    
    struct Grail: Hashable {
        public let radius: UInt32
    }
}

public extension Map.Object {
    var objectID: ID { attributes.objectID }
}

public extension Map.Object {

    var debugDescription: String {
        """
        =========================================
        \(objectID.name) @ \(position)
        -----------------------------------------
            \(kind)
        =========================================
        """
    }
    
    enum Kind: Hashable {
        case generic
        case garrison(Map.Garrison)
        case artifact(Map.GuardedArtifact)
        case resource(Map.GuardedResource)
        case event(Map.Event)
        case dwelling(Map.Dwelling)
        case hero(Hero)
        case mine(Map.Mine)
        case town(Map.Town)
        case shipyard(Map.Shipyard)
        case shrine(Map.Shrine)
        case sign(Map.Sign)
        case oceanBottle(Map.OceanBottle)
        case scholar(Map.Scholar)
        case seershut(Map.Seershut)
        case monster(Map.Monster)
        case pandorasBox(Map.PandorasBox)
        case questGuard(Quest)
        case witchHut(Map.WitchHut)
        case lighthouse(Map.Lighthouse)
        case grail(Map.Grail)
        
    }
}

public extension Map {
    
    struct WitchHut: Hashable {
        public let learnableSkills: [Hero.SecondarySkill.Kind]
    }
    
    struct Lighthouse: Hashable {
        public let owner: PlayerColor?
    }
    
    
    struct Monster: Hashable {
        public let creatureStack: CreatureStack
        /// unique code for this monster (used in missions)
        public let missionIdentifier: UInt32?
        
        public let message: String?
        public let bounty: Bounty?
        
        public let hostility: Hostility
        public let willNeverFlee: Bool
        public let doesNotGrowInNumbers: Bool
    }
}

public extension Map.Monster {
    struct Bounty: Hashable {
        public let artifactID: Artifact.ID?
        public let resources: Resources?
    }
    enum Hostility: UInt8, Hashable, CaseIterable {
        case compliant,
             friendly,
             aggressive,
             hostile,
             savage
    }
}
