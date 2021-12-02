//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
public extension Map {
    
    struct WitchHut: Hashable, Codable {
        public let learnableSkills: [Hero.SecondarySkill.Kind]
        
        public init(learnableSkills: [Hero.SecondarySkill.Kind]) {
            self.learnableSkills = learnableSkills
        }
    }
}
