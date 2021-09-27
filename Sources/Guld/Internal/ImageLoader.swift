
import Foundation
import CoreGraphics
import Combine
import Util
import Malm

/// Creds to "Rob": https://stackoverflow.com/a/49307028/1311272
internal struct ImageCache {
    typealias Key = LoadedImage.ID
    typealias Value = LoadedImage
    
    private var synchronizedImageCache = Synchronized([Key: Value]())
    
    internal func image(key: Key) -> LoadedImage? {
        return synchronizedImageCache.value[key]
    }
    
    internal func add(image: Value, key: Key, assertNew: Bool = true) {
        synchronizedImageCache.writer { cache in
            if assertNew {
                assert(cache[key] == nil)
            }
            cache[key] = image
        }
    }
    
    internal var count: Int {
        return synchronizedImageCache.reader { $0.count }
    }
}

/// A structure to provide thread-safe access to some underlying object using reader-writer pattern.

internal final class Synchronized<T> {
    /// Private value. Use `public` `value` computed property (or `reader` and `writer` methods)
    /// for safe, thread-safe access to this underlying value.
    
    private var _value: T
    
    /// Private reader-write synchronization queue
    
    private let queue = DispatchQueue(label: "Synchronized", qos: .default, attributes: .concurrent)
    
    /// Create `Synchronized` object
    ///
    /// - Parameter value: The initial value to be synchronized.
    
    internal init(_ value: T) {
        _value = value
    }
    
    /// A threadsafe variable to set and get the underlying object, as a convenience when higher level synchronization is not needed
    
    internal var value: T {
        get { reader { $0 } }
        set { writer { $0 = newValue } }
    }
    
    /// A "reader" method to allow thread-safe, read-only concurrent access to the underlying object.
    ///
    /// - Warning: If the underlying object is a reference type, you are responsible for making sure you
    ///            do not mutating anything. If you stick with value types (`struct` or primitive types),
    ///            this will be enforced for you.
    
    internal func reader<U>(_ block: (T) throws -> U) rethrows -> U {
        return try queue.sync { try block(_value) }
    }
    
    /// A "writer" method to allow thread-safe write with barrier to the underlying object
    
    func writer(_ block: @escaping (inout T) -> Void) {
        queue.async(flags: .barrier) {
            block(&self._value)
        }
    }
}

// MARK: ImageLoader
internal final class ImageLoader {
    
    private let dispatchQueue = DispatchQueue(label: "ImageLoader", qos: .background)
    
//    typealias ImageCache = [LoadedImage.ID: LoadedImage]
    
    private let lodFiles: [LodFile]
    
//    private let readerWriterLock = ReaderWriterLock()
//    private var _imageCache: ImageCache
    private var _imageCache: ImageCache
    
    /// VCMI: `TERRAIN_FILES`
    private let terrainToDefFileName: [Map.Tile.Terrain.Kind: String] = [
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
    
    internal init(
        lodFiles: [LodFile]
    ) {
        self.lodFiles = lodFiles
        self._imageCache = .init()
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
    ) -> AnyPublisher<LoadedImage, Never> {
        return Future { [unowned self] promise in
            dispatchQueue.async {
                do {
                    
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
                    
                    promise(.success(loadedImage))
                    
//                } catch let error as Error {
//                    promise(Result.failure(error))
                } catch { uncaught(error: error, expectedType: Error.self) }
            }
        }.eraseToAnyPublisher()
    }
    
//    func loadImageFrom(
//        pcx: PCXImage
//    ) -> AnyPublisher<LoadedImage, Never> {
//        switch pcx.contents {
//        case .pixelData(let data, encodedByPalette: let palette):
//            return loadImageFrom(id: pcx.name, pixelData: data, width: pcx.width, height: pcx.height, palette: palette)
//        case .rawRGBPixelData(let data):
//            return loadImageFrom(id: pcx.name, pixelData: data, width: pcx.width, height: pcx.height, palette: nil)
//        }
//
//    }
    

    func loadImageFrom(
        cacheKey: ImageCache.Key,
        defFilFrame frame: DefinitionFile.Frame,
        palette: Palette?,
        mirroring: Mirroring
    ) -> AnyPublisher<LoadedImage, Never> {
        
//        print("cacheKey: \(cacheKey), width: \(frame.width), height: \(frame.height)")
//        if let cached = imageCache[imageID] {
        if let cached = _imageCache.image(key: cacheKey) {
//            print("Image with cacheKey: \(cacheKey), found in cache ✅")
            assert(cached.mirroring == mirroring)
            return Just(cached).eraseToAnyPublisher()
        }
//        print("Image with cacheKey: \(cacheKey), NOT found in cache 😴")
        return loadImageFrom(
            cacheKey: cacheKey,
            pixelData: frame.pixelData,
            width: frame.width,
            height: frame.height,
            mirroring: mirroring,
            palette: palette
        )
            .assertNoFailure()
            .handleEvents(receiveOutput: { [unowned self]
            newImage in
                _imageCache.add(image: newImage, key: cacheKey)
        }).eraseToAnyPublisher()
        
    }
    
    var spriteArchive: LodFile {
        self.lodFiles.first(where: { $0.archiveKind == .lod(.restorationOfErathiaSpriteArchive) })!
    }
    
    private func defFilePublisherForImageForTerrainOf(kind terrainKind: Map.Tile.Terrain.Kind) -> AnyPublisher<DefinitionFile, Never> {
        
        guard let needleDefFileName = terrainToDefFileName[terrainKind] else {
            incorrectImplementation(shouldAlwaysBeAbleTo: "Get expected DEF file name for terrain kind.")
        }
        
        guard let fileEntry = spriteArchive.entries.first(where: { $0.fileName.lowercased() == needleDefFileName.lowercased() }) else {
            incorrectImplementation(shouldAlwaysBeAbleTo: "Find file entry matching expected DEF file.")
        }
        
        guard case .def(let defFilePublisher) = fileEntry.content else {
            incorrectImplementation(reason: "Should be def file")
        }
        
        return defFilePublisher
    }
    
  
    
    func loadImage(terrain: Map.Tile.Terrain) -> AnyPublisher<LoadedImage, Never> {
        let defFilePublisher = defFilePublisherForImageForTerrainOf(kind: terrain.kind)
        
        return defFilePublisher.flatMap { [unowned self] (defFile: DefinitionFile) -> AnyPublisher<LoadedImage, Never> in
            assert(defFile.blocks.count == 1, "Dont know what to do with more than one block.")
            let block = defFile.blocks.first!
            
//            let frameIndex = Int(terrain.mirroring.rawValue)
            let frameIndex = Int(terrain.viewID)
            guard frameIndex < block.frames.count else {
                incorrectImplementation(reason: "frameIndex cannot be larger than number of frames in block.")
            }
            let frame = block.frames[frameIndex]
            
            return self.loadImageFrom(
                cacheKey: .terrain(ImageCache.Key.Terrain(frameName: frame.fileName, mirroring: terrain.mirroring)),
                defFilFrame: frame,
                palette: defFile.palette,
                mirroring: terrain.mirroring
            ) // uses cache
        }.eraseToAnyPublisher()
    }
    
    func loadAllSpritesForTerrainKind(_ terrainKind: Map.Tile.Terrain.Kind) -> AnyPublisher<[LoadedImage], Never> {
        let defFilePublisher = defFilePublisherForImageForTerrainOf(kind: terrainKind)
        
        return defFilePublisher.flatMap { (defFile: DefinitionFile) -> AnyPublisher<[LoadedImage], Never> in
            let publishers: [AnyPublisher<LoadedImage, Never>] = defFile.blocks.flatMap { block in
                block.frames.flatMap { [unowned self] frame in
                    Mirroring.allCases.map { mirroring in
                        self.loadImageFrom(
                            cacheKey: .terrain(ImageCache.Key.Terrain.init(frameName: frame.fileName, mirroring: mirroring)),
                            defFilFrame: frame,
                            palette: defFile.palette,
                            mirroring: mirroring
                        ) // uses cache
                    }
                }
            }
            return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
        }.eraseToAnyPublisher()
        

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
