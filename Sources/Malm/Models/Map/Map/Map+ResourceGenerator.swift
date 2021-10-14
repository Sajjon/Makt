//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Util

public extension Map {
    struct ResourceGenerator: Hashable, CustomDebugStringConvertible, Codable {
        public let kind: Kind
        public let owner: Player?
        
        public init(kind: Kind, owner: Player? = nil) {
            self.kind = kind
            self.owner = owner
        }
    }
}

// MARK: CustomDebugStringConvertible
public extension Map.ResourceGenerator {
    var debugDescription: String {
        let optionalStrings: [String?] = [
            "kind: \(kind)",
            owner.map { "owner: \($0)" },
        ]
        
        return optionalStrings.filterNils().joined(separator: "\n")
    }
}



public extension Map.ResourceGenerator {
    
    enum Kind: Hashable, CaseIterable, CustomDebugStringConvertible, Codable {
        case sawmill,
             alchemistsLab,
             orePit,
             sulfurDune,
             crystalCavern,
             gemPond,
             goldMine
    }
}

// MARK: Kind + CustomDebugStringConvertible
public extension Map.ResourceGenerator.Kind {
    
    /// Placeholder kind that might be abandoned.
    enum Placeholder: UInt8, Hashable, CaseIterable, Codable {
        case sawmill,
             alchemistsLab,
             orePit,
             sulfurDune,
             crystalCavern,
             gemPond,
             goldMine,
             abandonedMine
    }
    
    var debugDescription: String {
        switch self {
        case .sawmill: return "sawmill"
        case .alchemistsLab: return "alchemistsLab"
        case .orePit: return "orePit"
        case .sulfurDune: return "sulfurDune"
        case .crystalCavern: return "crystalCavern"
        case .gemPond: return "gemPond"
        case .goldMine: return "goldMine"
        }
    }
}
