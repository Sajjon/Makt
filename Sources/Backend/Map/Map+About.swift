//
//  Map+About.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map {
    
    // Information about the map and map file. Stable state independent information.
    struct About: Equatable, Identifiable {
        
        /// A stable id that uniquely identifies this map. This is not part of the map file and is created by me (Cyon) in this Swift code base.
        public let id: ID
        public let fileSize: Int
        public let fileSizeCompressed: Int?
        
        /// Map format or `version`
        public let format: Map.Format
        
        public let name: String
        public let description: String
        
        public let size: Size
        public let difficulty: Difficulty
   
        public let hasTwoLevels: Bool
        public let maximumHeroLevel: Int?
    }
    
}

// MARK: Public
public extension Map.About {
    typealias ID = Map.ID
    
    var fileName: String { id.fileName }
}
