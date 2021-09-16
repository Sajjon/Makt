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
        
        let palette: [RGB] = try 256.nTimes {
            try .init(
                red: reader.readUInt8(),
                green: reader.readUInt8(),
                blue: reader.readUInt8()
            )
        }
        
        let blocks = try blockCount.nTimes {
            try parseBlock()
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
    
    func parseBlock() throws -> Block {
        let blockIdentifier = try reader.readUInt32()
        
        /// number of images in this block
        let entriesCount = try Int(reader.readUInt32())
        
        let _ = try reader.readUInt32() // unknown 1
        let _ = try reader.readUInt32() // unknown 2
        
        let fileNames: [String] = try entriesCount.nTimes {
            let data = try reader.read(byteCount: 13)
            let string = String(bytes: data, encoding: .utf8) ?? String(bytes: data, encoding: .ascii)!
            return string.trimmingCharacters(in: .whitespaces)
        }
        
        let fileOffsets = try entriesCount.nTimes {
            try reader.readUInt32()
        }
        
        var firstFrameFullHeight: Int!
        var firstFrameFullWidth: Int!
        let frames: [DefinitionFile.Frame] = try (0..<entriesCount).map { index in
            let fileName = fileNames[index]
            let memberFileOffsetInDefFile = Int(fileOffsets[index])
            try reader.seek(to: memberFileOffsetInDefFile)
            let size = try Int(reader.readUInt32())
            let encodingFormat = try reader.readUInt32()
            
            /// Might be enlarged
            var fullWidth = try Int(reader.readUInt32())
            /// Might be enlarged
            var fullHeight = try Int(reader.readUInt32())
            
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
            
            if firstFrameFullWidth == nil && firstFrameFullHeight == nil {
                firstFrameFullWidth = fullWidth
                firstFrameFullHeight = fullHeight
            }

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
            
            guard width > 0 && height > 0 else {
                fatalError("zero frame, what to do?")
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
                // each row is split into 32 byte long blocks which are individually encoded two bytes store the offset for each block per line
                var pixelDataAgg = Data()
                
                
                let lineOffsets: [UInt16] = try (0..<height).map { row in
                    let w = Double(width)
                    let byteCount: Int = Int(ceil(w / 16))
                    assert(byteCount <= 2)
                    let offsetRaw: UInt16 = try reader.readUInt(byteCount: byteCount, endianess: .little)
                    let offset = offsetRaw * UInt16(ceil(w / 32))
                    return offset
                }
                
                for lineOffset in lineOffsets {
                    let expectedOffset = memberFileOffsetInDefFile + 32 + Int(lineOffset)
                    if reader.offset != expectedOffset {
                        fatalError("Remove this fatalError, might be too strict...")
                        try reader.seek(to: expectedOffset)
                    }
                    var totalRowLength = 0
                    while totalRowLength < width {
                        let (length, data) = try segmentFragment()
                        pixelDataAgg.append(data)
                        totalRowLength += length
                    }
                }
                
                pixelData = pixelDataAgg
            default: incorrectImplementation(reason: "Unhandled encoding format: \(encodingFormat). This should NEVER happen. Probably some wrong byte offset.")
            }
            
            return .init(
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
        
        
        return .init(
            identifier: .init(blockIdentifier),
            frames: frames
        )
    }
}
