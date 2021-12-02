//
//  Hero+PrimarySkill.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero {
    struct PrimarySkill: Hashable, CustomDebugStringConvertible, Codable {
        
        public typealias Level = Int
        
        public let kind: Kind
        public let level: Level
        
        public init(kind: Kind, level: Level) {
            self.kind = kind
            self.level = level
        }
    }
}

// MARK: Factory
public extension Hero.PrimarySkill {
    static func attack(_ level: Level) -> Self {
        .init(kind: .attack, level: level)
    }
    
    static func defense(_ level: Level) -> Self {
        .init(kind: .defense, level: level)
    }
    
    static func power(_ level: Level) -> Self {
        .init(kind: .power, level: level)
    }
    
    static func knowledge(_ level: Level) -> Self {
        .init(kind: .knowledge, level: level)
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
