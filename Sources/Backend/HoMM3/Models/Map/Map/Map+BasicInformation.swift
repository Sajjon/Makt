//
//  Map.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map {
    
    struct BasicInformation: Hashable, Identifiable {
        
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
   
    }
}
