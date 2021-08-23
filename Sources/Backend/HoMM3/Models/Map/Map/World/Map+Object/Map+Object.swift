//
//  Map+Object.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct Objects: Hashable {
        public let objects: [Object]
    }
  
    struct Object: Hashable {
        public let position: Position
        public let objectID: Object.ID
        public let kind: Kind
    }
}

public extension Map.Object {
    enum Kind: Hashable {
        case event(Map.Event)
        case hero(Hero)
        case town(Map.Town)
        case monster(Map.Monster)
    }
}

public extension Map {
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
