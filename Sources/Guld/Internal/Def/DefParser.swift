//
//  File 2.swift
//  File 2
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation
import Util

public final class DefParser {
    private let reader: DataReader
    private let definitionFileName: String
    private let parentArchiveName: String
    public init(data: Data, definitionFileName: String, parentArchiveName: String) {
        self.reader = DataReader(data: data)
        self.definitionFileName = definitionFileName
        self.parentArchiveName = parentArchiveName
    }
}

public extension DefParser {
    func parse() throws -> DefinitionFile {
     
        let kind = try DefinitionFile.Kind(integer: reader.readUInt32())
        let width = try reader.readUInt32()
        let height = try reader.readUInt32()
        let blockCount = try reader.readUInt32()
        let palette = try reader.readPalette()
        
        let blockMetaDatas: [BlockMetaData] = try (0..<blockCount).map { blockIndex in
            try parseBlockMetaData(blockIndex: .init(blockIndex))
        }
        
        var firstFrameFullHeight: Int!
        var firstFrameFullWidth: Int!
        
        let blocks: [Block] = try blockMetaDatas.map {
            try parseBlock(blockMetaData: $0, &firstFrameFullHeight, &firstFrameFullWidth)
        }
        
        return .init(
            archiveName: definitionFileName,
            parentArchiveName: parentArchiveName,
            fileName: definitionFileName,
            byteCount: reader.sourceSize,
            kind: kind,
            width: .init(width),
            height: .init(height),
            palette: palette,
            blocks: blocks
        )
            
    }
}

private extension DefParser {
    
    enum Error: Swift.Error, Equatable {
        
        case leftMarginLargerThanWidth
        case topMarginLargerThanHeight
        
        case widthLargerThanThatOfFirst
        case heightLargerThanThatOfFirst
        
        case encodingFormatOfThisFrame(
            DefinitionFile.Frame.EncodingFormat,
            doesNotMatchThatOfThePreviousFrame: DefinitionFile.Frame.EncodingFormat
        )
        
    }
}

extension FixedWidthInteger {
    static var byteCount: Int { bitWidth / 8 }
}

private extension DefParser {
    
    func codeFragment() throws -> (length: Int, data: Data) {
        let code = try reader.readUInt8()
        let length = Int(try reader.readUInt8()) + 1
        let byteCount = Int(length)
        let data: Data
        if code == 0xff {
            // Raw data
            data = try reader.read(byteCount: byteCount)
        } else {
            data = Data(Array<UInt8>(repeating: code, count: byteCount))
        }
        
        return (byteCount, data)
    }
    
    func segmentFragment() throws -> (length: Int, data: Data) {
        let segment = try reader.readUInt8()
        let code = segment >> 5
        let length = (segment & 0x1f) + 1
        let byteCount = Int(length)
        let data: Data
        if code == 7 {
            data = try reader.read(byteCount: byteCount)
        } else {
            data = Data(Array<UInt8>(repeating: code, count: byteCount))
        }
        return (byteCount, data)
    }
    
    func parseBlockMetaData(blockIndex: Int) throws -> BlockMetaData {
        let blockIdentifier = try reader.readUInt32()
        
        /// number of images in this block
        let entriesCount = try Int(reader.readUInt32())
        
        let _ = try reader.readUInt32() // unknown 1
        let _ = try reader.readUInt32() // unknown 2
        
        
        let fileNames: [String] = try entriesCount.nTimes {
            guard let fileName = try reader.readStringOfKnownMaxLength(13) else {
                fatalError("Failed to read file name")
            }
            return fileName
        }
        
        let fileOffsets = try entriesCount.nTimes {
            try Int(reader.readUInt32())
        }
        
        return .init(
            blockIndex: blockIndex,
            identifier: .init(blockIdentifier),
            entryCount: entriesCount,
            fileNames: fileNames,
            offsets: fileOffsets
        )
    }
    
    func parseBlock(blockMetaData: BlockMetaData, _ firstFrameFullHeight: inout Int!, _ firstFrameFullWidth: inout Int!) throws -> Block {
        let entryCount = blockMetaData.entryCount
        assert(blockMetaData.fileNames.count == entryCount)
        assert(blockMetaData.offsets.count == entryCount)
        
        var encodingFormatOfPreviousFrame: DefinitionFile.Frame.EncodingFormat?
        
        let frames: [DefinitionFile.Frame] = try (0..<entryCount).compactMap { entryIndex -> DefinitionFile.Frame? in
            
            guard let frame = try parseFrame(
                encodingFormatOfPreviousFrame: encodingFormatOfPreviousFrame,
                blockIndex: blockMetaData.blockIndex,
                frameName: blockMetaData.fileNames[entryIndex],
                blockOffsetInfFile: blockMetaData.offsets[entryIndex]
            ) else {
                // We are skipping two invalid frames part of original game bundle (unused in VCMI and other implementations.).
                return nil
            }
            
            if encodingFormatOfPreviousFrame == nil {
                encodingFormatOfPreviousFrame = frame.encodingFormat
            }
            
            var fullWidth = Int(frame.fullSize.width)
            var fullHeight = Int(frame.fullSize.height)
            
            if firstFrameFullWidth == nil && firstFrameFullHeight == nil {
                firstFrameFullWidth = fullWidth
                firstFrameFullHeight = fullHeight
            } else {
                if firstFrameFullWidth > fullWidth {
                    print("must enlarge width")
                    fullWidth = firstFrameFullWidth
                }
                if firstFrameFullWidth < fullWidth {
                    throw Error.widthLargerThanThatOfFirst
                }
                
                if firstFrameFullHeight > fullHeight {
                    print("must enlarge height")
                    fullHeight = firstFrameFullHeight
                }
                if firstFrameFullHeight < fullHeight {
                    throw Error.heightLargerThanThatOfFirst
                }
           
            }
            
            return DefinitionFile.Frame(
                encodingFormat: frame.encodingFormat,
                blockIndex: blockMetaData.blockIndex,
                rootArchiveName: parentArchiveName,
                fileName: frame.fileName,
                fullSize: .init(width: .init(fullWidth), height: .init(fullHeight)),
                rect: frame.rect,
                pixelData: frame.pixelData
            )
            
        }
        
        return Block(
            id: blockMetaData.identifier,
            frames: frames
        )
        
    }
    
    func parseFrame(
        encodingFormatOfPreviousFrame: DefinitionFile.Frame.EncodingFormat?,
        blockIndex: Int,
        frameName: String,
        blockOffsetInfFile memberFileOffsetInDefFile: Int
    ) throws -> DefinitionFile.Frame? {
        
        // These two sprites seems unused and they fail top margin checks.
        guard !(frameName.starts(with: "SgTwMt") && frameName.hasSuffix(".pcx")) else {
            print("⚠️ Skipping sprite named: \(frameName), since they have too large margin.")
            return nil
        }
        
        try reader.seek(to: memberFileOffsetInDefFile)
        let size = try Int(reader.readUInt32())
        UNUSED(size) // smaller than pixelData.count, failed to understand what this is, might be smaller than pixeldata.count when we have margin, i.e. pixelData.count contains transparent pixels..? anyway dont seem like we need this.
        let encodingFormat = try DefinitionFile.Frame.EncodingFormat(integer: reader.readUInt32())
        
        if let encodingFormatOfPreviousFrame = encodingFormatOfPreviousFrame, encodingFormat != encodingFormatOfPreviousFrame {
            throw Error.encodingFormatOfThisFrame(encodingFormat, doesNotMatchThatOfThePreviousFrame: encodingFormatOfPreviousFrame)
        }
        
        /// Might be enlarged
        let fullWidth = try Int(reader.readUInt32())
        /// Might be enlarged
        let fullHeight = try Int(reader.readUInt32())
        
        let width = try Int(reader.readUInt32())
//        assert(width.isMultiple(of: 16)) // must be a multiple of 16 ?
        
        
        let height = try Int(reader.readUInt32())
        let leftMargin = try Int(reader.readInt32())
        let topMargin = try Int(reader.readInt32())
        
        /// Comment from `jocsch/lodextract`:
        ///      `SGTWMTA.def` and `SGTWMTB.def` fail here
        ///      they have inconsistent left and top margins
        ///      they seem to be unused
        ///
        /// Comment and solution from VCMI:
        ///      special case for some "old" format defs (SGTWMTA.DEF and SGTWMTB.DEF)
        ///
        ///      if(sprite.format == 1 && sprite.width > sprite.fullWidth && sprite.height > sprite.fullHeight)
        ///      {
        ///          sprite.leftMargin = 0;
        ///          sprite.topMargin = 0;
        ///          sprite.width = sprite.fullWidth;
        ///          sprite.height = sprite.fullHeight;
        ///
        ///          currentOffset -= 16;
        ///      }
        ///
        guard topMargin <= fullHeight else {
            throw Error.topMarginLargerThanHeight
        }
        
        guard leftMargin <= fullWidth else {
            throw Error.leftMarginLargerThanWidth
        }

        guard width > 0 && height > 0 else {
            return nil
        }
            
        let pixelData: Data
        
        func readPixelData<U: UnsignedInteger & FixedWidthInteger>(
            lineOffsets: [U],
            maxRowLength: Int,
            fragment: () throws -> (length: Int, data: Data)
        ) throws -> Data {
            var pixelDataAgg = Data()
            for lineOffset in lineOffsets {
                let expectedOffset = memberFileOffsetInDefFile + 32 + Int(lineOffset)
                if reader.offset != expectedOffset {
                    try reader.seek(to: expectedOffset)
                }
                var totalRowLength = 0
                while totalRowLength < maxRowLength {
                    let (length, data) = try fragment()
                    pixelDataAgg.append(data)
                    totalRowLength += length
                }
            }
            return pixelDataAgg
        }
        
        func perLineData<U: UnsignedInteger & FixedWidthInteger>(
            integerTypePerLine: U.Type,
            maxRowLength: Int,
            bytesToSkipAfterLineOffsetsRead: Int? = nil,
            fragment: () throws -> (length: Int, data: Data)
        ) throws -> Data {
            
            let lineOffsets: [U] = try height.nTimes {
                try reader.readUInt(byteCount: U.byteCount, endianess: .little)
            }
            
            if let bytesToSkip = bytesToSkipAfterLineOffsetsRead {
                try reader.skip(byteCount: bytesToSkip)
            }
            
            return try readPixelData(
                lineOffsets: lineOffsets,
                maxRowLength: maxRowLength,
                fragment: fragment
            )
        }
        
        
        switch encodingFormat {
        case .nonCompressed:
            pixelData = try reader.read(byteCount: .init(width * height))
        case .repeatingCodeFragment:
            pixelData = try perLineData(
                integerTypePerLine: UInt32.self,
                maxRowLength: width,
                fragment: codeFragment
            )
        case .repeatingSegmentFragments:
            pixelData = try perLineData(
                integerTypePerLine: UInt16.self,
                maxRowLength: width,
                bytesToSkipAfterLineOffsetsRead: 2,
                fragment: segmentFragment
            )
        case .repeatingSegmentFragmentsEncodingEachLineIndividually:
            let maxRowLength = 32
            let lineOffsetMatrix: [[UInt16]] = try height.nTimes {
                return try width.divide(by: maxRowLength, rounding: .up).nTimes {
                    try reader.readUInt16()
                }
            }
            var pixelDataAgg = Data()
            for lineOffsets in lineOffsetMatrix {
                try pixelDataAgg.append(readPixelData(
                    lineOffsets: lineOffsets,
                    maxRowLength: maxRowLength,
                    fragment: segmentFragment
                ))
            }
            pixelData = pixelDataAgg

        }
        
        return .init(
            encodingFormat: encodingFormat,
            blockIndex: blockIndex,
            rootArchiveName: parentArchiveName,
            fileName: frameName,
            fullSize: .init(width: fullWidth, height: fullHeight),
            rect: .init(x: leftMargin, y: topMargin, width: width, height: height),
            pixelData: pixelData
        )
        
    }
}
