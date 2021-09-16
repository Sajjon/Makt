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
        print("✨ reading header")
        guard let header = try reader.readStringOfKnownMaxLength(4) else {
            print("🚨 failed to read header")
            throw Error.failedToReadHeader
        }
        print("✨🔮 read header: \(header)")
        
        guard header == "LOD" else {
            print("🚨 header is NOT EXACTLY `LOD` some whitespace must differ?")
            throw Error.notLodFile(gotHeader: header)
        }
        print("✨🔮 read header is LOD: \(header)")
        
        try reader.seek(to: 8) // i.e. skip 4 bytes...
        print("✨ reading entry count")
        let entryCount = try reader.readUInt32()
        print("✨🔮 found: #\(entryCount) entries")
        try reader.seek(to: 92)
        
        print("✨ reading meta data about each entry")
        let compressedEntriesMetaData = try entryCount.nTimes {
            try parseCompressedEntryMetaData()
        }
        
        print("✨🔮 read metadata about: #\(compressedEntriesMetaData.count) entries => decompressing them now")
        let entries: [LodFile.FileEntry] = try compressedEntriesMetaData.enumerated().map {
//            print("✨🔮 decompressing entry at index: \($0.offset)")
            return try decompress($0.element)
        }
        print("✨🔮 decompressed all #\(entries.count) entries")
        return .init(entries: entries)
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
//            print("👻 Prevented overflow")
            return false
        }
        
        if size == pixelCount {
            return true
        }
        
        let (pixelCountX3, didOverflowx3) = pixelCount.multipliedReportingOverflow(by: 3)
        
        guard !didOverflowx3 else {
//            print("👻 Prevented overflow again (x3)")
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
                print("🎨 palette")
                return .pixelData(rawImageData, encodedByPalette: palette)
            } else if size == width*height*3 {
                let rawImageData = try pcxReader.readRest()
                print("🥩 raw")
                return .rawRGBPixelData(rawImageData)
            } else {
                incorrectImplementation(shouldAlreadyHave: "Handled where size != width*height*Factor")
            }
        }()
        
        return .init(width: width, height: height, contents: contents)
    }
    
    func decompress(_ entryMetaData: LodFile.CompressedFileEntryMetaData) throws -> LodFile.FileEntry {
//        print("✨ decompressing lod file entry with metadata: \(entryMetaData)")
        try reader.seek(to: entryMetaData.fileOffset)
        let data = try entryMetaData.compressedSize > 0 ? decompressor.decompress(
            data: reader.read(
                byteCount: entryMetaData.compressedSize
            )
        ) : reader.read(byteCount: entryMetaData.size)
        
        guard data.count == entryMetaData.size else {
//            print("🚨 wrong size of decompressed entry, expected: \(entryMetaData.size), but got: \(data.count)")
            throw Error.lodFileEntryDecompressionResultedInWrongSize(expected: entryMetaData.size, butGot: data.count)
        }
        
        let isPCXImage = try isPCX(data: data)
        
        let content: LodFile.FileEntry.Content = try isPCXImage ? .pcxImage(parsePCX(from: data)) : .dataEntry(data)
        
        return .init(name: entryMetaData.name, content: content)
    }
    
    func parseCompressedEntryMetaData() throws -> LodFile.CompressedFileEntryMetaData {

        guard let fileName = try reader.readStringOfKnownMaxLength(16) else {
//            print("🚨 failedToReadFileNameOfEntry")
            throw Error.failedToReadFileNameOfEntry
        }
        
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
        case failedToReadHeader
        case notLodFile(gotHeader: String)
        case failedToReadFileNameOfEntry
        case lodFileEntryDecompressionResultedInWrongSize(expected: Int, butGot: Int)
    }
}
