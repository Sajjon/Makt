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
        let skills: [Hero.SecondarySkill.Kind] = try format > .restorationOfErathia ? parseBitmaskOfEnum() : .allCases
        return .init(learnableSkills: skills)
    }
    
}
