//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import Guld
import Malm
import Util
import CoreGraphics

enum ImageImporter {}

extension PCXImage {
    var size: CGSize { .init(width: width, height: height) }
    var rect: CGRect { .init(origin: .zero, size: size) }
}

extension ImageImporter {
    
    static func imageFrom(
        pcx: PCXImage,
        mirroring: Mirroring = .none
    ) throws -> CGImage {
        
        var maybePalette: Palette?
        let pixelData: Data
        switch pcx.contents {
        case .pixelData(let pixels, let palette):
            pixelData = pixels
            maybePalette = palette
        case .rawRGBPixelData(let pixels):
            pixelData = pixels
        }
        
        return try imageFrom(
            pixelData: pixelData,
            contentsHint: pcx.name,
            fullSize: pcx.size,
            rect: pcx.rect,
            mirroring: mirroring,
            palette: maybePalette
        )
    }
    
    static func imageFrom(
        frame: DefinitionFile.Frame,
        mirroring: Mirroring = .none,
        palette: Palette?
    ) throws -> CGImage {
        
        try imageFrom(
            pixelData: frame.pixelData,
            contentsHint: frame.fileName,
            fullSize: frame.fullSize,
            rect: frame.rect,
            mirroring: mirroring,
            palette: palette
        )
    }
    
    static func imageFrom(
        pixelData: Data,
        contentsHint: String,
        fullSize: CGSize,
        rect: CGRect,
        mirroring: Mirroring = .none,
        palette: Palette?
    ) throws -> CGImage {
        
        /// Replace special colors
        let pixelReplacementMap: [Int: UInt32] = [
            0: Palette.transparentPixel,  // full transparency
            1: 0x00000040,  // shadow border
            4: 0x00000080,  // shadow body
            5: Palette.transparentPixel,  // selection highlight, treat as full transparency
            6: 0x00000080,  // shadow body below selection, treat as shadow body
            7: 0x00000040   // shadow border below selection, treat as shadow border
        ]
        
        let pixelsNonPadded: [UInt32] = {
            if let palette = palette {
                let palette32Bit = palette.toU32Array()
                
                let pixels: [UInt32] = pixelData.map {
                    let pixel = Int($0)
                    if let pixelReplacement = pixelReplacementMap[pixel] {
                        return pixelReplacement
                    } else {
                        return palette32Bit[pixel]
                    }
                }
                return pixels
            } else {
                return pixelsFrom(data: pixelData)
            }
        }()
        
        let width = Int(fullSize.width)
        let height = Int(fullSize.height)
        let leftOffset = Int(rect.origin.x)
        let topOffset = Int(rect.origin.y)
        let transparentPixel = Palette.transparentPixel
        
        var pixelMatrix: [[Palette.Pixel]] = []
        for rowIndex in 0..<height {
            let rowOfPixels: [Palette.Pixel] = {
                if rowIndex < topOffset || (rowIndex - topOffset) >= Int(rect.height) {
                    return .init(repeating: transparentPixel, count: width)
                } else {
                    var row: [Palette.Pixel] = .init(repeating: transparentPixel, count: leftOffset)
                    let startIndex = (rowIndex - topOffset) * Int(rect.width)
                    let endIndex = startIndex + Int(rect.width)
                    let slice = pixelsNonPadded[startIndex..<endIndex]
                    row.append(contentsOf: slice)
                    let numberOfTransparentPixelsOnRightSide = width - Int(rect.width) - leftOffset
                    row.append(contentsOf: [Palette.Pixel](repeating: transparentPixel, count: numberOfTransparentPixelsOnRightSide))
                    return row
                }
            }()
            
            pixelMatrix.append(rowOfPixels)
        }
        
        let cgImage = try Self.makeCGImage(
            pixelValueMatrix: pixelMatrix,
            fullSize: fullSize,
            rect: rect,
            mirroring: mirroring
        )
        
        assert(cgImage.height == .init(height))
        assert(cgImage.width == .init(width))
        
//        let image = Image(
//            cgImage: cgImage,
//            mirroring: mirroring,
//            rect: rect,
//            hint: contentsHint
//        )
//        return image
        
        return cgImage
    }
    
    static func makeCGImage(
        pixelValueMatrix: [[UInt32]],
        fullSize: CGSize,
        rect: CGRect,
        mirroring: Mirroring
    ) throws -> CGImage {
        // context.scaleBy or context.concatenate(CGAffineTransform...) SHOULD work, but I've failed
        // to get it working. Instead I just mutate the order of the pixels to achive
        // the same result...
        var pixelValueMatrix = pixelValueMatrix
        
        if mirroring.flipHorizontal {
            // Reverse order of pixels per row => same as flipping whole image horizontally
            pixelValueMatrix = pixelValueMatrix.map({ $0.reversed() })
        }
        
        if mirroring.flipVertical {
            // Reverse order of rows => same as flipping whole image vertically
            pixelValueMatrix = pixelValueMatrix.reversed()
        }
        
        var pixels = pixelValueMatrix.flatMap({ $0 })
        
        guard let context = CGContext.from(
            pixelPointer: &pixels,
            width: .init(fullSize.width),
            height: .init(fullSize.height)
        ) else {
            throw Fail(description: "Failed to create image context")
        }
        
        guard let cgImage = context.makeImage() else {
            throw Fail(description: "Failed to create image from context")
        }
        return cgImage
    }
    
    static func pixelsFrom(data pixelData: Data, bytesPerPixel: Int = 3) -> [UInt32] {
        assert(bytesPerPixel == 3 || bytesPerPixel == 4)
        assert(pixelData.count.isMultiple(of: bytesPerPixel))
        let pixels: [UInt32] = Array<UInt8>(pixelData).chunked(into: bytesPerPixel).map { (chunk: [UInt8]) -> UInt32 in
            assert(chunk.count == bytesPerPixel)
            var data = Data()
            data.append(chunk[bytesPerPixel - 1]) // red
            data.append(chunk[bytesPerPixel - 2]) // green
            data.append(chunk[bytesPerPixel - 3]) // blue
            
            if bytesPerPixel == 4 {
                data.append(chunk[0])
            } else {
                data.append(255) // Alpha of 255
            }
            
            data.reverse() // fix endianess
            return data.withUnsafeBytes { $0.load(as: UInt32.self) }
        }
        return pixels
    }
}

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

    // Unfortunately CGContext.draw seems to draw images in the BOTTOM left corner
    // instead of top as we expect it to. We correct this by mirroring the origin
    // by the Y axis.
    func nonYMirroredDraw(
        image cgImage: CGImage,
        in yMirroredRect: CGRect,
        cropToRect: CGRect?,
        onCanvasOfHeight canvasHeight: CGFloat
    ) {
        let imageSize = yMirroredRect.size
        
        // correct inverted Y
        let nonMirroredY = canvasHeight - yMirroredRect.origin.y - imageSize.height
        
        let nonYMirroredOrigin = CGPoint(
            x: yMirroredRect.origin.x,
            y: nonMirroredY // mirror the origin by Y axis.
        )
        
        let rectInAtlas = CGRect(
            origin: nonYMirroredOrigin,
            size: imageSize
        )
        if let cropToRect = cropToRect {
            let cropped = cgImage.cropping(to: cropToRect)!
            draw(cropped, in: rectInAtlas)
        } else {
            draw(cgImage, in: rectInAtlas)
        }
        
    }
}
