//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation
import Util

public struct Palette: Hashable {
    public let colors: [RGB]
    
    public init(colors: [RGB]) {
        self.colors = colors
    }
    
    
    
    public init(data: Data, name: String) throws {
        
//        guard data.count.isMultiple(of: Self.expectedSize) else {
//            print("🚨 failed to parse palette named: '\(name)', byte count: \(data.count)")
//            throw Error.expectedPaletteToHave(
//                expectedSize: Self.expectedSize,
//                butByteCountIsNotAMultipleOfThatSizeGotByteCount: data.count
//            )
//        }
        
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
        } else {
            print("🚨 WARNING skipping font named: '\(name)', since it has strange length: \(data.count) bytes, expected multiple of 3 or 4. Trying to ASCII print this, to see if it contains any relevant text (probbly not): ASCII: \(String.init(bytes: data, encoding: .ascii) ?? "FAILED")")
            self.init(colors: [])
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
    typealias Pixel = UInt32
    static func rgbaColorsFrom(pixels: [Pixel]) -> [RGBA] {
        pixels.map { pixel in
            let red = RGB.Value(pixel >> 24 & 0xff)
            let green = RGB.Value(pixel >> 16 & 0xff)
            let blue = RGB.Value(pixel >> 8 & 0xff)
            let alpha = RGB.Value(pixel & 0xff)
            
            return RGBA(
                rgb:
                        .init(
                            red: red,
                            green: green,
                            blue: blue
                        ),
                alpha: alpha
            )
        }
    }
    
    func toU32Array() -> [UInt32] {
        let rgba = colors.map { RGBA.init(rgb: $0, alpha: 0xff) }
        return Self.pixelsFrom(rgba: rgba)
    }
    static func pixelsFrom(rgba: [RGBA]) -> [Pixel] {
        rgba.enumerated().map { i, color in
            var data = Data()
            data.append(color.red)
            data.append(color.green)
            data.append(color.blue)
            data.append(255) // alpha
            data.reverse() // fix endianess
            return data.withUnsafeBytes { $0.load(as: Pixel.self) }
        }
    }
}
