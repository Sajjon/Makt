//
//  Hero+PrimarySkill.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero {
    struct PrimarySkill: Hashable, CustomDebugStringConvertible {
        
        public typealias Level = Int
        
        public let kind: Kind
        public let level: Level
        
        public init(kind: Kind, level: Level) {
            self.kind = kind
            self.level = level
        }
    }
}

public extension Hero.PrimarySkill {
    var debugDescription: String {
        [
            "kind: \(kind)",
            "level: \(level)"
        ].joined(separator: "\n")
    }
}
