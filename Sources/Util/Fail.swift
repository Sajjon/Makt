//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-09.
//

import Foundation

public struct Fail: Swift.Error, Hashable, CustomStringConvertible {
    public let description: String
    
    public init(description: String) {
        self.description = description
    }
}
