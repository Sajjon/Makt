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


internal final class LodParser: ArchiveFileCountParser {
    
    fileprivate let decompressor: Decompressor
    
    internal init(
        decompressor: Decompressor = GzipDecompressor()
    ) {
        self.decompressor = decompressor
    }
}

internal extension LodParser {
    
    func peekFileEntryCount(of archiveFile: ArchiveFile) throws -> Int {
        let reader = DataReader(data: archiveFile.data)
        try reader.seek(to: 8)
        let fileCount = try reader.readUInt32()
        return .init(fileCount)
    }
    
    func parse(
        archiveFile: ArchiveFile,
        inspector: AssetParsedInspector? = nil
    ) throws -> LodFile {
            
        precondition(archiveFile.kind.isLODFile)
        print("✨ LodParser parsing LOD file: \(archiveFile.fileName)")
            
        let reader = DataReader(data: archiveFile.data)
        
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
                parentArchiveName: archiveFile.fileName,
                entryMetaData: $0,
                reader: reader
            ) else {
                return nil
            }
            inspector?.didParseFileEntry(fileEntry)
            return fileEntry
        }
        
        return LodFile(
            archiveKind: archiveFile.kind,
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
        
        guard let content = try fileEntryContent(metaData: entryMetaData, data: data, parentArchiveName: parentArchiveName) else {
            return nil
        }
        
        return LodFile.FileEntry(
            parentArchiveName: parentArchiveName,
            fileName: entryMetaData.name,
            content: content,
            byteCount: data.count
        )
    }
    
    func fileEntryContent(
        metaData: LodFile.CompressedFileEntryMetaData,
        data: Data,
        parentArchiveName: String
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
            let load: () -> PCXImage = { [unowned self] in
                do {
                    guard try isPCX(data: data) else {
                        throw Error.fileNameSuggestsEntryIsPCXButNotAccordingToData
                    }
                    let pcxImage = try LodParser.parsePCX(from: data, named: metaData.name)
                    return pcxImage
                } catch {
                    uncaught(error: error)
                }
            }
            return .pcx(load)
        case .palette:
            let load: () -> Palette = {
                do {
                    let palette = try Palette(data: data, name: metaData.name)
                    return palette
                } catch {
                    uncaught(error: error)
                }
            }

            return .palette(load)
            
        case .text:
            let load: () -> String = {
                guard let text = String(bytes: data, encoding: .utf8) ?? String(bytes: data, encoding: .nonLossyASCII) ?? String(bytes: data, encoding: .ascii) else {
                    incorrectImplementation(shouldAlwaysBeAbleTo: "Parse text")
                }
                return text
            }
            return .text(load)
        case .font:
            let load: () -> BitmapFont = {
                do {
                    let bitmapFontParser = BitmapFontParser.init()
                    let bitmapFont = try bitmapFontParser.parse(data: data, name: metaData.name)
                    return bitmapFont
                } catch {
                    uncaught(error: error)
                }
            }
            return .font(load)
        case .def:
            let load: (_ inspector: DefParser.Inspector?) -> DefinitionFile = { inspector in 
                do {
                    let defParser = DefParser(data: data, definitionFileName: metaData.name, parentArchiveName: parentArchiveName)
                    let defFile = try defParser.parse(inspector: inspector)
                    return defFile
                } catch {
                    uncaught(error: error)
                }
            }
            return .def(load)
        case .mask:
            let load: () -> Mask = {
                do {
                    let maskRaw = try DataReader(data: data).readPathfindingMask()
                    let mask: Mask = .init(relativePositionsOfPassableTiles: maskRaw)
                    return mask
                } catch {
                    uncaught(error: error)
                }
            }
            return .mask(load)
        case .campaign:
            let load: () -> Campaign = {
                do {
                    let h3cParser = H3CParser(data: data)
                    let campaign = try h3cParser.parse()
                    return campaign
                }catch {
                    uncaught(error: error)
                }
            }
            return .campaign(load)
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

internal extension LodParser {
    enum Error: Swift.Error, Equatable {
        case failedToReadHeader
        case failedToParseKindFromFile(named: String)
        case fileNameSuggestsEntryIsPCXButNotAccordingToData
        case notLodFile(gotHeader: String)
        case failedToReadFileNameOfEntry
        case lodFileEntryDecompressionResultedInWrongSize(expected: Int, butGot: Int)
    }
}
