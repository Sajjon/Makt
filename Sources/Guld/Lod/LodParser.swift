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
        let header: String = try {
            let data = try reader.read(byteCount: 4)
            let string = String(bytes: data, encoding: .utf8) ?? String(bytes: data, encoding: .ascii)!
            return string.trimmingCharacters(in: .whitespacesAndNewlines)
        }()
        
        guard header == "LOD" else {
            throw Error.notLodFile(gotHeader: header)
        }
        
        try reader.seek(to: 8) // i.e. skip 4 bytes...
        let entryCount = try reader.readUInt32()
        try reader.seek(to: 92)
        
        let compressedEntriesMetaData = try entryCount.nTimes {
            try parseCompressedEntryMetaData()
        }
        
        let entries = try compressedEntriesMetaData.map(decompress)
        
        return .init(entries: entries)
    }
}

private extension LodParser {
    
    func isPCX(data: Data) throws -> Bool {
        let pcxReader = DataReader(data: data)
        let size = try pcxReader.readUInt32()
        let width = try pcxReader.readUInt32()
        let height = try pcxReader.readUInt32()
        return size == width*height || size == width*height*3
    }
    
    func parsePCX(from data: Data) throws -> PCXImage {
        let pcxReader = DataReader(data: data)
        let size = try Int(pcxReader.readUInt32())
        let width = try Int(pcxReader.readUInt32())
        let height = try Int(pcxReader.readUInt32())
        let contents: PCXImage.Contents = try {
            if size == width*height {
                let rawImageData = try pcxReader.read(byteCount: width*height)
                let palette = try reader.readPalette() // TODO check offset
                return .pixelData(rawImageData, encodedByPalette: palette)
            } else if size == width*height*3 {
                let rawImageData = try pcxReader.readRest()
                return .rawRGBPixelData(rawImageData)
            } else {
                incorrectImplementation(shouldAlreadyHave: "Handled where size != width*height*Factor")
            }
        }()
        
        return .init(width: width, height: height, contents: contents)
    }
    
    func decompress(_ entryMetaData: LodFile.CompressedFileEntryMetaData) throws -> LodFile.FileEntry {
        try reader.seek(to: entryMetaData.fileOffset)
        let data = try entryMetaData.compressedSize > 0 ? decompressor.decompress(
            data: reader.read(
                byteCount: entryMetaData.compressedSize
            )
        ) : reader.read(byteCount: entryMetaData.size)
        
        let content: LodFile.FileEntry.Content = try isPCX(data: data) ? .pcxImage(parsePCX(from: data)) : .dataEntry(data)
        
        return .init(name: entryMetaData.name, content: content)
    }
    
    func parseCompressedEntryMetaData() throws -> LodFile.CompressedFileEntryMetaData {
        
        let fileName: String = try {
           let data = try reader.read(byteCount: 16)
           let string = String(bytes: data, encoding: .utf8) ?? String(bytes: data, encoding: .ascii)!
           return string.trimmingCharacters(in: .whitespacesAndNewlines)
       }()
        
        let offset = try Int(reader.readUInt32())
        let size = try Int(reader.readUInt32())
        let _ = try reader.readUInt32() // unknown
        let compressedSize = try Int(reader.readUInt32())
        
        return .init(
            name: fileName,
            fileOffset: offset,
            size: size,
            compressedSize: compressedSize
        )
    }
}

private extension LodParser {
    enum Error: Swift.Error, Equatable {
        case notLodFile(gotHeader: String)
    }
}
