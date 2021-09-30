//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

internal struct BlockMetaData: Hashable {
    public let blockIndex: Int
    public let identifier: Int
    public let entryCount: Int
    public let fileNames: [String]
    public let offsets: [Int]
    
}

public struct Block: Hashable, Identifiable, CustomDebugStringConvertible {
    public typealias ID = Int
    public let id: ID
    public let frames: [DefinitionFile.Frame]
    
    public var debugDescription: String {
        """
        DEF Block id: \(id)
        frames: \(frames.map { String(describing: $0) }.joined(separator: "\n"))
        """
    }
}
