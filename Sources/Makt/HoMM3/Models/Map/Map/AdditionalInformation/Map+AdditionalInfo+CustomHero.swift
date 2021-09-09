//
//  Hero+CustomHero.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Map.AdditionalInformation {
    struct CustomHero: Hashable, CustomDebugStringConvertible {
        let heroId: Hero.ID
        let portraitID: Hero.ID?
        let name: String?
        let allowedPlayers: [Player]
        
        public var debugDescription: String {
            let optionalStrings: [String?] = [
//                heroId.map { "heroId: \($0)" },
                "heroId: \(heroId)",
                portraitID.map { "portraitID: \($0)" },
                name.map { "name: \($0)" },
                "allowedPlayers: \(allowedPlayers)"
            ]
            
            return optionalStrings.filterNils().joined(separator: "\n")
        }
    }
    
    struct CustomHeroes: Hashable {
        public let customHeroes: [CustomHero]
    }
}
