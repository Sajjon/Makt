//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-11.
//

import Foundation
import Malm
import Common

extension H3M {
    
    func parse<Case>(
        data rawData: Data,
        asBitMaskOfCases cases: [Case],
        negate: Bool = false,
        reverseOrder: Bool = true
    ) throws -> [Case] where Case: CaseIterable, Case.AllCases == [Case] {
        let caseCount = cases.count
        
        let data = reverseOrder ? Data(rawData.reversed()) : rawData
        let bitmaskRaw = reverseOrder ? BitArray(BitArray(data: data).reversed()) : BitArray(data: data)
        let bitmask = BitArray(bitmaskRaw.prefix(caseCount))
       
        return bitmask
            .enumerated()
            .compactMap { (caseIndex, available) -> Case? in
                guard available == !negate else {
                    return nil
                }
                return cases[caseIndex]
            }
    }
    
    func parseBitmask<Case>(
        of cases: [Case],
        byteCount maybeByteCount: Int? = nil,
        negate: Bool = false,
        reverseOrder: Bool = true
    ) throws -> [Case] where Case: CaseIterable, Case.AllCases == [Case] {
        
        let caseCount = cases.count
        let qor = caseCount.quotientAndRemainder(dividingBy: 8)
        let byteCount = maybeByteCount ?? (qor.remainder == 0 ? qor.quotient : qor.quotient + 1)
        
        let data = try reader.read(byteCount: byteCount)
        
        return try parse(
            data: data,
            asBitMaskOfCases: cases,
            negate: negate,
            reverseOrder: reverseOrder
        )
    }
    
    func parseBitmask<Enum>(
        as enum: Enum.Type,
        byteCount: Int? = nil,
        negate: Bool = false,
        reverseOrder: Bool = true
    ) throws -> [Enum] where Enum: CaseIterable, Enum.AllCases == [Enum] {
        try parseBitmask(
            of: `enum`.allCases,
            byteCount: byteCount,
            negate: negate,
            reverseOrder: reverseOrder
        )
    }
    
    func parseBitmaskOfEnum<Enum>(
        byteCount: Int? = nil,
        negate: Bool = false,
        reverseOrder: Bool = true
    ) throws -> [Enum] where Enum: CaseIterable, Enum.AllCases == [Enum] {
        try parseBitmask(
            of: Enum.allCases,
            byteCount: byteCount,
            negate: negate,
            reverseOrder: reverseOrder
        )
    }
}

extension H3M {
    func parseSpellIDs(negate: Bool = false) throws -> SpellIDs {
        try SpellIDs(values: parseBitmaskOfEnum(negate: negate))
    }
}
