//
//  Map+Level.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation


public extension Map {
    
    struct Level: Equatable {
        public let isUnderworld: Bool
        public let tiles: [Tile]
    }
}
