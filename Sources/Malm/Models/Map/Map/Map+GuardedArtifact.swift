//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Util

public extension Map {
    struct GuardedArtifact: Hashable, CustomDebugStringConvertible, Codable {
        public let artifact: Artifact
        public let message: String?
        public let guardians: CreatureStacks?
        public init(_ artifact: Artifact, message: String? = nil, guardians: CreatureStacks? = nil) {
            self.artifact = artifact
            self.message = message
            self.guardians = guardians
        }
    }
    
}

// MARK: CustomDebugStringConvertible
public extension Map.GuardedArtifact {
    var debugDescription: String {
        [
            "artifact: \(artifact)",
            message.map { "message: \($0)" },
            guardians.map { "guardians: \($0)" }
        ].filterNils().joined(separator: "\n")
    }
}

// MARK: Factory
public extension Map.GuardedArtifact {
    static func specific(id artifactID: Artifact.ID, message: String? = nil, guardians: CreatureStacks? = nil) -> Self {
        .init(.specific(id: artifactID), message: message, guardians: guardians)
    }
    static func random(`class`: Artifact.Class?, message: String? = nil, guardians: CreatureStacks? = nil) -> Self {
        .init(.random(class: `class`), message: message, guardians: guardians)
    }
    static func scroll(spell spellID: Spell.ID, message: String? = nil, guardians: CreatureStacks? = nil) -> Self {
        .init(.scroll(spell: spellID), message: message, guardians: guardians)
    }
}
