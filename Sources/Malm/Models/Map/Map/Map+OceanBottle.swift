//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

public extension Map {
    struct OceanBottle: Hashable, Codable {
        public let message: String? // yes indeed optional.
        
        public init(message: String?) {
            self.message = message
        }
    }
}
