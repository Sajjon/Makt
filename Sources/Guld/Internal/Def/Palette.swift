//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation

public struct Palette: Hashable {
    public let colors: [RGB]
    
    public init(colors: [RGB]) {
        self.colors = colors
    }
    
    
    public init(data: Data) throws {
        guard data.count.isMultiple(of: Self.expectedSize) else {
            throw Error.expectedPaletteToHave(
                expectedSize: Self.expectedSize,
                butByteCountIsNotAMultipleOfThatSizeGotByteCount: data.count
            )
        }
        
        if data.count.isMultiple(of: 3) {
            let colors: [RGB] = Array<UInt8>(data).chunked(into: 3).map { (chunk: [UInt8]) -> RGB in
                assert(chunk.count == 3)
                return RGB(
                    red: chunk[0],
                    green: chunk[1],
                    blue: chunk[2]
                )
            }
            self.init(colors: colors)
        } else if data.count.isMultiple(of: 4) {
            fatalError("ah ok cool...investigate if we ONLY got this..?")
        } else {
            throw Error.expectedPaletteToContainRGB
        }
    }
    
    public static let expectedSize = 256
    
    public enum Error: Swift.Error {
        case expectedPaletteToHave(
            expectedSize: Int,
            butByteCountIsNotAMultipleOfThatSizeGotByteCount: Int
        )
        case expectedPaletteToContainRGB
    }
}

public extension Palette {
    func toU32Array() -> [UInt32] {
        colors.enumerated().map { i, color in
            var data = Data()
            data.append(color.red)
            data.append(color.green)
            data.append(color.blue)
            data.append(255) // alpha
            data.reverse() // fix endianess
            return data.withUnsafeBytes { $0.load(as: UInt32.self) }
        }
    }
}
