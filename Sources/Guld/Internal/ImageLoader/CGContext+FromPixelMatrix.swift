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
    typealias Pixel = UInt32
    static let bitsPerPixel = Pixel.bitWidth
    static let bytesPerPixel = bitsPerPixel / bitsPerByte
    static func bytesPerRow(width: Int) -> Int { width * bytesPerPixel }


    static func from(pixels pixelMatrix: [[UInt32]]) -> CGContext? {
        let width = pixelMatrix.first?.count ?? 0
        let height = pixelMatrix.count
        assert(pixelMatrix.allSatisfy { $0.count == width })
        let pixels: [UInt32] = pixelMatrix.flatMap { $0 }
        var mutPixels = pixels
       
        return CGContext(
            data: &mutPixels,
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
    
    static let transparentPixel: Pixel = 0x00000000
    
    static func transparentImage(size: CGSize) -> CGImage {
        let emptyRow: [UInt32] = .init(repeating: CGContext.transparentPixel, count: .init(size.width))
            let pixelMatrix: [[UInt32]] = .init(repeating: emptyRow, count: .init(size.height))
        let context = Self.from(pixels: pixelMatrix)
        guard let image = context?.makeImage() else {
            fatalError()
        }
        return image
    }
//
//    static func transparentImage(size: CGSize) -> CGImage {
//        .init(
//            width: size.width,
//            height: size.height,
//            bitsPerComponent: bitsPerComponent,
//            bitsPerPixel: bitsPerPixel,
//            bytesPerRow: bytesPerRow,
//            space: colorSpace,
//            bitmapInfo: bitmapInfo,
//            provider: <#T##CGDataProvider#>,
//            decode: <#T##UnsafePointer<CGFloat>?#>,
//            shouldInterpolate: false,
//            intent: <#T##CGColorRenderingIntent#>)
//    }
}
