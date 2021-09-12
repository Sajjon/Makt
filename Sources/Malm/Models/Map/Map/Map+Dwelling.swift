//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Util

public extension Map {
    struct Dwelling: Hashable {
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
    enum Kind: Hashable {
        case random(Random)
        case specific(Specific)
    }
}

public extension Map.Dwelling.Kind {
    struct Random: Hashable {
        public let possibleFactions: Factions
        public let possibleLevels: PossibleLevels
        
        public init(
            possibleFactions: Factions = .init(values: Faction.playable(in: .restorationOfErathia)),
            possibleLevels: PossibleLevels = .all
        ) {
            precondition(!possibleFactions.isEmpty)
            self.possibleFactions = possibleFactions
            self.possibleLevels = possibleLevels
        }
    }
    
    enum Specific: Hashable {
        case specificGenerator(Map.Object.CreatureGenerator.ID)
        
        case creatureGenerator2
        case creatureGenerator3
        
        case creatureGenerator4(unknownBool: Bool)
    }
}

public extension Map.Dwelling.Kind.Random {
    
    enum PossibleLevels: Hashable, CustomDebugStringConvertible {
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
    struct Range: Hashable, CustomDebugStringConvertible {
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
