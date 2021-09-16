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
    struct CompressedFileEntryMetaData: Hashable {
        public let name: String
        public let fileOffset: Int
        public let size: Int
        public let compressedSize: Int
    }
    
    struct FileEntry: Hashable {
        public let name: String
        public let content: Content
        
        public enum Content: Hashable {
            case pcxImage(PCXImage)
            case dataEntry(Data)
        }
    }
}
