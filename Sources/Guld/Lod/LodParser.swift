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

public final class LodParser {
    
    internal let decompressor: Decompressor
    
    public init(
        decompressor: Decompressor = GzipDecompressor()
    ) {
        self.decompressor = decompressor
    }
}

public extension LodParser {
    func parse(assetFile: AssetFile) throws -> LodFile {
        precondition(assetFile.kind.isLODFile)
        
        let reader = DataReader(data: assetFile.data)
        
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
            try decompress($0, reader: reader)
        }
        
        return LodFile(
            lodFileName: assetFile.fileName,
            entries: entries
        )
    }
}

import Combine

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
    
    static func parsePCX(from data: Data) throws -> PCXImage {
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
        
        return PCXImage(width: width, height: height, contents: contents)
    }
    
    
    static func pcxPublisher(from data: Data) -> AnyPublisher<PCXImage, Never> {
        return Future { promise in
            DispatchQueue(label: "LoadPCXImage", qos: .background).async {
                do {
                    let pcxImage = try LodParser.parsePCX(from: data)
                    promise(.success(pcxImage))
                } catch {
                    incorrectImplementation(shouldAlwaysBeAbleTo: "Parse PCX Image")
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func decompress(
        _ entryMetaData: LodFile.CompressedFileEntryMetaData,
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
        
        guard let content = try fileEntryContent(metaData: entryMetaData, data: data) else {
            return nil
        }
        
        return LodFile.FileEntry(
            name: entryMetaData.name,
            content: content
        )
    }
    
    func fileEntryContent(
        metaData: LodFile.CompressedFileEntryMetaData,
        data: Data
    ) throws -> LodFile.FileEntry.Content? {
        
        guard !LodFile.FileEntry.Content.Kind.ignored.contains(where: {
            guard let fileExtension = metaData.name.fileExtension else {
                incorrectImplementation(shouldAlwaysBeAbleTo: "Get file extension of entry.")
            }
            return fileExtension == $0
        }) else {
            print("⚠️ Ignoring LodFile entry named: \(metaData.name) since its file extension is unsupported.")
            return nil
        }
        
        guard let kind = LodFile.FileEntry.Content.Kind(fileName: metaData.name) else {
            throw Error.failedToParseKindFromFile(named: metaData.name)
        }
        
        switch kind {
        case .pcx:
            guard try isPCX(data: data) else {
                throw Error.fileNameSuggestsEntryIsPCXButNotAccordingToData
            }
            return .pcx(LodParser.pcxPublisher(from: data))
        case .palette:
            let deferredPublisher = Deferred {
                return Future<Palette, Never> { promise in
                    do {
                        let palette = try Palette(data: data)
                        promise(.success(palette))
                    } catch {
                        uncaught(
                            error: error,
                            expectedToNeverFailBecause: "Palettes should be trivially parsed. Failed to parse palette with metadata: \(metaData)"
                        )
                    }
                }
            }.eraseToAnyPublisher()
            return .palette(deferredPublisher)
            
        case .text:
            guard let text = String(bytes: data, encoding: .utf8) ?? String(bytes: data, encoding: .nonLossyASCII) ?? String(bytes: data, encoding: .ascii) else {
                incorrectImplementation(shouldAlwaysBeAbleTo: "Parse text")
            }
            return .text(Just(text).eraseToAnyPublisher())
        case .font:

            let deferredPublisher = Deferred {
                // https://stackoverflow.com/a/49242027/1311272
                // or maybe: https://stackoverflow.com/a/12497630/1311272
                return Future<CGFont, Never> { promise in
                    implementMe(comment: "How are Fonts represented? Have a look at: https://stackoverflow.com/a/49242027/1311272 or https://stackoverflow.com/a/12497630/1311272 maybe.")
               
                }
            }.eraseToAnyPublisher()
            return .font(deferredPublisher)
            
        case .def:
            let deferredPublisher = Deferred {
                return Future<DefinitionFile, Never> { promise in
                    DispatchQueue(label: "ParseDEFFile", qos: .background).async {
                        do {
                            let defParser = DefParser(data: data)
                            let defFile = try defParser.parse()
                            promise(.success(defFile))
                        } catch {
                            uncaught(error: error, expectedToNeverFailBecause: "We should be able to parse DEF files")
                        }
                    }
                }
            }.eraseToAnyPublisher()
            return .def(deferredPublisher)
        case .mask:
            
            let deferredPublisher = Deferred {
                return Future<Mask, Never> { promise in
                    do {
                        let mask = try DataReader(data: data).readPathfindingMask()
                        promise(.success(.init(relativePositionsOfPassableTiles: mask)))
                    } catch {
                        uncaught(error: error)
                    }
                }
            }.eraseToAnyPublisher()
            return .mask(deferredPublisher)
        case .xmi:
            let deferredPublisher = Deferred {
                return Future<Data, Never> { promise in
                    implementMe(comment: "How XMI files decoded?")
               
                }
            }.eraseToAnyPublisher()
            return .xmi(deferredPublisher)
        case .campaign:
            let deferredPublisher = Deferred {
                return Future<Campaign, Never> { promise in
                    implementMe(comment: "How are Campaigns (H3C) represented? Similar To H3M but more complicated? This is probably a biggie...")
               
                }
            }.eraseToAnyPublisher()
            return .campaign(deferredPublisher)
        }
        

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
