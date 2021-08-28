//
//  Hero+Custom.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Map.InformationAboutPlayers {
    
    struct StartingHero: Hashable {
        let `class`: Hero.Class
        let portraitId: Hero.ID
        let name: String
    }
    
}
