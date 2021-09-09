//
//  Map+World.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct World: Equatable {
        public let above: Level
        /// Underworld
        public let belowGround: Level?
    }
    
}
