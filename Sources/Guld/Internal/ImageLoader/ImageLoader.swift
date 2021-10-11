
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
        
//        let useCache = !skipCache
//
//        if useCache, let cached = objectImageCache[sprite] {
//            return cached
//        }
//
//        let defFile = definitionFile(
//            named: sprite.rawValue,
//            in: .lod(.restorationOfErathiaSpriteArchive)
//        )
//
//        assert(defFile.blocks.count == 1, "Dont know what to do with more than one block.")
//        let block = defFile.blocks.first!
//
//        if block.frames.count > 1 {
//            print("WARNING hardcoded to use frame at index 0, even though there are \(block.frames.count) frames. Which should we use?")
//        }
//        let frame = block.frames.first!
//
//        let image = try ImageLoader.imageFrom(
//            frame: frame,
//            mirroring: .none,
//            palette: defFile.palette
//        )
//
//        let cachedImage = ObjectImage(key: sprite, image: image)
//
//        objectImageCache[sprite] = cachedImage
//
//        return cachedImage
        fatalError()
    }
    
    func loadImage(ground: Map.Tile.Ground, skipCache: Bool = false) throws -> GroundImage {
//        try loadImage(for: ground, skipCache: skipCache)
        fatalError()
    }
    
    func loadImage(river: Map.Tile.River, skipCache: Bool = false) throws -> RiverImage {
//        try loadImage(for: river, skipCache: skipCache)
        fatalError()
    }
    
    func loadImage(road: Map.Tile.Road, skipCache: Bool = false) throws -> RoadImage {
//        try loadImage(for: road, skipCache: skipCache)
        fatalError()
    }
    
//    func loadImage<Key: DrawableTileLayer>(for key: Key, skipCache: Bool = false) throws -> CachedImage<Key> {
//        try loadImage(
//            forKey: key,
//            from: cacheFor(key),
//            skipCache: skipCache,
//            elseMake: newImage(key: key)
//        )
//    }
    
}

// MARK: Internal
// for testing
internal extension ImageLoader {
    
//    // TODO remove separate caches and share?
//    func cacheFor<Key: DrawableTileLayer>(_ abstractKey: Key) -> ImageCache<CachedImage<Key>> {
//        switch Key.layerKind {
//        case .road: return roadImageCache as! ImageCache<CachedImage<Key>>
//        case .ground: return groundImageCache as! ImageCache<CachedImage<Key>>
//        case .river: return riverImageCache as! ImageCache<CachedImage<Key>>
//        }
//
//    }
//
//
//    func newImage<Key: DrawableLayer>(
//        key: Key
//    ) throws -> CachedImage<Key> {
//        let defFile = definitionFileFor(key)
//
//        assert(defFile.blocks.count == 1, "Dont know what to do with more than one block.")
//        let block = defFile.blocks.first!
//
//        let frameIndex = key.frameIndex
//        guard frameIndex < block.frames.count else {
//            incorrectImplementation(reason: "frameIndex cannot be larger than number of frames in block.")
//        }
//        let frame = block.frames[frameIndex]
//
//        let image = try ImageLoader.imageFrom(
//            frame: frame,
//            mirroring: key.mirroring,
//            palette: defFile.palette
//        )
//
//        return .init(key: key, image: image)
//    }
    
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
    

    
//    func definitionFileFor<A: DrawableLayer>(_ drawableTile: A) -> DefinitionFile {
//        definitionFile(
//            named: drawableTile.definitionFileName,
//            in: drawableTile.archive
//        )
//    }
//
//    func definitionFile(
//        named targetDefinitionFileName: String,
//        in archive: Archive
//    ) -> DefinitionFile {
//
//        if let cached = definitionFileCache[targetDefinitionFileName] {
//            return cached
//        }
//
//        guard let lodFile = lodFiles.first(where: { $0.archiveName == archive.fileName }) else {
//            incorrectImplementation(reason: "Should always be able to find LODFile.")
//        }
//
//        guard let fileEntry = lodFile.entries.first(where: { $0.fileName.lowercased() == targetDefinitionFileName.lowercased() }) else {
//            incorrectImplementation(shouldAlwaysBeAbleTo: "Find file entry matching expected DEF file.")
//        }
//
//        guard case .def(let loadDefinitionFile) = fileEntry.content else {
//            incorrectImplementation(reason: "Should be def file")
//        }
//
//        let defFile = loadDefinitionFile(nil) // no inspector
//
//        definitionFileCache[targetDefinitionFileName] = defFile
//        //        print("🗂✅ loaded definition file, contents:\n\n\(String(describing: defFile))\n\n")
//        return defFile
//    }

}
