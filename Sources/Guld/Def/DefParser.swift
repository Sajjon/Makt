//
//  File 2.swift
//  File 2
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation
import Util

public final class DefParser {
    internal let reader: DataReader
    public init(data: Data) {
        self.reader = DataReader(data: data)
    }
}

public extension DefParser {
    func parse() throws -> DefinitionFile {
        let kind = try DefinitionFile.Kind(integer: reader.readUInt32())
        let width = try reader.readUInt32()
        let height = try reader.readUInt32()
        let blockCount = try reader.readUInt32()
        let palette = try reader.readPalette()
        
        let blockMetaDatas: [BlockMetaData] = try blockCount.nTimes {
            try parseBlockMetaData()
        }
        
        var firstFrameFullHeight: Int!
        var firstFrameFullWidth: Int!
        
        let blocks: [Block] = try blockMetaDatas.map {
            try parseBlock(blockMetaData: $0, &firstFrameFullHeight, &firstFrameFullWidth)
        }
        
        return .init(
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
    }
}

extension FixedWidthInteger {
    static var byteCount: Int { bitWidth / 8 }
}

private extension DefParser {
    
    func codeFragment() throws -> (length: Int, data: Data) {
        let code = try reader.readUInt8()
        let length = Int(try reader.readUInt8() + 1)
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
    
    
    func perLineData<U: UnsignedInteger & FixedWidthInteger>(
        lineCount height: Int, // "height"
        width: Int,
        integerTypePerLine: U.Type,
        memberFileOffsetInDefFile: Int,
        bytesToSkipAfterLineOffsetsRead: Int? = nil,
        fragment: () throws -> (length: Int, data: Data)
    ) throws -> Data {
        
        var pixelData = Data()
        let byteCountPerInt = U.byteCount
        
        //for each line we have offset of pixel data
        
        let lineOffsets: [U] = try height.nTimes {
            try reader.readUInt(byteCount: byteCountPerInt, endianess: .little)
        }
        
        if let bytesToSkip = bytesToSkipAfterLineOffsetsRead {
            try reader.skip(byteCount: bytesToSkip)
        }
        
        for lineOffset in lineOffsets {
            let expectedOffset = memberFileOffsetInDefFile + 32 + Int(lineOffset)
            if reader.offset != expectedOffset {
                fatalError("Remove this fatalError, might be too strict...")
                try reader.seek(to: expectedOffset)
            }
            var totalRowLength = 0
            while totalRowLength < width {
                let (length, data) = try fragment()
                pixelData.append(data)
                totalRowLength += length
            }
        }
        
        return pixelData
    }
    
    func parseBlockMetaData() throws -> BlockMetaData {
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
        
        let frames: [DefinitionFile.Frame] = try (0..<entryCount).compactMap { entryIndex -> DefinitionFile.Frame? in
            
            guard let frame = try parseFrame(
                blockFileName: blockMetaData.fileNames[entryIndex],
                blockOffsetInfFile: blockMetaData.offsets[entryIndex]
            ) else {
                return nil
            }
            
            var fullWidth = frame.fullWidth
            var fullHeight = frame.fullHeight
            
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
            return .init(
                fileName: frame.fileName,
                size: frame.size,
                fullWidth: fullWidth,
                fullHeight: fullHeight,
                width: frame.width,
                height: frame.height,
                margin: frame.margin,
                pixelData: frame.pixelData
            )
            
        }
        
        return Block.init(identifier: blockMetaData.identifier, frames: frames)
        
    }
    
    func parseFrame(
        blockFileName fileName: String,
        blockOffsetInfFile memberFileOffsetInDefFile: Int
    ) throws -> DefinitionFile.Frame? {
//        let fileName = blockMetaData.fileNames[entryIndex]
//        let memberFileOffsetInDefFile = blockMetaData.offsets[entryIndex]
        
        try reader.seek(to: memberFileOffsetInDefFile)
        let size = try Int(reader.readUInt32())
        let encodingFormat = try reader.readUInt32()
        
        /// Might be enlarged
        let fullWidth = try Int(reader.readUInt32())
        /// Might be enlarged
        let fullHeight = try Int(reader.readUInt32())
        
        let width = try Int(reader.readUInt32())
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
        switch encodingFormat {
        case 0:
            // pixel data is not compressed, copy data to surface

            pixelData = try reader.read(byteCount: .init(width * height))
        case 1:
            pixelData = try perLineData(
                lineCount: height,
                width: width,
                integerTypePerLine: UInt32.self,
                memberFileOffsetInDefFile: memberFileOffsetInDefFile,
                fragment: codeFragment
            )
        case 2:
            pixelData = try perLineData(
                lineCount: height,
                width: width,
                integerTypePerLine: UInt16.self,
                memberFileOffsetInDefFile: memberFileOffsetInDefFile,
                bytesToSkipAfterLineOffsetsRead: 2,
                fragment: segmentFragment
            )
        case 3:
            var pixelDataAgg = Data()
            let lineoffs: [[UInt16]] = try height.nTimes {
                let n = 32
                let innerCount = (width - 1 + n) / n
                return try innerCount.nTimes {
                    try reader.readUInt16()
                }
            }
            
            for lineoff in lineoffs {
                for i in lineoff {
                    let expectedOffset = memberFileOffsetInDefFile + 32 + Int(i)
                    if reader.offset != expectedOffset {
                        fatalError("Remove this fatalError, might be too strict...")
                        try reader.seek(to: expectedOffset)
                    }
                    var totalblocklength = 0
                    while totalblocklength < 32 {
                        let (length, data) = try segmentFragment()
                        pixelDataAgg.append(data)
                        totalblocklength += length
                    }
                }
            }
            pixelData = pixelDataAgg
        default: incorrectImplementation(reason: "Unhandled encoding format: \(encodingFormat). This should NEVER happen. Probably some wrong byte offset.")
        }
                    
        return DefinitionFile.Frame(
            fileName: fileName,
            size: size,
            fullWidth: fullWidth,
            fullHeight: fullHeight,
            width: width,
            height: height,
            margin: .init(left: leftMargin, top: topMargin),
            pixelData: pixelData
        )
        
    }
}
