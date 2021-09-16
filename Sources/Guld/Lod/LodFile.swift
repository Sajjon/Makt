//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public struct LodFile: Hashable {
    public let entries: [FileEntry]
}

public extension LodFile {
    struct FileEntry: Hashable {
        public let name: String
        public let size: Int
        public let csize: Int // "compressed size" ?
        public let isCompressed: Bool
        public let contents: [Int]
    }
}
