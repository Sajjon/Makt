//
//  Hero+CustomHero.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Map.AdditionalInformation {
    struct CustomHero: Hashable, CustomDebugStringConvertible, Codable {
        public let heroId: Hero.ID
        public let portraitID: Hero.ID?
        public let name: String?
        public let allowedPlayers: [Player]
        
        public init(
            heroId: Hero.ID,
            portraitID: Hero.ID?,
            name: String?,
            allowedPlayers: [Player]
        ) {
            self.heroId = heroId
            self.portraitID = portraitID
            self.name = name
            self.allowedPlayers = allowedPlayers
        }
    }

}

// MARK: CustomDebugStringConvertible
public extension Map.AdditionalInformation.CustomHero {
    
    var debugDescription: String {
        let optionalStrings: [String?] = [
            "heroId: \(heroId)",
            portraitID.map { "portraitID: \($0)" },
            name.map { "name: \($0)" },
            "allowedPlayers: \(allowedPlayers)"
        ]
        
        return optionalStrings.filterNils().joined(separator: "\n")
    }
}
