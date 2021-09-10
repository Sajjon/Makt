//
//  Map+LossCondition.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Map {
    struct LossCondition: Hashable {
        public let kind: Kind
        
        public init(kind: Kind) {
            self.kind = kind
        }
    }
}


public extension Map.LossCondition {
    
    static let standard = Self(kind: .standard)
    
    enum Kind: Hashable, CustomDebugStringConvertible {
        /// You lose if the specified hero is defeated.
        case loseSpecificHero(locatedAt: Position)
            
        /// You lose if the specified town is occupied by an enemy.
        case loseSpecificTown(locatedAt: Position)

        /// You lose if you have not won the scenario within the specified number of days.
        case timeLimit(dayCount: Int)
        
        /// Lose control of all towns for a period (typically seven days) or have the last hero defeated while controlling no towns.
        ///
        /// This is considered the "standard" condition.
        case loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns
        
    }
    
}

public extension Map.LossCondition.Kind {

    var debugDescription: String {
        switch self {
        case .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns: return "standard"
        case .loseSpecificHero(let heroPosition): return "lose hero@\(heroPosition)"
        case .loseSpecificTown(let townPosition): return "lose town@\(townPosition)"
        case .timeLimit(let dayCount): return "Times up after \(dayCount) days"
        }
    }
    
    
    static let standard: Self = .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns
    
    
    var stripped: Stripped {
        switch self {
        case .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns: return .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns
        case .loseSpecificHero: return .loseSpecificHero
        case .loseSpecificTown: return .loseSpecificTown
        case .timeLimit: return .timeLimit
        }
    }
    
}


public extension Map.LossCondition.Kind {
    enum Stripped: UInt8, Hashable, CustomStringConvertible {
        
        /// You lose if the specified town is occupied by an enemy.
        case loseSpecificTown
        
        /// You lose if the specified hero is defeated.
        case loseSpecificHero

        /// You lose if you have not won the scenario within the specified number of days.
        case timeLimit
        
        /// Lose control of all towns for a period (typically seven days) or have the last hero defeated while controlling no towns.
        ///
        /// This is considered the "standard" condition.
        case loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns = 255
    }
}

public extension Map.LossCondition.Kind.Stripped {
    static let standard: Self = .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns
    
    var description: String {
        switch self {
        case .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns: return "loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns"
        case .loseSpecificHero: return "loseSpecificHero"
        case .loseSpecificTown: return "loseSpecificTown"
        case .timeLimit: return "timeLimit"
        }
    }
}

public extension Map.LossCondition.Kind {
    var position: Position? {
        switch self {
        case .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns, .timeLimit: return nil
        case .loseSpecificHero(let heroPosition): return heroPosition
        case .loseSpecificTown(let townPosition): return townPosition
        }
    }
}

public extension Map.LossCondition {
    var position: Position? { kind.position }
}

