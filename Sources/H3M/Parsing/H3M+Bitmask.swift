//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-11.
//

import Foundation
import Malm


extension H3M {
    func parseBitmask<Case>(
        of cases: [Case],
        byteCount maybeByteCount: Int? = nil,
        negate: Bool = false
    ) throws -> [Case] where Case: CaseIterable, Case.AllCases == [Case] {
//        if let byteCount = maybeByteCount {
//            precondition(cases.count <= byteCount * 8)
//        }
        let caseCount = cases.count
        let qor = caseCount.quotientAndRemainder(dividingBy: 8)
        let byteCount = maybeByteCount ?? (qor.remainder == 0 ? qor.quotient : qor.quotient + 1)
        
        let rawBytes = try reader.read(byteCount: byteCount)
        let bitmaskFlipped =  BitArray(data: Data(rawBytes.reversed()))
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
    
//    func parseBitmask<Case>(
//        cases: [Case],
//        byteCount maybeByteCount: Int? = nil,
//        negate: Bool = false
//    ) throws -> [Case] where Case: CaseIterable, Case.AllCases == [Case] {
//        try parseBitmask(of: cases, byteCount: maybeByteCount, negate: negate)
//    }
    
//    func parseBitmaskOfPrefixCases<Enum, I>(
//        _ firstCases: I,
//        byteCount: Int? = nil,
//        negate: Bool = false
//    ) throws -> [Enum] where Enum: CaseIterable, Enum.AllCases == [Enum], I: FixedWidthInteger {
//        try parseBitmask(
//            cases: Array(Enum.allCases.prefix(Int(firstCases))),
//            byteCount: byteCount,
//            negate: negate
//        )
//    }
    
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
