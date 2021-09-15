//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public struct Block: Hashable {
    public let identifier: Int
    
    // Is this the same as `fileNames.count` or `files.count` or both?
    public let numberOfEntries: Int
    
    public let fileNames: [String]
    public let files: [File]
}
