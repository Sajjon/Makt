//
//  Artifact.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public struct Artifact: Hashable, CustomDebugStringConvertible, Codable {
    
    public let kind: Kind
    
    public init(kind: Kind) {
        self.kind = kind
    }
    
    public var debugDescription: String {
        """
        kind: \(kind)
        """
    }
}

// MARK: Kind
public extension Artifact {
    enum Kind: Hashable, CustomDebugStringConvertible, Codable {
        case specific(artifactID: ID)
        case spell(Spell.ID)
        
        /// `nil` means "any class".
        case random(class: Class?)
        
        public var debugDescription: String {
            switch self {
            case .specific(let artifactID): return "specific(artifactID: \(artifactID)"
            case .spell(let spellID): return "spell(id: \(spellID)"
            case .random(let artifactClass):
                let classString = artifactClass?.debugDescription ?? "any"
                return "randomArtifact(class: \(classString)"
            }
        }
    }
}

// MARK: Class
public extension Artifact {
    enum Class: String, CaseIterable, Hashable, CustomDebugStringConvertible, Codable {
        case treasure, minor, major, relic
    }
}
public extension Artifact.Class {
    
    var debugDescription: String {
        switch self {
        case .treasure: return "treasure"
        case .minor: return "minor"
        case .major: return "major"
        case .relic: return "relic"
        }
    }
    
    static let any: Self? = nil
}


// MARK: Factory
public extension Artifact {
    static func scroll(spell spellID: Spell.ID) -> Self {
        .init(kind: .spell(spellID))
    }
    
    static func random(`class`: Class?) -> Self { .init(kind: .random(class: `class`)) }
    
    static func specific(id artifactID: Artifact.ID) -> Self {
        .init(kind: .specific(artifactID: artifactID))
    }
}
