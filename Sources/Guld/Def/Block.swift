//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public struct BlockMetaData: Hashable {
    public let identifier: Int
    public let entryCount: Int
    public let fileNames: [String]
    public let offsets: [Int]
    
//    public let frames: [DefinitionFile.Frame]
}

public struct Block: Hashable {
    public let identifier: Int
    public let frames: [DefinitionFile.Frame]
}
