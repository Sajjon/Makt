//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public extension Map {
    
    struct Dwelling: Hashable, CustomDebugStringConvertible {
        public let id: Object.ID
        public let owner: Player?
        
        public init(id: Object.ID, owner: Player? = nil) {
            self.id = id
            self.owner = owner
        }
    }
    
}

public extension Map.Dwelling {
    var debugDescription: String {
        "id: \(id), owner: \(owner)"
    }
}
