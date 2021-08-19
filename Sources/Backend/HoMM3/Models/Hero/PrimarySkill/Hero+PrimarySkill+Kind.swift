//
//  Hero+PrimarySkill+Kind.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Hero.PrimarySkill {
    enum Kind: UInt8, CaseIterable, Comparable {
        case attack, defense, power, knowledge
        
        public init?(rawValue: UInt8) {
            switch rawValue {
            case Self.attack.rawValue: self = .attack
            case Self.defense.rawValue: self = .defense
            case Self.power.rawValue: self = .power
            case Self.knowledge.rawValue: self = .knowledge
            case 4:
                fatalError("Aha! VCMI Did include a fourth case named `case experience = 4` for a reason. With the comment `for some reason changePrimSkill uses it`. ")
            default: return nil
            }
        }
    }
}
