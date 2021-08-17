//
//  Map+LossCondition.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Map {
    struct LossCondition: Equatable {
        public let kind: Kind
    }
}


public extension Map.LossCondition {
    
    static let standard = Self(kind: .standard)
    
    enum Kind: Equatable {
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
    enum Stripped: UInt8, Equatable {
        
        /// You lose if the specified town is occupied by an enemy.
        case loseSpecificTown = 0
        
        /// You lose if the specified hero is defeated.
        case loseSpecificHero = 1

        /// You lose if you have not won the scenario within the specified number of days.
        case timeLimit = 2
        
        /// Lose control of all towns for a period (typically seven days) or have the last hero defeated while controlling no towns.
        ///
        /// This is considered the "standard" condition.
        case loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns = 255
    }
}

public extension Map.LossCondition.Kind.Stripped {
    static let standard: Self = .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns
}


public extension Map.LossCondition.Kind {
    
    enum Error: Swift.Error {
        case positionIsRequired(for: Stripped)
        case missingParameter(contents: String, for: Stripped)
    }
    
    init(
        stripped: Stripped,
        parameter1: Int? = nil,
        position: Position? = nil
    ) throws {
        
        func ensurePosition() throws -> Position {
            guard let position = position else {
                throw Error.positionIsRequired(for: stripped)
            }
            return position
        }
        
        func ensureParameter(contents: String) throws -> Int {
            guard let parameter = parameter1 else {
                throw Error.missingParameter(contents: contents, for: stripped)
            }
            return parameter
        }
        switch stripped {
        case .loseSpecificTown:
            assert(parameter1 == nil)
            self = .loseSpecificTown(locatedAt: try ensurePosition())
        case .loseSpecificHero:
            assert(parameter1 == nil)
            self = .loseSpecificHero(locatedAt: try ensurePosition())
        case .timeLimit:
            assert(position == nil)
            self = .timeLimit(dayCount: try ensureParameter(contents: "Days until time limit runs out"))
        case .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns:
            assert(parameter1 == nil)
            assert(position == nil)
            self = .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns
        }
    }
}
