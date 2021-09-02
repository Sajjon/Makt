//
//  Artifact.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public struct Artifact: Hashable {
    public enum Kind: Hashable {
        case specific(artifactID: ID)
        case spell(Spell.ID)
        
        /// `nil` means "any class".
        case random(class: Class?)
    }
    
    public let kind: Kind
    private init(kind: Kind) {
        self.kind = kind
    }
}

public extension Artifact {
    
    
    enum Class: String, CaseIterable, Hashable {
        case treasure, minor, major, relic
        static let any = Self?.none
    }
    
    static func scroll(spell spellID: Spell.ID) -> Self {
        .init(kind: .spell(spellID))
    }
    
    static func random(`class`: Class?) -> Self { .init(kind: .random(class: `class`)) }
    
    static func specific(id artifactID: Artifact.ID) -> Self {
        .init(kind: .specific(artifactID: artifactID))
    }
}
