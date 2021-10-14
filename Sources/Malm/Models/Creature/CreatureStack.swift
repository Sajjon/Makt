//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public struct CreatureStack: Hashable, CustomDebugStringConvertible, Codable {
    public let kind: Kind
    public let quantity: Quantity
    
    public init(
        kind: Kind,
        quantity: Quantity
    ) {
        self.kind = kind
        self.quantity = quantity
    }
   
}

// MARK: CustomDebugStringConvertible
public extension CreatureStack {
    var debugDescription: String {
        "\(kind): \(quantity)"
    }
}

// MARK: Public
public extension CreatureStack {
    
    typealias Quantity = Int
    
    static func specific(id creatureID: Creature.ID, quantity: Quantity) -> Self {
        .init(kind: .specific(creatureID: creatureID), quantity: quantity)
    }
    
    static func placeholder(level: Creature.Level, upgraded: Bool, quantity: Quantity) -> Self {
        .init(kind: .placeholder(level: level, upgraded: upgraded), quantity: quantity)
    }
}

// MARK: Kind
public extension CreatureStack {
    
    enum Kind: Hashable, CustomDebugStringConvertible, Codable {
        case specific(creatureID: Creature.ID)

        /// Used in as garrison in e.g. Random Towns
        case placeholder(level: Creature.Level, upgraded: Bool)
    }
}

// MARK: CustomDebugStringConvertible
public extension CreatureStack.Kind {
    
    var debugDescription: String {
        switch self {
        case .placeholder(let level, let upgraded): return "level: \(level), upgraded: \(upgraded)"
        case .specific(let creatureID): return "\(creatureID)"
        }
    }
}
