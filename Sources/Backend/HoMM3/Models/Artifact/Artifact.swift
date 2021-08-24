//
//  Artifact.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public struct Artifact: Hashable, Identifiable {
    public let id: ID
    
    /// In case of artifact ID being `spellScroll`
    private var spellID: Spell.ID? // TODO improve this... using enum with associated value? => `Artifact.ID` -> `Artifact.ID.Stripped` and `Artifact.ID` will have associated values? Just for this case? Hmm... Might be beneficial for modelling combination artifacts though...
    
    private init(id: ID, spellID: Spell.ID?) {
        self.id = id
        self.spellID = spellID
    }
    
    public init(id: ID) {
        self.init(id: id, spellID: nil)
    }
}

public extension Artifact {
    static func scroll(spell spellID: Spell.ID) -> Self {
        .init(id: .spellScroll, spellID: spellID)
    }
}
