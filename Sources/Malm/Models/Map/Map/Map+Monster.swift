//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

public extension Map {
    
    struct Monster: Hashable, CustomDebugStringConvertible, Codable {
        
        public enum Kind: Hashable, Codable {
            case specific(creatureID: Creature.ID)
            case random(level: Creature.Level? = .any)
        }
        
        public let kind: Kind
        
        public let quantity: Quantity
        
        /// unique code for this monster (used in missions)
        public let missionIdentifier: UInt32?
        
        public let message: String?
        public let bounty: Bounty?
        
        public let disposition: Disposition
        
        public let mightFlee: Bool
        public let growsInNumbers: Bool
        
        public init(
            _ kind: Kind,
            quantity: Quantity = .random,
            missionIdentifier: UInt32? = nil,
            message: String? = nil,
            bounty: Bounty? = nil,
            disposition: Disposition = .aggressive,
            
            // Map Editor default is `true`
            mightFlee: Bool = true,
            
            // Map Editor default is `true`
            growsInNumbers: Bool = true
        ) {
            self.kind = kind
            self.quantity = quantity
            self.missionIdentifier = missionIdentifier
            self.message = message
            self.bounty = bounty
            self.disposition = disposition
            self.mightFlee = mightFlee
            self.growsInNumbers = growsInNumbers
        }
        
        public var debugDescription: String {
            let optionalStrings: [String?] = [
                "kind: \(kind)",
                "quantity: \(quantity)",
                missionIdentifier.map { "missionIdentifier: \($0)" } ?? nil,
                message.map { "message: \($0)" } ?? nil,
                bounty.map { "bounty: \($0)" } ?? nil,
                "disposition: \(disposition)",
                "mightFlee: \(mightFlee)",
                "growsInNumbers: \(growsInNumbers)"
            ]
            
            return optionalStrings.compactMap({ $0 }).joined(separator: "\n")
        }
    }
}




public extension Map.Monster {
    struct Bounty: Hashable, Codable {
        public let artifactID: Artifact.ID?
        public let resources: Resources?
        
        public init?(artifactID: Artifact.ID?, resources: Resources?) {
            if artifactID == nil && resources == nil { return nil }
            self.artifactID = artifactID
            self.resources = resources
        }
    }

    enum Disposition: UInt8, Hashable, CaseIterable, Codable {
        
        /// Will **always** join hero
        case compliant
        
        /// *Likely* to join hero
        case friendly
        
        /// *May* join hero
        case aggressive
        
        /// *Unlikely* to join hero
        case hostile
        
        /// Will **never** join hero
        case savage
    }
}
