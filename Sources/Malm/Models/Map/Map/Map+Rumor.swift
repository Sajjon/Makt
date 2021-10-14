//
//  Map+Rumor.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct Rumor: Hashable, CustomDebugStringConvertible, Codable {
        public let name: String
        public let text: String
        
        public init(name: String, text: String) {
            self.name = name
            self.text = text
        }
    }
}

public extension Map.Rumor {
    var debugDescription: String {
        """
        name: \(name)
        text: \(text)
        """
    }
}
