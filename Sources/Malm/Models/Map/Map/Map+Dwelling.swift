//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Common

public extension Map {
    struct Dwelling: Hashable, Codable {
        public let kind: Kind
        public let owner: Player?
        
        public init(kind: Kind, owner: Player? = nil) {
            self.kind = kind
            self.owner = owner
        }
    }
}

public extension Map.Dwelling {
    static func random(_ randomKind: Kind.Random, owner: Player? = nil) -> Self {
        .init(kind: .random(randomKind), owner: owner)
    }
    
    static func specific(_ specific: Kind.Specific, owner: Player? = nil) -> Self {
        .init(kind: .specific(specific), owner: owner)
    }
    
    static func specificGenerator(_ generatorID: Map.Object.CreatureGenerator.ID, owner: Player? = nil) -> Self {
        .init(kind: .specific(.specificGenerator(generatorID)), owner: owner)
    }
}

public extension Map.Dwelling {
    enum Kind: Hashable, Codable {
        case random(Random)
        case specific(Specific)
    }
}

public extension Map.Dwelling.Kind {
    struct Random: Hashable, Codable {
        public enum PossibleFaction: Hashable, Codable {
            case anyOf(Factions)
            case sameAsTown(Map.Town.ID)
        }
        public let possibleFactions: PossibleFaction
        public let possibleLevels: PossibleLevels
        
        public init(
            possibleFactions: PossibleFaction,
            possibleLevels: PossibleLevels = .all
        ) {
            if case let .anyOf(factions) = possibleFactions {
                precondition(!factions.isEmpty)
            }
            self.possibleFactions = possibleFactions
            self.possibleLevels = possibleLevels
        }
        
        public static func anyFaction(of factions: Factions, possibleLevels: PossibleLevels = .all) -> Self {
            .init(possibleFactions: .anyOf(factions), possibleLevels: possibleLevels)
        }
        
        public static func sameFactionAsTown(id townID: Map.Town.ID, possibleLevels: PossibleLevels = .all) -> Self {
            .init(possibleFactions: .sameAsTown(townID), possibleLevels: possibleLevels)
        }
    }
    
    enum Specific: Hashable, Codable {
        case specificGenerator(Map.Object.CreatureGenerator.ID)
        
        case creatureGenerator2
        case creatureGenerator3
        
        case creatureGenerator4(unknownBool: Bool)
    }
}

public extension Map.Dwelling.Kind.Random {
    
    enum PossibleLevels: Hashable, CustomDebugStringConvertible, Codable {
        case range(Range)
        case specific(Creature.Level)
        
        #if WOG
        public static let all: Self = .range(.init(min: .one, max: .eight))
        #else
        public static let all: Self = .range(.init(min: .one, max: .seven))
        #endif // if WOG
        
        public var debugDescription: String {
            switch self {
            case .range(let range): return range.debugDescription
            case .specific(let level): return "level: \(level)"
            }
        }
    }
}

public extension Map.Dwelling.Kind.Random.PossibleLevels {
    struct Range: Hashable, CustomDebugStringConvertible, Codable {
        public let min: Creature.Level
        public let max: Creature.Level
        public init(min: Creature.Level, max: Creature.Level) {
            precondition(max >= min)
            self.min = min
            self.max = max
        }
    }
}

public extension Map.Dwelling.Kind.Random.PossibleLevels.Range {
    var debugDescription: String {
        "(\(min) - \(max)"
    }
}
