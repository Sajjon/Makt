//
//  CreatureStacks.swift
//  Malm
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation

public struct CreatureStacks: Hashable, CustomDebugStringConvertible, ExpressibleByArrayLiteral {
    
    public let creatureStackAtSlot: [Slot: CreatureStack?]
  
    public init?(creatureStackAtSlot: [Slot: CreatureStack?]) {
        precondition(creatureStackAtSlot.count <= Slot.allCases.count)
        let actual = creatureStackAtSlot.filter { $0.value != nil }
        guard actual.count > 0 else { return nil }
        self.creatureStackAtSlot = actual
    }
    
    public typealias ArrayLiteralElement = CreatureStack
    public init(arrayLiteral stacks: ArrayLiteralElement...) {
        self.init(stacks: stacks)!
    }
}

// MARK: Convenience Init
public extension CreatureStacks {
    init?(stacksAtSlots: [(Slot, CreatureStack?)]) {
        precondition(stacksAtSlots.count <= Slot.allCases.count)
        self.init(creatureStackAtSlot: Dictionary(uniqueKeysWithValues: stacksAtSlots))
    }
    
    init?(stacks: [CreatureStack?]) {
        self.init(stacksAtSlots: Slot.allCases.prefix(stacks.count).enumerated().map({ index, slot in
            return (key: slot, value: stacks[index])
        }))
    }
}

// MARK: Formation
public extension CreatureStacks {
    enum Formation: UInt8, Hashable, CaseIterable {
        /// Spread/Wide
        case spread
        /// Grouped/Tight
        case grouped
    }
}
 
// MARK: Slot
public extension CreatureStacks {
    enum Slot: UInt8, Hashable, CaseIterable {
        case one = 0
        case two
        case three
        case four
        case five
        case six
        case seven
    }
}

// MARK: CustomDebugStringConvertible
public extension CreatureStacks {
    var debugDescription: String {
        creatureStackAtSlot.filter { $0.value != nil }.sorted(by: { $0.key.rawValue < $1.key.rawValue }).map {
            return "[\($0.key.rawValue)]: \($0.value!)"
        }.joined(separator: "\n")
    }
    
}
