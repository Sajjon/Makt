//
//  Artifact.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public struct Artifact: Hashable {
    
    public let kind: Kind
    
    public init(kind: Kind) {
        self.kind = kind
    }
}

// MARK: Kind
public extension Artifact {
    enum Kind: Hashable {
        case specific(artifactID: ID)
        case spell(Spell.ID)
        
        /// `nil` means "any class".
        case random(class: Class?)
    }
}

// MARK: Class
public extension Artifact {
    enum Class: String, CaseIterable, Hashable {
        case treasure, minor, major, relic
    }
}
public extension Artifact.Class {
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
