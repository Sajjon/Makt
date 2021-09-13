//
//  Hero+SecondarySkill.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero {
    struct SecondarySkill: CategorizedByKind, CustomDebugStringConvertible {
        public let kind: Kind
        public let level: Level
        
        public init(kind: Kind, level: Level) {
            self.kind = kind
            self.level = level
        }
        
    }
}


public extension Hero.SecondarySkill {
    var debugDescription: String {
        [
            "kind: \(kind)",
            "level: \(level)"
        ].joined(separator: "\n")
    }
}
