//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

import Util
import Malm

public final class LodFile: ArchiveProtocol {
    public let archiveName: String
    public let entries: [FileEntry]
    
    public init(
        archiveName: String,
        entries: [FileEntry]
    ) {
        self.archiveName = archiveName
        self.entries = entries
    }
    
}


public extension LodFile {
    
    struct CompressedFileEntryMetaData: Hashable {
        public let name: String
        public let fileOffset: Int
        public let size: Int
        public let compressedSize: Int
    }
    
    struct FileEntry: ArchiveFileEntry, Hashable {
        public let parentArchiveName: String
        public let fileName: String
        public let data: Data
        public var byteCount: Int { data.count }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(parentArchiveName)
            hasher.combine(fileName)
        }
    }
}
