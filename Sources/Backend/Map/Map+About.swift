//
//  Map+About.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map {
    
    // Information about the map and map file. Stable state independent information.
    struct About: Hashable, Identifiable {
        public let id: ID
        public let fileSize: Int
    }
    
}

// MARK: Public
public extension Map.About {
    typealias ID = Map.ID
    
    var fileName: String { id.fileName }
}
