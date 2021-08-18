//
//  Hero+Custom.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Hero {
    struct Custom: Equatable {
        let id: Hero.ID
        let portraitId: Hero.ID
        let name: String
    }
    
    struct Seed: Equatable {
        let id: Hero.ID
        let name: String
    }
    
}
