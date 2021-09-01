//
//  Map+Loader+Parser+H3M+CreatureStack.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-24.
//

import Foundation


internal extension Map.Loader.Parser.H3M {
    func parseCreatureStacks<I>(
        format: Map.Format,
        count _count: I
    ) throws -> CreatureStacks? where I: FixedWidthInteger {
        let count = Int(_count)
        let stacks: [(CreatureStacks.Slot, CreatureStack?)] = try (0..<count).map { slotIndex in
            let slot = try CreatureStacks.Slot.init(id: .init(slotIndex))
            
            let idRaw: UInt16 = try format == .restorationOfErathia ? UInt16(reader.readUInt8()) : reader.readUInt16()
            let isNotSet: Bool = format == .restorationOfErathia ? idRaw == 0xff : idRaw == 0xffff
            let isSet = !isNotSet
            let quantity = try CreatureStack.Quantity(reader.readUInt16())
            
            guard quantity > 0, isSet else {
                return (slot, nil)
            }
            
            let creatureID = try Creature.ID(integer: idRaw)
            
            if creatureID.rawValue > ((format > .restorationOfErathia ? Int(0xffff) : Int(0xff)) - 0xf) {
                fatalError("handle this, vcmi does: `hlp->idRand = maxID - creID - 1`")
            }
            let stack = CreatureStack(creatureID: creatureID, quantity: quantity)
            return (slot, stack)
        }
        return .init(creatureStackAtSlot: Dictionary.init(uniqueKeysWithValues: stacks))
    }
    
//    func parseArmy<I>(format: Map.Format, count _count: I, parseFormation: Bool) throws -> Army? where I: FixedWidthInteger {
//        let count = Int(_count)
//        let creatureStacks = try parseCreatureStacks(format: format, count: count)
//        
//        let formation: Army.Formation? = parseFormation ? try Army.Formation(integer: reader.readUInt8()) : nil
//        
//        guard let stacks = creatureStacks else { return nil }
//        
//        return .init(
//            creatureStacks: stacks, formation: formation
//        )
//    }
    
}
