//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension H3M {
    
    func parseWitchHut(format: Map.Format) throws -> Map.WitchHut {
        let learnableSkills: [Hero.SecondarySkill.Kind] = format > .restorationOfErathia ? try {
            try reader.readBitArray(byteCount: 4).prefix(Hero.SecondarySkill.Kind.allCases.count).enumerated().compactMap { (skillIndex, allowed) in
                guard allowed else { return nil }
                return Hero.SecondarySkill.Kind.allCases[skillIndex]
            }
        }() : Hero.SecondarySkill.Kind.allCases
        
        return .init(learnableSkills: learnableSkills)
    }
    
}
