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

    static func from(pixels pixelMatrix: [[UInt32]]) -> CGContext? {
        let width = pixelMatrix.first?.count ?? 0
        let height = pixelMatrix.count
        assert(pixelMatrix.allSatisfy { $0.count == width })
        let pixels: [UInt32] = pixelMatrix.flatMap { $0 }
        var mutPixels = pixels

        let bitsPerByte = UInt8.bitWidth
        let bytesPerPixel = UInt32.bitWidth / bitsPerByte
        let bytesPerRow = width * bytesPerPixel

        return CGContext(
            data: &mutPixels,
            width: width,
            height: height,
            bitsPerComponent: bitsPerByte,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil
        )
    }
}
