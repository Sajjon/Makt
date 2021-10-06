
import Foundation
import CoreGraphics
import Combine
import Util
import Malm
import CryptoKit

// MARK: ImageLoader
internal final class ImageLoader {
    
    private let lodFiles: [LodFile]
    private let groundImageCache: GroundImageCache = .init()
    private let roadImageCache: RoadImageCache = .init()
    private let riverImageCache: RiverImageCache = .init()
    private let objectImageCache: ObjectImageCache = .init()
    private let definitionFileCache: DefinitionFileCache = .init()
    
    internal init(
        lodFiles: [LodFile]
    ) {
        
        self.lodFiles = lodFiles
    }
}

// MARK: Error
internal extension ImageLoader {
    enum Error: Swift.Error {
        case failedToCreateImageContext
        case failedToCreateImageFromContext
    }
}

// MARK: API
internal extension ImageLoader {
    typealias DefinitionFileID = String
    typealias DefinitionFileCache = Cache<DefinitionFileID, DefinitionFile>
    typealias ImageCache<CI: CacheableImage> = Cache<CI.Key, CI>
    
    typealias GroundImageCache = ImageCache<GroundImage>
    typealias RoadImageCache = ImageCache<RoadImage>
    typealias RiverImageCache = ImageCache<RiverImage>
    typealias ObjectImageCache = ImageCache<ObjectImage>
    
//    func loadImage(object: Map.Object, skipCache: Bool = false) throws -> ObjectImage {
    func loadImage(sprite: Sprite, skipCache: Bool = false) throws -> ObjectImage {
        
        let useCache = !skipCache
        
        if useCache, let cached = objectImageCache[sprite] {
            return cached
        }
        
        let defFile = definitionFile(
            named: sprite.rawValue,
            in: .lod(.restorationOfErathiaSpriteArchive)
        )
        
        assert(defFile.blocks.count == 1, "Dont know what to do with more than one block.")
        let block = defFile.blocks.first!
        
        if block.frames.count > 1 {
            print("WARNING hardcoded to use frame at index 0, even though there are \(block.frames.count) frames. Which should we use?")
        }
        let frame = block.frames.first!
        
        let image = try ImageLoader.imageFrom(
            frame: frame,
            mirroring: .none,
            palette: defFile.palette
        )
        
        let cachedImage = ObjectImage(key: sprite, image: image)
        
        objectImageCache[sprite] = cachedImage
        
        return cachedImage
    }
    
    func loadImage(ground: Map.Tile.Ground, skipCache: Bool = false) throws -> GroundImage {
        try loadImage(for: ground, skipCache: skipCache)
    }
    
    func loadImage(river: Map.Tile.River, skipCache: Bool = false) throws -> RiverImage {
        try loadImage(for: river, skipCache: skipCache)
    }
    
    func loadImage(road: Map.Tile.Road, skipCache: Bool = false) throws -> RoadImage {
        try loadImage(for: road, skipCache: skipCache)
    }
    
    func loadImage<Key: DrawableTileLayer>(for key: Key, skipCache: Bool = false) throws -> CachedImage<Key> {
        try loadImage(
            forKey: key,
            from: cacheFor(key),
            skipCache: skipCache,
            elseMake: newImage(key: key)
        )
    }
    
}

// MARK: Internal
// for testing
internal extension ImageLoader {
    
    // TODO remove separate caches and share?
    func cacheFor<Key: DrawableTileLayer>(_ abstractKey: Key) -> ImageCache<CachedImage<Key>> {
        switch Key.layerKind {
        case .road: return roadImageCache as! ImageCache<CachedImage<Key>>
        case .ground: return groundImageCache as! ImageCache<CachedImage<Key>>
        case .river: return riverImageCache as! ImageCache<CachedImage<Key>>
        }
        
    }
    
    
    func newImage<Key: DrawableLayer>(
        key: Key
    ) throws -> CachedImage<Key> {
        let defFile = definitionFileFor(key)
        
        assert(defFile.blocks.count == 1, "Dont know what to do with more than one block.")
        let block = defFile.blocks.first!
        
        let frameIndex = key.frameIndex
        guard frameIndex < block.frames.count else {
            incorrectImplementation(reason: "frameIndex cannot be larger than number of frames in block.")
        }
        let frame = block.frames[frameIndex]
        
        let image = try ImageLoader.imageFrom(
            frame: frame,
            mirroring: key.mirroring,
            palette: defFile.palette
        )
        
        return .init(key: key, image: image)
    }
    
    static func imageFrom(
        frame: DefinitionFile.Frame,
        mirroring: Mirroring = .none,
        palette: Palette?
    ) throws -> Image {
        
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
    ) throws -> Image {
        
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
        
        let cgImage = try ImageLoader.makeCGImage(
            pixelValueMatrix: pixelMatrix,
            fullSize: fullSize,
            rect: rect,
            mirroring: mirroring
        )
        
        assert(cgImage.height == .init(height))
        assert(cgImage.width == .init(width))
        
        let image = Image(
            cgImage: cgImage,
            mirroring: mirroring,
            rect: rect,
            hint: contentsHint
        )
        return image
        
    }
    
    func loadImage<CI: CacheableImage>(
        forKey cacheKey: CI.Key,
        from cache: Cache<CI.Key, CI>,
        skipCache: Bool = false,
        elseMake makeImage: @autoclosure () throws -> CI
    ) rethrows -> CI {
        let useCache = !skipCache
        if useCache, let cached = cache[cacheKey] {
            return cached
        }
        let newImage = try makeImage()
        cache[cacheKey] = newImage
        
        return newImage
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
            throw Error.failedToCreateImageContext
        }
        
        guard let cgImage = context.makeImage() else {
            throw Error.failedToCreateImageFromContext
        }
//        let copy = cgImage.copy()!
        
//        return copy
        return cgImage
    }
    
    func definitionFileFor<A: DrawableLayer>(_ drawableTile: A) -> DefinitionFile {
        definitionFile(
            named: drawableTile.definitionFileName,
            in: drawableTile.archive
        )
    }
    
    func definitionFile(
        named targetDefinitionFileName: String,
        in archive: Archive
    ) -> DefinitionFile {
        
        if let cached = definitionFileCache[targetDefinitionFileName] {
            return cached
        }
        
        guard let lodFile = lodFiles.first(where: { $0.archiveName == archive.fileName }) else {
            incorrectImplementation(reason: "Should always be able to find LODFile.")
        }
        
        guard let fileEntry = lodFile.entries.first(where: { $0.fileName.lowercased() == targetDefinitionFileName.lowercased() }) else {
            incorrectImplementation(shouldAlwaysBeAbleTo: "Find file entry matching expected DEF file.")
        }
        
        guard case .def(let loadDefinitionFile) = fileEntry.content else {
            incorrectImplementation(reason: "Should be def file")
        }
        
        let defFile = loadDefinitionFile(nil) // no inspector
        
        definitionFileCache[targetDefinitionFileName] = defFile
        //        print("🗂✅ loaded definition file, contents:\n\n\(String(describing: defFile))\n\n")
        return defFile
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
