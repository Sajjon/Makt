//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-19.
//

import Foundation
import Common
import Malm

internal final class SNDArchiveParser: ArchiveFileCountParser {
    internal init() {}
}

internal extension SNDArchiveParser {

    
    func parse(
        archiveFile: SimpleFile,
        inspector: AssetParsedInspector? = nil
    ) throws -> SNDFile {
        
        let reader = DataReader(data: archiveFile.data)
        
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
        
        let entries: [SNDFile.FileEntry] = try metaDataAboutFiles.map { metaData in
            try reader.seek(to: metaData.fileOffset)
            let contents = try reader.read(byteCount: metaData.size)
            let fileEntry = SNDFile.FileEntry(
                parentArchiveName:         archiveFile.name,
                fileName: metaData.fileName,
                contents: contents
            )
            inspector?.didParseFileEntry(fileEntry)
            return fileEntry
        }
        
        return .init(
            archiveName: archiveFile.name,
            entries: entries
        )
    }
}

