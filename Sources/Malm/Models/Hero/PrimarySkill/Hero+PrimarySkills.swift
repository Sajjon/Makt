//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-12.
//

import Foundation
import Util

public extension Hero {
    struct PrimarySkills: Hashable, CustomDebugStringConvertible, ExpressibleByArrayLiteral, Codable {
        
        public static let defaultLevel: PrimarySkill.Level = 0
        
        public let attack: PrimarySkill.Level
        public let defense: PrimarySkill.Level
        public let power: PrimarySkill.Level
        public let knowledge: PrimarySkill.Level
        
        public init(
            attack: PrimarySkill.Level = Self.defaultLevel,
            defense: PrimarySkill.Level = Self.defaultLevel,
            power: PrimarySkill.Level = Self.defaultLevel,
            knowledge: PrimarySkill.Level = Self.defaultLevel
        ) {
            self.attack = attack
            self.defense = defense
            self.power = power
            self.knowledge = knowledge
        }
        
        public init?(skills: [PrimarySkill]) throws {
            guard !skills.allSatisfy({ $0.level == 0 }) else { return nil }
            guard skills.count <= 4 else { throw Error.tooManySkills(count: skills.count) }
    
            func level(of kind: PrimarySkill.Kind) throws -> PrimarySkill.Level {
                let predicate: (PrimarySkill) -> Bool = { $0.kind == kind }
                let skillsOfKind = skills.filter(predicate)
                guard skillsOfKind.count < 2 else {
                    throw Error.duplicatedSkill(kind: kind)
                }
                return skillsOfKind.first?.level ?? Self.defaultLevel
            }
            
            self.init(
                attack: try level(of: .attack),
                defense: try level(of: .defense),
                power: try level(of: .power),
                knowledge: try level(of: .knowledge)
            )
            
        }
        
        public typealias ArrayLiteralElement = PrimarySkill
        public init(arrayLiteral skills: ArrayLiteralElement...) {
            try! self.init(skills: skills)!
        }
        
        public enum Error: Swift.Error {
            case tooManySkills(count: Int)
            case duplicatedSkill(kind: PrimarySkill.Kind)
        }
    }
}

public extension Hero.PrimarySkills {
    var debugDescription: String {
        """
        attack: \(attack)
        defense: \(defense)
        power: \(power)
        knowledge: \(knowledge)
        """
    }
}
