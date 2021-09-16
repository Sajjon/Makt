//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation
import Util

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
        public var kind: Kind {
            guard let fileExtension = name.split(separator: ".").last else {
                incorrectImplementation(shouldAlwaysBeAbleTo: "Get file extension of entry.")
            }
            guard let kind = Kind(rawValue: String(fileExtension)) else {
                incorrectImplementation(reason: "Should have covered all file types, but got unrecognized file extension: \(fileExtension)")
            }
            return kind
        }
        public let content: Content
        
        public enum Content: Hashable {
            case pcxImage(PCXImage)
            case dataEntry(Data)
        }
        
        public enum Kind: String, Hashable {
            /// .msk
            case mask
            
            /// .pcx
            case pcx
            
            /// .def
            case def
        }
    }
}
