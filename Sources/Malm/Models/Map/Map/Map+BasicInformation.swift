//
//  Map.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map {
    
    struct BasicInformation: Hashable, Identifiable, Codable {
        
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
        
        ///  AB/SOD feature. aka "mastery cap"
        public let maximumHeroLevel: Int?
        
        public init(
            id: ID,
            fileSize: Int,
            fileSizeCompressed: Int?,
            format: Map.Format,
            name: String,
            description: String,
            size: Size,
            difficulty: Difficulty,
            hasTwoLevels: Bool,
            maximumHeroLevel: Int?
        ) {
            self.id = id
            self.fileSize = fileSize
            self.fileSizeCompressed = fileSizeCompressed
            self.format = format
            self.name = name
            self.description = description
            self.size = size
            self.difficulty = difficulty
            self.hasTwoLevels = hasTwoLevels
            self.maximumHeroLevel = maximumHeroLevel
        }
   
    }
}
