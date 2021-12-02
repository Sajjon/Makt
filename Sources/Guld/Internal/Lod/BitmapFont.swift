//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-27.
//

import Foundation
import Common

public struct BitmapFont: Hashable {
    public static let charCount = 256
    public let name: String
    public let height: UInt8
    public let chars: [Char]
}

private extension BitmapFont {
    struct CharMetaDataFirstOfTwo {
        let leftOffset: Int32
        let byteCount: UInt32
        let rightOffset: Int32
    }
    
    struct CharMetaDataSecondOfTwo {
        let first: CharMetaDataFirstOfTwo
        let dataOffset: UInt32
    }
}

public extension BitmapFont {
    struct Char: Hashable {
        public let leftOffset: Int32
        public var width: Int { pixels.count }
        public let rightOffset: Int32
        public let pixels: Data
    }
}

internal final class BitmapFontParser {
    internal init() {
    }
}

extension BitmapFontParser {
    func parse(data: Data, name: String) throws -> BitmapFont {
        logger.debug("BitmapFontParser, #\(data.count) bytes of data, named: \(name)")
        if let _ = cgFontFromData(data) {
            fantasticUseThisSolution(insteadOf: "BitmapFont below.")
        }
        let reader = DataReader(data: data)
        let height = data[5]
        try reader.seek(to: 32)
        let placeholderChars: [BitmapFont.CharMetaDataFirstOfTwo] = try BitmapFont.charCount.nTimes {
            let leftOffset = try reader.readInt32()

            /// a.k.a. "width"
            let byteCount = try reader.readUInt32()

            let rightOffset = try reader.readInt32()
            return .init(leftOffset: leftOffset, byteCount: byteCount, rightOffset: rightOffset)
        }
        
        let metadata: [BitmapFont.CharMetaDataSecondOfTwo] = try placeholderChars.map { placeholder in
            let pixelDataOffset = try reader.readUInt32()
            return .init(first: placeholder, dataOffset: pixelDataOffset)
        }
        
        let chars: [BitmapFont.Char] = try metadata.map { placeholder in
            let pixelOffset = Int(placeholder.dataOffset)
            let pixelByteCount = Int(placeholder.first.byteCount)
            try reader.seek(to: pixelOffset)
            let pixelData = try reader.read(byteCount: pixelByteCount)
            
            return .init(
                leftOffset: placeholder.first.leftOffset,
                rightOffset: placeholder.first.rightOffset,
                pixels: pixelData
            )
        }
        
        return .init(name: name, height: height, chars: chars)
    }
}

func cgFontFromData(_ data: Data) -> CGFont? {
    let bytes = [UInt8](data)
    // Convert to CFData and prepare data provider.
    guard
        let cfData = CFDataCreate(kCFAllocatorDefault, bytes, bytes.count),
        let dataProvider = CGDataProvider(data: cfData),
        let cgFont = CGFont(dataProvider) else {
            return nil
        }
    return cgFont
}
