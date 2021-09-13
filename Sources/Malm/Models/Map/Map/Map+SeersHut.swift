//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public extension Map {
    struct Seershut: Hashable {
        public let quest: Quest?
        public let bounty: Bounty?
        
        public init(quest: Quest?, bounty: Bounty?) {
            self.quest = quest
            self.bounty = bounty
        }
        
        public static let empty: Self = .init(quest: nil, bounty: nil)
        
        
        public enum Bounty: Hashable {
            case experience(UInt32)
            case spellPoints(UInt32)
            case moraleBonus(UInt8)
            case luckBonus(UInt8)
            case resource(Resource)
            case primarySkill(Hero.PrimarySkill)
            case secondarySkill(Hero.SecondarySkill)
            case artifact(Artifact.ID)
            case spell(Spell.ID)
            case creature(CreatureStack)
            case aquireKey(Map.Object.KeymastersTentType)
        }
    }
}



public extension Map.Seershut.Bounty {
    
    enum Stripped: UInt8, Hashable, CaseIterable {
        // 0 is none
        case experience = 1
        case spellPoints
        case moraleBonus
        case luckBonus
        case resource
        case primarySkill
        case secondarySkill
        case artifact
        case spell
        case creature
    }
}
