//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

// MARK: CustomHeroes
public extension Map.AdditionalInformation {
    
    // TODO use ArrayOf
    struct CustomHeroes: Hashable {
        public let customHeroes: [CustomHero]
        
        public init(
            customHeroes: [CustomHero]
        ) {
            self.customHeroes = customHeroes
        }
    }
}
