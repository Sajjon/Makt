//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

import Decompressor
import Util

public final class LodParser {
    
    internal let reader: DataReader
    internal let decompressor: Decompressor
    
    public init(
        data: Data,
        decompressor: Decompressor = GzipDecompressor()
    ) {
        self.reader = DataReader(data: data)
        self.decompressor = decompressor
    }
}


public extension LodParser {
    func parse() throws -> LodFile {
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
            try parseCompressedEntryMetaData()
        }
        
        let entries: [LodFile.FileEntry] = try compressedEntriesMetaData.map(decompress)
        
        return LodFile(entries: entries)
    }
}

private extension LodParser {
    
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
    
    func parsePCX(from data: Data) throws -> PCXImage {
        let pcxReader = DataReader(data: data)
        let size = try Int(pcxReader.readUInt32())
        let width = try Int(pcxReader.readUInt32())
        let height = try Int(pcxReader.readUInt32())
        let contents: PCXImage.Contents = try {
            if size == width*height {
                let rawImageData = try pcxReader.read(byteCount: width*height)
                let palette = try pcxReader.readPalette() // TODO check offset
                return .pixelData(rawImageData, encodedByPalette: palette)
            } else if size == width*height*3 {
                let rawImageData = try pcxReader.readRest()
                return .rawRGBPixelData(rawImageData)
            } else {
                incorrectImplementation(shouldAlreadyHave: "Handled where size != width*height*Factor")
            }
        }()
        
        return PCXImage(width: width, height: height, contents: contents)
    }
    
    func decompress(_ entryMetaData: LodFile.CompressedFileEntryMetaData) throws -> LodFile.FileEntry {
        try reader.seek(to: entryMetaData.fileOffset)
        let data = try entryMetaData.compressedSize > 0 ? decompressor.decompress(
            data: reader.read(
                byteCount: entryMetaData.compressedSize
            )
        ) : reader.read(byteCount: entryMetaData.size)
        
        guard data.count == entryMetaData.size else {
            throw Error.lodFileEntryDecompressionResultedInWrongSize(expected: entryMetaData.size, butGot: data.count)
        }
        
        let isPCXImage = try isPCX(data: data)
        
        let content: LodFile.FileEntry.Content = try isPCXImage ? .pcxImage(parsePCX(from: data)) : .dataEntry(data)
        
        return LodFile.FileEntry(name: entryMetaData.name, content: content)
    }
    
    func parseCompressedEntryMetaData() throws -> LodFile.CompressedFileEntryMetaData {

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

private extension LodParser {
    enum Error: Swift.Error, Equatable {
        case failedToReadHeader
        case notLodFile(gotHeader: String)
        case failedToReadFileNameOfEntry
        case lodFileEntryDecompressionResultedInWrongSize(expected: Int, butGot: Int)
    }
}
