//
//  Map+AllowedHeroes.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public extension Map {
    struct AvailableHeroes: Hashable {
        public let heroIDs: [Hero.ID]
    }
}
