//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-19.
//

import Foundation
import Util
import Malm

public final class SNDArchiveParser {
    public init() {}
}

public struct SNDFile: Hashable {
    public let sndArchiveFileName: String
    public let fileEntries: [FileEntry]
}

public extension SNDFile {
    
    struct FileEntry: Hashable {
        public let fileName: String
        public let contents: Data
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

public extension SNDArchiveParser {
    func parse(assetFile: ArchiveFile) throws -> SNDFile {
        precondition(assetFile.kind.isSNDFile)
        
        let reader = DataReader(data: assetFile.data)
        
        let fileCount = try reader.readUInt32()
       
        let metaDataAboutFiles: [SNDFile.FileEntryMetaData] = try fileCount.nTimes {
            let fileNameRaw = try reader.readStringOfKnownMaxLength(40, trim: false)!
            // VCMI: For some reason entries in snd have format NAME\0WAVRUBBISH....
            // VCMI: we need to replace first \0 with dot and take the 3 chars with extension (and drop the rest)
            let fileNameAndExtensionSuffixedWithRubbish = fileNameRaw.split(separator: "\0")
            let fileNameBase = String(fileNameAndExtensionSuffixedWithRubbish.first!)
            let fileExtension = String(fileNameAndExtensionSuffixedWithRubbish[1].prefix(3))
            let fileName = [fileNameBase, fileExtension].joined(separator: ".")
            
            let fileOffset = try reader.readInt32()
            
            let size = try reader.readInt32()
            
            return .init(
                fileName: fileName,
                fileOffset: .init(fileOffset),
                size: .init(size)
            )
        }
        
        let fileEntries: [SNDFile.FileEntry] = try metaDataAboutFiles.map { metaData in
            try reader.seek(to: metaData.fileOffset)
            let contents = try reader.read(byteCount: metaData.size)
            return .init(fileName: metaData.fileName, contents: contents)
        }
        
        return .init(
            sndArchiveFileName: assetFile.fileName,
            fileEntries: fileEntries
        )
    }
}

