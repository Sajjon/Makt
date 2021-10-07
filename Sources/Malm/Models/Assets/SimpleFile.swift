//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation

public protocol File {
    var name: String { get }
    var data: Data { get }
}

public struct SimpleFile: File, Hashable, CustomDebugStringConvertible {
    
    public let name: String
    public let data: Data
    
    public init(
        name: String,
        data: Data
    ) {
        self.name = name
        self.data = data
    }
    
    public var debugDescription: String {
        """
        filename: \(name)
        data: #\(data.count) bytes
        """
    }
}
