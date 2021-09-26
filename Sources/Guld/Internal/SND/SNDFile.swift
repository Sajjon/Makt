//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-25.
//

import Foundation
import Malm

public final class SNDFile {
    public let archiveKind: Archive
    public let fileEntries: [FileEntry]
    
    public init(
        archiveKind: Archive,
        fileEntries: [FileEntry]
    ) {
        self.archiveKind = archiveKind
        self.fileEntries = fileEntries
    }
}

public extension SNDFile {
    var sndArchiveFileName: String {
        archiveKind.fileName
    }
}

public extension SNDFile {
    
    struct FileEntry: ArchiveFileEntry, Hashable {
        public let parentArchiveName: String
        public let fileName: String
        public let contents: Data
        
        public var byteCount: Int { contents.count }
        
        public var fileExtension: String {
            fileName.fileExtension!
        }
    }
    
    struct FileEntryMetaData: Hashable {
        public let fileName: String
        public let fileOffset: Int
        public let size: Int
    }
}

extension SNDFile.FileEntry: Identifiable {
    public typealias ID = String
    public var id: ID { fileName }
}
