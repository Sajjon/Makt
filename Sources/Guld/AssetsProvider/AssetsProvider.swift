//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation
import Malm
import Util
import H3M

public enum LoadingProgress: Hashable, CustomStringConvertible {
    case step(named: String)
    case progressStep(Int, of: Int)
    case namedProgress(String, step: Int, of: Int)
}

public extension LoadingProgress {
    var description: String {
        switch self {
        case .namedProgress(let stepName, let step, let totalStepCount):
            return "\(stepName) \(step)/\(totalStepCount)"
        case .step(let stepName):
            return stepName
        case .progressStep(let step, let totalStepCount):
            return "\(step)/\(totalStepCount)"
        }
    }
}


public final class AssetsProvider {
    
    private let config: Config
    
    public static var sharedAssets: Assets?
    
    private let fileManager: FileManager
//    private let archiveLoader: ArchiveLoader = .init()
    
//    private var archiveFileCache: [Archive: SimpleFile] = [:]
//    private var archiveCache: [Archive: LoadedArchive] = [:]
    
    private static var shared: AssetsProvider!
    
    internal init(
        config: Config,
        fileManager: FileManager = .default
    ) {
        self.config = config
        self.fileManager = fileManager
    }
    
}

// MARK: Error
private extension AssetsProvider {
    enum Error: Swift.Error {
        case noAssetExistsAtPath(String)
        case failedToLoadAssetAtPath(String)
//        case failedToLoadArchive(Archive, error: Swift.Error)
        case failedToLoadMap(id: Map.ID, error: Swift.Error)
        case failedToLoadBasicInfoOfMap(id: Map.ID, error: Swift.Error)
        case failedToLoadImage(name: String, error: Swift.Error)
    }
}

// MARK: Load
private extension AssetsProvider {
    
//    func load(archiveFile: SimpleFile, inspector: AssetParsedInspector? = nil) throws -> LoadedArchive {
//        if let cached = archiveCache[archiveFile.kind] {
//            print("✅ Cache contains loaded archive: \(cached.fileName)")
//            return cached
//        }
//        let loaded = try archiveLoader.load(archiveFile: archiveFile, inspector: inspector)
//        archiveCache[archiveFile.kind] = loaded
//        return loaded
//    }
//
//
//    func loadArchives() throws -> [SimpleFile] {
//        let allArchives = config.gamesFilesDirectories.allArchives
//        let archiveFiles: [SimpleFile] = try allArchives.map { try open(archive: $0) }
//        return archiveFiles
//    }
//
    
    func loadBasicInfoForMap(
        id mapID: Map.ID,
        inspector: Map.Loader.Parser.Inspector.BasicInfoInspector? = nil
    ) throws -> Map.BasicInformation {
        try Map.loadBasicInform(mapID, inspector: inspector)
    }
    
    func loadMapIDs() throws -> [Map.ID] {
        let path = config.gamesFilesDirectories.maps
        let mapDirectoryContents = try fileManager.contentsOfDirectory(atPath: path)
        let urlToMaps = URL(fileURLWithPath: path)
        
        let mapIDs: [Map.ID] = mapDirectoryContents.map {
            let mapPath = urlToMaps.appendingPathComponent($0)
            return Map.ID(absolutePath: mapPath.path)
        }
        return mapIDs
    }
    
    func loadBasicInfoForAllMaps() throws -> [Map.BasicInformation] {
        print("✨ Loading basic info for all maps...")
        let start = CFAbsoluteTimeGetCurrent()
        let basicInfos = try loadMapIDs().map { try loadBasicInfoForMap(id: $0) }
        let diff = CFAbsoluteTimeGetCurrent() - start
        print(String(format: "✨✅ Successfully loaded basic info for #\(basicInfos.count) maps, took %.3f seconds", diff))
        return basicInfos
    }
    
}


// MARK: Internal
internal extension AssetsProvider {
    
//    func open(archive: Archive, skipCache: Bool = false) throws -> SimpleFile {
//        let useCache = !skipCache
//        if useCache, let cached = archiveFileCache[archive] {
//            print("✅ Cache contains archive file: \(archive.fileName)")
//            return cached
//        }
//        print("✨ Opening contents of archive named: \(archive.fileName)")
//        let data = try loadContentsOfDataFile(name: archive.fileName)
//        let archiveFile = SimpleFile(kind: archive, data: data)
//        archiveFileCache[archive] = archiveFile
//        return archiveFile
//
//    }
    
    func loadContentsOfFileAt(path: String) throws -> Data {
        guard fileManager.fileExists(atPath: path) else {
            throw Error.noAssetExistsAtPath(path)
        }
        guard let data = fileManager.contents(atPath: path) else {
            throw Error.failedToLoadAssetAtPath(path)
        }
        return data
    }
    
    /// `dataFile` as in an archive in the DATA directory
    func loadContentsOfDataFile(name dataFile: String) throws -> Data {
        let path = config.gamesFilesDirectories.data.appending(dataFile)
        return try loadContentsOfFileAt(path: path)
    }
}

public final class Assets {
    
    private let loadMapQueue = DispatchQueue(label: "LoadMapQueue", qos: .background)

//    private let loadedArchives: [LoadedArchive]
   
    public let basicInfoOfMaps: [Map.BasicInformation]
    private let imageLoader: ImageLoader
    
    internal init(
//        loadedArchives: [LoadedArchive],
        basicInfoOfMaps: [Map.BasicInformation],
        imageLoader: ImageLoader
    ) {
//        self.loadedArchives = loadedArchives
        self.basicInfoOfMaps = basicInfoOfMaps
        self.imageLoader = imageLoader
    }
}

// MARK: Provide
private extension AssetsProvider {
    

    func provide(
        config: Config,
        onLoadingProgress: ((LoadingProgress) -> Void)? = nil,
        fileManager: FileManager = .default
    ) throws -> Assets {

//        var numberOfLoadedItems = 0
//        let assetParsedInspector = AssetParsedInspector(
//            onParseFileEntry: { fileEntry in
//                numberOfLoadedItems += 1
//            }
//        )
//        
//        let startTime = CFAbsoluteTimeGetCurrent()
        
        fatalError()
        
//        let archiveFiles = try loadArchives()
//        let numberOfItemsToLoad = try archiveFiles.map { try self.archiveLoader.peekFileEntryCount(of: $0) }.reduce(0, +)
//        let loadedArchives:  [LoadedArchive] = try archiveFiles.map { archiveFile in
//            let loadedArchive = try load(archiveFile: archiveFile, inspector: assetParsedInspector)
//            let loadingProgress: LoadingProgress = .namedProgress("Load archive \(String(describing: archiveFile.name))", step: numberOfLoadedItems, of: numberOfItemsToLoad)
//            print(loadingProgress)
//            onLoadingProgress?(loadingProgress)
//            return loadedArchive
//        }
//
//        let diff = CFAbsoluteTimeGetCurrent() - startTime
//        print(String(format: "✨✅ Successfully loaded #\(loadedArchives.count) archives, took %.3f seconds", diff))
//
//        let imageLoader = ImageLoader(lodFiles: loadedArchives.compactMap { $0.lodArchive })
//
//        let basicInfoOfMaps = try loadBasicInfoForAllMaps()
//
//        let assets = Assets(
//            loadedArchives: loadedArchives,
//            basicInfoOfMaps: basicInfoOfMaps,
//            imageLoader: imageLoader
//        )
//
//        if AssetsProvider.sharedAssets == nil {
//            AssetsProvider.sharedAssets = assets
//        }
//
//        return assets
    }
}

public extension AssetsProvider {
    static func provide(
        config: Config,
        onLoadingProgress: ((LoadingProgress) -> Void)? = nil,
        fileManager: FileManager = .default
    ) throws -> Assets {
        if let assets = AssetsProvider.sharedAssets {
            return assets
        }
        
        let provider: AssetsProvider
        if let sharedProvider = shared {
            provider = sharedProvider
            assert(provider.config == config, "Figure out what to do if different configs...")
        } else {
            provider = AssetsProvider(config: config)
            shared = provider
        }
        return try shared.provide(
            config: config,
            onLoadingProgress: onLoadingProgress,
            fileManager: fileManager
        )
    }
}

public extension Assets {
   
    func loadImage(ground: Map.Tile.Ground, skipCache: Bool = false) throws -> GroundImage {
        try imageLoader.loadImage(ground: ground, skipCache: skipCache)
    }

    func loadImage(sprite: Sprite, skipCache: Bool = false) throws -> ObjectImage {
        try imageLoader.loadImage(sprite: sprite, skipCache: skipCache)
    }
    
//    func loadImage<Key: DrawableTileLayer>(for key: Key, skipCache: Bool = false) throws -> CachedImage<Key> {
//        try imageLoader.loadImage(for: key, skipCache: skipCache)
//    }
    
    func loadMap(
        id mapID: Map.ID,
        inspector: Map.Loader.Parser.Inspector? = nil
    ) throws -> Map {
        print("✨ Loading map...")
        let start = CFAbsoluteTimeGetCurrent()
        let map = try Map.load(mapID, inspector: inspector)
        let diff = CFAbsoluteTimeGetCurrent() - start
        print(String(format: "✨✅ Successfully loaded map '%@', took %.1f seconds", map.basicInformation.name, diff))
        return map
    }
    
    
}
