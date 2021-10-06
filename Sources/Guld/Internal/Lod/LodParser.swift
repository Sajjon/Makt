//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

import Decompressor
import Util
import Malm
import H3C

public final class LodParser: ArchiveFileCountParser {
    
    fileprivate let decompressor: Decompressor
    
    public init(
        decompressor: Decompressor = GzipDecompressor()
    ) {
        self.decompressor = decompressor
    }
}

public extension LodParser {
    
    func peekFileEntryCount(of archiveFile: ArchiveFile) throws -> Int {
        let reader = DataReader(data: archiveFile.data)
        try reader.seek(to: 8)
        let fileCount = try reader.readUInt32()
        return .init(fileCount)
    }
    
    internal func parse(
        archiveFile: ArchiveFile,
        inspector: AssetParsedInspector? = nil
    ) throws -> LodFile {
        return try parse(
            archiveFileName: archiveFile.name,
            archiveFileData: archiveFile.data,
            inspector: inspector
        )
    }
    
    func parse(
        archiveFileName: String,
        archiveFileData: Data,
        inspector: AssetParsedInspector? = nil
    ) throws -> LodFile {
        let reader = DataReader(data: archiveFileData)
        
        guard let header = try reader.readStringOfKnownMaxLength(4) else {
            throw Error.failedToReadHeader
        }
        
        guard header == "LOD" else {
            throw Error.notLodFile(gotHeader: header)
        }
        
        try reader.seek(to: 8) // i.e. skip 4 bytes, since we have already read 4 bytes.
        let entryCount = try reader.readUInt32()
        try reader.seek(to: 92)
        
        let compressedEntriesMetaData = try entryCount.nTimes {
            try parseCompressedEntryMetaData(reader: reader)
        }
        
        let entries: [LodFile.FileEntry] = try compressedEntriesMetaData.compactMap {
            guard let fileEntry = try decompress(
                parentArchiveName: archiveFileName,
                entryMetaData: $0,
                reader: reader
            ) else {
                return nil
            }
            inspector?.didParseFileEntry(fileEntry)
            return fileEntry
        }
        
        return LodFile(
            archiveName: archiveFileName,
            entries: entries
        )
    }
}

internal extension LodParser {
    
    func isPCX(data: Data) throws -> Bool {
        let pcxReader = DataReader(data: data)
        let size = try Int(pcxReader.readUInt32())
        let width = try Int(pcxReader.readUInt32())
        let height = try Int(pcxReader.readUInt32())
        let (pixelCount, didOverflow) = width.multipliedReportingOverflow(by: height)
        guard !didOverflow else {
            return false
        }
        
        if size == pixelCount {
            return true
        }
        
        let (pixelCountX3, didOverflowx3) = pixelCount.multipliedReportingOverflow(by: 3)
        
        guard !didOverflowx3 else {
            return false
        }
        return size == pixelCountX3
    }
    
    static func parsePCX(from data: Data, named: String) throws -> PCXImage {
        let pcxReader = DataReader(data: data)
        let size = try Int(pcxReader.readUInt32())
        let width = try Int(pcxReader.readUInt32())
        let height = try Int(pcxReader.readUInt32())
        let contents: PCXImage.Contents = try {
            if size == width*height {
                let rawImageData = try pcxReader.read(byteCount: width*height)
                let palette = try pcxReader.readPalette()
                // VCMI calls this format: `PCX8B`
                return .pixelData(rawImageData, encodedByPalette: palette)
            } else if size == width*height*3 {
                let rawImageData = try pcxReader.readRest()
                // VCMI calls this format: `PCX24B`
                return .rawRGBPixelData(rawImageData)
            } else {
                incorrectImplementation(shouldAlreadyHave: "Handled where size != width*height*Factor")
            }
        }()
        
        return PCXImage(name: named, width: width, height: height, contents: contents)
    }
    
    
    func decompress(
        parentArchiveName: String,
        entryMetaData: LodFile.CompressedFileEntryMetaData,
        reader: DataReader
    ) throws -> LodFile.FileEntry? {
        try reader.seek(to: entryMetaData.fileOffset)
        let data = try entryMetaData.compressedSize > 0 ? decompressor.decompress(
            data: reader.read(
                byteCount: entryMetaData.compressedSize
            )
        ) : reader.read(byteCount: entryMetaData.size)
        
        guard data.count == entryMetaData.size else {
            throw Error.lodFileEntryDecompressionResultedInWrongSize(expected: entryMetaData.size, butGot: data.count)
        }

        
        return LodFile.FileEntry(
            parentArchiveName: parentArchiveName,
            fileName: entryMetaData.name,
            data: data
        )
    }
    
   
    func parseCompressedEntryMetaData(reader: DataReader) throws -> LodFile.CompressedFileEntryMetaData {

        guard let fileName = try reader.readStringOfKnownMaxLength(16) else {
            throw Error.failedToReadFileNameOfEntry
        }
        
        let offset = try Int(reader.readUInt32())
        let size = try Int(reader.readUInt32())
        let _ = try reader.readUInt32() // unknown
        let compressedSize = try Int(reader.readUInt32())
        
        return LodFile.CompressedFileEntryMetaData(
            name: fileName,
            fileOffset: offset,
            size: size,
            compressedSize: compressedSize
        )
    }
}

public extension LodParser {
    enum Error: Swift.Error, Equatable {
        case failedToReadHeader
        case failedToParseKindFromFile(named: String)
        case fileNameSuggestsEntryIsPCXButNotAccordingToData
        case notLodFile(gotHeader: String)
        case failedToReadFileNameOfEntry
        case lodFileEntryDecompressionResultedInWrongSize(expected: Int, butGot: Int)
    }
}
