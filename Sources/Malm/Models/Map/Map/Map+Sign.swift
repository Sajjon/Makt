//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
public extension Map {

    struct Sign: Hashable {
        public let message: String?
        
        public init(message: String?) {
            self.message = message
        }
    }
}
