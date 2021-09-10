//
//  Map+Loader+Parser+H3M+CreatureStack.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-24.
//

import Foundation
import Malm


internal extension Map.Loader.Parser.H3M {
    func parseCreatureStacks<I>(
        format: Map.Format,
        count _count: I
    ) throws -> CreatureStacks? where I: FixedWidthInteger {
        let count = Int(_count)
        let stacks: [(CreatureStacks.Slot, CreatureStack?)] = try (0..<count).map { slotIndex in
            let slot = try CreatureStacks.Slot.init(id: .init(slotIndex))
            
            let idRaw: UInt16 = try format == .restorationOfErathia ? UInt16(reader.readUInt8()) : reader.readUInt16()
            let idRawMax: UInt16 =  format == .restorationOfErathia ? 0xff : 0xffff
            let isNotSet: Bool = idRaw == idRawMax
            let isSet = !isNotSet
            let quantity = try CreatureStack.Quantity(reader.readUInt16())
            
            guard quantity > 0, isSet else {
                return (slot, nil)
            }
            
            
            let kind: CreatureStack.Kind = try {

                // Random objects with random army
                if idRaw > (idRawMax - 0xf) {
                    
                    // VCMI:
                    // idRand < 0 -> normal, non-random creature
                    // idRand / 2 -> level
                    // idRand % 2 -> upgrade number
                    
                    let randomIDSeed: Int16 = Int16(bitPattern: idRawMax) - Int16(bitPattern: idRaw) - 1
                    assert(randomIDSeed > 0)
                    
                    let level = try Creature.Level(integer: randomIDSeed / 2)
                    let isUpgraded = randomIDSeed % 2 == 1
                    return .placeholder(level: level, upgraded: isUpgraded)
                } else {
                    let creatureID = try Creature.ID(integer: idRaw)
                    return .specific(creatureID: creatureID)
                }
            }()
            
            let stack = CreatureStack(kind: kind, quantity: quantity)
            return (slot, stack)
        }
        return .init(creatureStackAtSlot: Dictionary.init(uniqueKeysWithValues: stacks))
    }
    
}
