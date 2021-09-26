
import Foundation
import CoreGraphics
import Combine
import Util
import Malm


// MARK: ImageLoader
internal final class ImageLoader {
    
    private let dispatchQueue = DispatchQueue(label: "ImageLoader", qos: .background)
    
    typealias ImageCache = [LoadedImage.ID: LoadedImage]
    
    private let lodFiles: [LodFile]
    
    private var imageCache: ImageCache
    
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
        lodFiles: [LodFile],
        imageCache: ImageCache = [:]
    ) {
        self.lodFiles = lodFiles
        self.imageCache = imageCache
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
        id: String,
        pixelData: Data,
        width: Int,
        height: Int,
        palette maybePalette: Palette?
    ) -> AnyPublisher<LoadedImage, Never> {
        return Future { [unowned self] promise in
            dispatchQueue.async { [unowned self] in
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
                   
                    let cgImage = try makeCGImage(pixelValueMatrix: pixelMatrix)
                    assert(height == pixelMatrix.count)
                    
                    let loadedImage = LoadedImage.init(id: id, width: width, height: pixelMatrix.count, image: cgImage)
                    
                    promise(.success(loadedImage))
                    
//                } catch let error as Error {
//                    promise(Result.failure(error))
                } catch { uncaught(error: error, expectedType: Error.self) }
            }
        }.eraseToAnyPublisher()
    }
    
    func loadImageFrom(
        pcx: PCXImage
    ) -> AnyPublisher<LoadedImage, Never> {
        switch pcx.contents {
        case .pixelData(let data, encodedByPalette: let palette):
            return loadImageFrom(id: pcx.name, pixelData: data, width: pcx.width, height: pcx.height, palette: palette)
        case .rawRGBPixelData(let data):
            return loadImageFrom(id: pcx.name, pixelData: data, width: pcx.width, height: pcx.height, palette: nil)
        }
        
    }
    
//
//    func loadImageFrom(
//        pcx: PCXImage
//    ) -> AnyPublisher<CGImage, AssetsProvider.Error> {
//        imageLoader.loadImageFrom(pcx: pcx).mapError({
//            AssetsProvider.Error.failedToLoadImage(name: pcx.name, error: $0)
//        }).eraseToAnyPublisher()
//    }
    
    func loadImageFrom(
        defFilFrame frame: DefinitionFile.Frame,
        palette: Palette?
    ) -> AnyPublisher<LoadedImage, Never> {
        let imageID = frame.fileName
        print("imageID: \(imageID), width: \(frame.width), height: \(frame.height)", terminator: "")
        if let cached = imageCache[imageID] {
            print(" found in cache ✅")
            return Just(cached).eraseToAnyPublisher()
        }
        print(" not found in cache => loading now ⏳")
        return loadImageFrom(
            id: imageID,
            pixelData: frame.pixelData,
            width: frame.width,
            height: frame.height,
            palette: palette
        ).assertNoFailure().eraseToAnyPublisher().handleEvents(receiveOutput: { [unowned self]
            newImage in
            imageCache[imageID] = newImage
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
            var blockIndex = Int(terrain.rotation.rawValue)
            if blockIndex >= defFile.blocks.count {
                print("⚠️ WARNING: blockIndex cannot be larger than number of blocks in DefFile => falling back to ` blockIndex = defFile.blocks.count - 1`")
                blockIndex = defFile.blocks.count - 1
            }
            let block = defFile.blocks[blockIndex]
            let frameIndex = Int(terrain.defFileFrameIndexWithinRotationBlock)
            guard frameIndex < block.frames.count else {
                incorrectImplementation(reason: "frameIndex (`terrain.rotation.rawValue`) cannot be larger than number of frames in block (at index: `terrain.defFileBlockIndex`).")
            }
            let frame = block.frames[frameIndex]
            
            return  self.loadImageFrom(defFilFrame: frame, palette: defFile.palette) // uses cache
        }.eraseToAnyPublisher()
    }
    
    func loadAllSpritesForTerrainKind(_ terrainKind: Map.Tile.Terrain.Kind) -> AnyPublisher<[LoadedImage], Never> {
        let defFilePublisher = defFilePublisherForImageForTerrainOf(kind: terrainKind)
        
        return defFilePublisher.flatMap { (defFile: DefinitionFile) -> AnyPublisher<[LoadedImage], Never> in
            let publishers: [AnyPublisher<LoadedImage, Never>] = defFile.blocks.flatMap { block in
                block.frames.map { [unowned self] frame in
                    self.loadImageFrom(defFilFrame: frame, palette: defFile.palette) // uses cache
                }
            }
            return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
        }.eraseToAnyPublisher()
        

    }
}

// MARK: internal
internal extension ImageLoader {
    func makeCGImage(pixelValueMatrix: [[UInt32]]) throws -> CGImage {
        guard let ctx = CGContext.from(pixels: pixelValueMatrix) else {
            throw Error.failedToCreateImageContext
        }
        guard let cgImage = ctx.makeImage() else {
            throw Error.failedToCreateImageFromContext
        }
        return cgImage
    }

}
