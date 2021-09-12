//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Util

public extension Map {
    struct Mine: Hashable, CustomDebugStringConvertible {
        /// nil means `abandoned mine`
        public let kind: Kind?
        public let owner: Player?
        
        public init(kind: Kind?, owner: Player? = nil) {
            self.kind = kind
            self.owner = owner
        }
    }
}

// MARK: CustomDebugStringConvertible
public extension Map.Mine {
    var debugDescription: String {
        if kind == nil && owner == nil { return "Abandoned mine without owner" }
        let optionalStrings: [String?] = [
            kind.map { "kind: \($0)" },
            owner.map { "owner: \($0)" },
        ]
        
        return optionalStrings.filterNils().joined(separator: "\n")
    }
}


// MARK: Kind
public extension Map.Mine {
    enum Kind: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
        case sawmill,
        alchemistsLab,
        orePit,
        sulfurDune,
        crystalCavern,
        gemPond,
        goldMine,
        abandonedMine
    }
}

// MARK: Kind + CustomDebugStringConvertible
public extension Map.Mine.Kind {
    var debugDescription: String {
        switch self {
        case .sawmill: return "sawmill"
        case .alchemistsLab: return "alchemistsLab"
        case .orePit: return "orePit"
        case .sulfurDune: return "sulfurDune"
        case .crystalCavern: return "crystalCavern"
        case .gemPond: return "gemPond"
        case .goldMine: return "goldMine"
        case .abandonedMine: return "abandonedMine"
        }
    }
}
