//
//  Map+World.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct World: Hashable {
        public let above: Level
        /// Underworld
        public let underground: Level?
        
        public init(above: Level, underground: Level? = nil) {
            self.above = above
            self.underground = underground
        }
    }
    
}
