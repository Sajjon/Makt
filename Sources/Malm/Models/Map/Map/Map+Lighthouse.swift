//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

public extension Map {
    
    struct Lighthouse: Hashable, Codable {
        public let owner: Player?
        
        public init(owner: Player?) {
            self.owner = owner
        }
    }
    
}
