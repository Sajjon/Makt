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
        
        public init(above: Level, belowGround: Level? = nil) {
            self.above = above
            self.belowGround = belowGround
        }
    }
    
}
