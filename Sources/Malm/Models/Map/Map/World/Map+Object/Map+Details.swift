//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation


public extension Map {
    struct DetailsAboutObjects: Hashable, Codable {
        public let objects: [Object]
        
        public init(objects: [Object]) {
            self.objects = objects
        }
    }
}
