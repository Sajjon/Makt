//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public extension Map {
    struct Grail: Hashable, CustomDebugStringConvertible {
        /// Map Editor "select allowable placement radius"
        public let radius: UInt32
        
        public init(radius: UInt32) {
            self.radius = radius
        }
    }
}

// MARK: CustomDebugStringConvertible
public extension Map.Grail {
    var debugDescription: String {
        "radius: \(radius)"
    }
}
