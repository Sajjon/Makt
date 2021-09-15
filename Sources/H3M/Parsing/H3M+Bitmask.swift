//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-11.
//

import Foundation
import Malm
import Util

extension H3M {
    
    func parse<Case>(
        data: Data,
        asBitMaskOfCases cases: [Case],
        negate: Bool = false
    ) throws -> [Case] where Case: CaseIterable, Case.AllCases == [Case] {
        let caseCount = cases.count
        
        let bitmaskFlipped =  BitArray(data: Data(data.reversed()))
        let bitmaskTooMany = BitArray(bitmaskFlipped.reversed())
        let bitmask = BitArray(bitmaskTooMany.prefix(caseCount))
       
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
        negate: Bool = false
    ) throws -> [Case] where Case: CaseIterable, Case.AllCases == [Case] {
        let caseCount = cases.count
        let qor = caseCount.quotientAndRemainder(dividingBy: 8)
        let byteCount = maybeByteCount ?? (qor.remainder == 0 ? qor.quotient : qor.quotient + 1)
        
        let data = try reader.read(byteCount: byteCount)
        return try parse(data: data, asBitMaskOfCases: cases, negate: negate)
    }
    
    func parseBitmask<Enum>(
        as enum: Enum.Type,
        byteCount: Int? = nil,
        negate: Bool = false
    ) throws -> [Enum] where Enum: CaseIterable, Enum.AllCases == [Enum] {
        try parseBitmask(
            of: `enum`.allCases,
            byteCount: byteCount,
            negate: negate
        )
    }
    
    func parseBitmaskOfEnum<Enum>(
        byteCount: Int? = nil,
        negate: Bool = false
    ) throws -> [Enum] where Enum: CaseIterable, Enum.AllCases == [Enum] {
        try parseBitmask(
            of: Enum.allCases,
            byteCount: byteCount,
            negate: negate
        )
    }
}

extension H3M {
    func parseSpellIDs(negate: Bool = false) throws -> SpellIDs {
        try SpellIDs(values: parseBitmaskOfEnum(negate: negate))
    }
}
