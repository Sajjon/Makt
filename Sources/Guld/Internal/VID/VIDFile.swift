//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-25.
//

import Foundation
import Malm

public final class VIDFile: ArchiveProtocol {
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


public extension VIDFile {
    
    struct FileEntry: ArchiveFileEntry, Hashable {
        public let parentArchiveName: String
        public let fileName: String
        public let contents: Data
        public var byteCount: Int { contents.count }
        public var fileExtension: String {
            fileName.fileExtension!
        }
        
        /// Without file extension
        public var name: String {
            String(fileName.split(separator: ".").first!)
        }
    }
}

extension VIDFile.FileEntry: Identifiable {
    public typealias ID = String
    public var id: ID { fileName }
}
