
import Foundation
import CoreGraphics
import Combine
import Util
import Malm


// MARK: ImageLoader
internal final class ImageLoader {
    
    private let lodFiles: [LodFile]
    
    typealias ImageCache = [LoadedImage.ID: LoadedImage]
    private var imageCache: ImageCache = [:]
 
    private typealias DefinitionFileID = String
    private var definitionFileCache: [DefinitionFileID: DefinitionFile] = [:]
    
    internal init(
        lodFiles: [LodFile]
    ) {
        self.lodFiles = lodFiles
    }

}

private extension ImageLoader {
    
    /// VCMI: `TERRAIN_FILES`
    var terrainToDefFileName: [Map.Tile.Terrain.Kind: String] { [
        .dirt:  "DIRTTL.def",
        .sand: "SANDTL.def",
        .grass: "GRASTL.def",
        .snow: "SNOWTL.def",
        .swamp: "SWMPTL.def",
        .rough: "ROUGTL.def",
        .subterranean: "SUBBTL.def",
        .lava: "LAVATL.def",
        .water: "WATRTL.def",
        .rock: "ROCKTL.def"
    ]
    }
    
    private func defFileForImageForTerrainOf(kind terrainKind: Map.Tile.Terrain.Kind) -> DefinitionFile {
        
        guard let needleDefFileName = terrainToDefFileName[terrainKind] else {
            incorrectImplementation(shouldAlwaysBeAbleTo: "Get expected DEF file name for terrain kind.")
        }
        
        if let cached = definitionFileCache[needleDefFileName] {
            return cached
        }
        
        let spriteArchive: LodFile = {
            lodFiles.first(where: { $0.archiveKind == .lod(.restorationOfErathiaSpriteArchive) })!
        }()
        
        guard let fileEntry = spriteArchive.entries.first(where: { $0.fileName.lowercased() == needleDefFileName.lowercased() }) else {
            incorrectImplementation(shouldAlwaysBeAbleTo: "Find file entry matching expected DEF file.")
        }
        
        guard case .def(let loadDefinitionFile) = fileEntry.content else {
            incorrectImplementation(reason: "Should be def file")
        }
        
        let defFile = loadDefinitionFile()
        
        definitionFileCache[needleDefFileName] = defFile
        
        return defFile
    }
    
}

// MARK: Error
internal extension ImageLoader {
    enum Error: Swift.Error {
        case failedToCreateImageContext
        case failedToCreateImageFromContext
    }
}


// MARK: To CGImage
internal extension ImageLoader {
    
    func pixelsFrom(data pixelData: Data, bytesPerPixel: Int = 3) -> [UInt32] {
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

internal extension ImageLoader {
    
    func loadImageFrom(
        cacheKey: ImageCache.Key,
        pixelData: Data,
        width: Int,
        height: Int,
        mirroring: Mirroring,
        palette maybePalette: Palette?
    ) throws -> LoadedImage {
        
        if let cached = imageCache[cacheKey] {
            assert(cached.mirroring == mirroring)
            return cached
        }
        
        let pixels: [UInt32] = {
            if let palette = maybePalette {
                let palette32Bit = palette.toU32Array()
                
                let pixels: [UInt32] = pixelData.map {
                    palette32Bit[Int($0)]
                }
                return pixels
            } else {
                return pixelsFrom(data: pixelData)
            }
        }()
        
        let pixelMatrix = pixels.chunked(into: width)
        
        let cgImage = try makeCGImage(
            pixelValueMatrix: pixelMatrix,
            height: .init(height),
            width: .init(width),
            mirroring: mirroring
        )
        
        let loadedImage = LoadedImage(
            id: cacheKey,
            width: width,
            height: height,
            mirroring: mirroring,
            image: cgImage
        )
        
        imageCache[cacheKey] = loadedImage
        
        return loadedImage
        
    }

    func loadImageFrom(
        cacheKey: ImageCache.Key,
        defFilFrame frame: DefinitionFile.Frame,
        palette: Palette?,
        mirroring: Mirroring
    ) throws -> LoadedImage {
       try loadImageFrom(
            cacheKey: cacheKey,
            pixelData: frame.pixelData,
            width: frame.width,
            height: frame.height,
            mirroring: mirroring,
            palette: palette
        )
    }
    
    func loadImage(terrain: Map.Tile.Terrain) throws  -> LoadedImage {
        let defFile = defFileForImageForTerrainOf(kind: terrain.kind)
        
        assert(defFile.blocks.count == 1, "Dont know what to do with more than one block.")
        let block = defFile.blocks.first!
        
        let frameIndex = Int(terrain.viewID)
        guard frameIndex < block.frames.count else {
            incorrectImplementation(reason: "frameIndex cannot be larger than number of frames in block.")
        }
        let frame = block.frames[frameIndex]
        
        return try loadImageFrom(
            cacheKey: .terrain(ImageCache.Key.Terrain(frameName: frame.fileName, mirroring: terrain.mirroring)),
            defFilFrame: frame,
            palette: defFile.palette,
            mirroring: terrain.mirroring
        ) // uses cache
    }
    
    func loadAllSpritesForTerrainKind(_ terrainKind: Map.Tile.Terrain.Kind) throws -> [LoadedImage] {
        let defFile = defFileForImageForTerrainOf(kind: terrainKind)
        
        return try defFile.blocks.flatMap { block in
            try block.frames.flatMap { [unowned self] frame in
                try Mirroring.allCases.map { mirroring in
                    try self.loadImageFrom(
                        cacheKey: .terrain(ImageCache.Key.Terrain.init(frameName: frame.fileName, mirroring: mirroring)),
                        defFilFrame: frame,
                        palette: defFile.palette,
                        mirroring: mirroring
                    ) // uses cache
                }
            }
        }
        
        
    }
}

// MARK: internal
internal extension ImageLoader {
    
    func makeCGImage(
        pixelValueMatrix: [[UInt32]],
        height: CGFloat,
        width: CGFloat,
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
       
        guard let context = CGContext.from(pixels: pixelValueMatrix) else {
            throw Error.failedToCreateImageContext
        }
        
        guard let cgImage = context.makeImage() else {
            throw Error.failedToCreateImageFromContext
        }
        return cgImage
    }

}
