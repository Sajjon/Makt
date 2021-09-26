//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-20.
//

import Foundation
import Util
import Malm

internal protocol ArchiveFileCountParser {
    func peekFileEntryCount(of archiveFile: ArchiveFile) throws -> Int
}

extension ArchiveFileCountParser {
    func peekFileEntryCount(of archiveFile: ArchiveFile) throws -> Int {
        let reader = DataReader(data: archiveFile.data)
        let fileCount = try reader.readUInt32()
        return .init(fileCount)
    }
}

internal final class VIDArchiveParser: ArchiveFileCountParser {
    internal init() {}
}

internal extension VIDArchiveParser {
    
    func parse(
        archiveFile: ArchiveFile,
        inspector: AssetParsedInspector? = nil
    ) throws -> VIDFile {
        precondition(archiveFile.kind.isVIDFile)
        
        let reader = DataReader(data: archiveFile.data)
        
        let fileCount = try reader.readUInt32()
        
       
        let nameAndOffsetList: [(name: String, offset: Int)] = try fileCount.nTimes {
            let fileName = try reader.readStringOfKnownMaxLength(40)!
            let fileOffset = try reader.readInt32()
            
            return (
                name: fileName,
                offset: .init(fileOffset)
            )
        }
      
        let metaDatas: [(name: String, offset: Int, size: Int)] = nameAndOffsetList.enumerated().map {
            let (name, offset) = $0.element
            let index = $0.offset
            
            let size: Int
            if index == fileCount - 1 { // last element
                size = archiveFile.data.count - offset
            } else {
                let offsetNext = nameAndOffsetList[index + 1].offset
                assert(offsetNext > offset)
                size = offsetNext - offset
            }
            
            return (name, offset, size)
        }
        
        let fileEntries: [VIDFile.FileEntry] = try metaDatas.map {
            try reader.seek(to: $0.offset)
            let contents = try reader.read(byteCount: $0.size)
            let fileEntry = VIDFile.FileEntry(
                parentArchiveName: archiveFile.fileName,
                fileName: $0.name,
                contents: contents
            )
            inspector?.didParseFileEntry(fileEntry)
            return fileEntry
        }
        
        return .init(
            archiveKind: archiveFile.kind,
            fileEntries: fileEntries
        )
    }
}

