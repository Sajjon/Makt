//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public extension Map {
    
    struct Garrison: Hashable, CustomDebugStringConvertible {
        
        public let areCreaturesRemovable: Bool
        public let owner: Player?
        public let creatures: CreatureStacks?
        
        public init(
            areCreaturesRemovable: Bool,
            owner: Player? = nil,
            creatures: CreatureStacks? = nil
        ) {
            self.areCreaturesRemovable = areCreaturesRemovable
            self.owner = owner
            self.creatures = creatures
        }
    }
}

public extension Map.Garrison {
    var debugDescription: String {
        let optionalStrings: [String?] = [
            "areCreaturesRemovable: \(areCreaturesRemovable)",
            owner.map { "owner: \($0)" },
            creatures.map { "creatures: \($0)" }
        ]
        
        return optionalStrings.filterNils().joined(separator: "\n")
    }
}
