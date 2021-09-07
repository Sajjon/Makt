//
//  Hero+CustomHero.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Map.AdditionalInformation {
    struct CustomHero: Hashable {
        let heroId: Hero.ID?
        let portraitID: Hero.ID?
        let name: String
        let allowedPlayers: [Player]
    }
    
    struct CustomHeroes: Hashable {
        public let customHeroes: [CustomHero]
    }
}
