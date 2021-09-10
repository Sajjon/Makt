//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm
import Util

extension H3M {
    func parseScholar() throws -> Map.Scholar {
        
        let scholarBonusKind = try Map.Scholar.Bonus.Stripped(integer: reader.readUInt8())
        let bonusIDRaw = try reader.readUInt8()
        
        let bonus: Map.Scholar.Bonus
        switch scholarBonusKind {
        case .primarySkill:
            bonus = try .primarySkill(.init(integer: bonusIDRaw))
        case .secondarySkill:
            bonus = try .secondarySkill(.init(integer: bonusIDRaw))
        case .spell:
            bonus = try .spell(.init(integer: bonusIDRaw))
        case .random:
            UNUSED(bonusIDRaw)
            bonus = .random
        }
        
        try reader.skip(byteCount: 6)
        
        return .init(bonus: bonus)
    }
}
