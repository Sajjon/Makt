//
//  CGImageTools.swift
//  CGImageTools
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation
import CoreGraphics

extension CGContext {
    private static let colorSpace = CGColorSpaceCreateDeviceRGB()

    private static let bitmapInfo =
        CGBitmapInfo.byteOrder32Little.rawValue |
        CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
    
    static let bitsPerByte = UInt8.bitWidth
    static let bitsPerPixel = Palette.Pixel.bitWidth
    static let bytesPerPixel = bitsPerPixel / bitsPerByte
    
    static func bytesPerRow(width: Int) -> Int { width * bytesPerPixel }

    static func from(pixelPointer data: UnsafeMutablePointer<Palette.Pixel>, width: Int, height: Int) -> CGContext? {
       
        return CGContext(
            data: data,
            width: width,
            height: height,
            bitsPerComponent: bitsPerByte,
            bytesPerRow: bytesPerRow(width: width),
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil
        )
    }

}
