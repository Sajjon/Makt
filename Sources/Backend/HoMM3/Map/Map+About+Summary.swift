//
//  Map+Summary.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map.About {
    
    // Information about the map and map file. Stable state independent information.
    struct Summary: Equatable, Identifiable {
        
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
public extension Map.About.Summary {
    typealias ID = Map.ID
    
    var fileName: String { id.fileName }
}

// MARK: CustomDebugStringConvertible
extension Map.About.Summary: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        ======================================
        name: \(name)
        description: \(description)
        game: \(format)
        size: \(size)
        difficulty: \(difficulty)
        has underworld?: \(hasTwoLevels)
        ======================================
        """
    }
}
