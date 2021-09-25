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
import Combine

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
    private let imageLoader: ImageLoader
    private let archiveLoader: ArchiveLoader
    private let mapLoaderQueue: DispatchQueue = DispatchQueue(label: "MapLoader", qos: .background)
    private let dispatchQueue: DispatchQueue
    
    private var archiveFileCache: [Archive: ArchiveFile] = [:]
//    private var lodFileCache: [Archive.LOD: LodFile] = [:]
    private var archiveCache: [Archive: LoadedArchive] = [:]
    private var imageCache: [ImageCacheKey: CGImage] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    private static var shared: AssetsProvider!
    
    private init(
        config: Config,
        imageLoader: ImageLoader = .init(),
        fileManager: FileManager = .default
    ) {
        let dispatchQueue = DispatchQueue(label: "AssetsProvider", qos: .background)
        self.config = config
        self.imageLoader = imageLoader
        self.archiveLoader = ArchiveLoader(dispatchQueue: dispatchQueue)
        self.fileManager = fileManager
        self.dispatchQueue = dispatchQueue
    }
    

    
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
    
}

// MARK: Error
private extension AssetsProvider {
    enum Error: Swift.Error {
        case noAssetExistsAtPath(String)
        case failedToLoadAssetAtPath(String)
        case failedToLoadArchive(Archive, error: Swift.Error)
        case failedToLoadMap(id: Map.ID, error: Swift.Error)
        case failedToLoadBasicInfoOfMap(id: Map.ID, error: Swift.Error)
        case failedToLoadImage(name: String, error: Swift.Error)
    }
}

// MARK: Load
private extension AssetsProvider {
    
    func load(archiveFile: ArchiveFile, inspector: AssetParsedInspector? = nil) -> AnyPublisher<LoadedArchive, Never> {
        if let cached = archiveCache[archiveFile.kind] {
            print("✅ Cache contains loaded archive: \(cached.fileName)")
            return Just(cached).eraseToAnyPublisher()
        }
        return archiveLoader.load(archiveFile: archiveFile, inspector: inspector)
            .assertNoFailure()
            .handleEvents(receiveOutput: { [self] (loadedArchive: LoadedArchive) in
            archiveCache[archiveFile.kind] = loadedArchive
        })
            .share()
            .eraseToAnyPublisher()
    }

//    func loadLODArchive(file archiveFile: ArchiveFile) -> AnyPublisher<LodFile, Never> {
//        guard case .lod(let lodArchiveFile) = archiveFile.kind else {
//            incorrectImplementation(reason: "Wrong archive type, expected LOD.")
//        }
//
//        if let cached = lodFileCache[lodArchiveFile] {
//            print("✅ Cache contains lod file: \(archiveFile.fileName)")
//            return Just(cached).eraseToAnyPublisher()
//        }
//
//        return Future<LodFile, Never> { [self] promise in
//            dispatchQueue.async { [self] in
//                do {
//                    let lodParser = LodParser()
//                    let lodFile = try lodParser.parse(assetFile: archiveFile)
//                    assert(lodFileCache[lodArchiveFile] == nil)
//                    lodFileCache[lodArchiveFile] = lodFile
//                    assert(lodFileCache[lodArchiveFile] != nil)
//                    promise(.success(lodFile))
//                } catch {
//                    uncaught(error: error)
//                }
//            }
//        }.share().eraseToAnyPublisher()
//    }
    
    // TODO: Make private/internal, archives should not be leaked to clients.
    func loadArchives() -> AnyPublisher<[ArchiveFile], Never> {
        let allArchives = config.gamesFilesDirectories.allArchives
        let publishers: [AnyPublisher<ArchiveFile, Never>] = allArchives.map(open(archive:))
        return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
    }
    

    
    
    func loadBasicInfoForMap(id mapID: Map.ID, inspector: Map.Loader.Parser.Inspector.BasicInfoInspector? = nil) -> AnyPublisher<Map.BasicInformation, AssetsProvider.Error> {
        Future { [self] promise in
            mapLoaderQueue.async {
                do {
//                    let start = CFAbsoluteTimeGetCurrent()
                    let mapBasicInfo = try Map.loadBasicInform(mapID, inspector: inspector)
//                    let diff =  CFAbsoluteTimeGetCurrent() - start
//                    print(String(format: "✨✅ Successfully loaded basic info for map: '\(mapBasicInfo.name)', took %.3f seconds", diff))
                    promise(.success(mapBasicInfo))
                } catch {
                    promise(.failure(AssetsProvider.Error.failedToLoadBasicInfoOfMap(id: mapID, error: error)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func loadMapIDs() -> AnyPublisher<[Map.ID], AssetsProvider.Error> {
        Future { [self] promise in
            dispatchQueue.async { [self] in
                do {
                    let path = config.gamesFilesDirectories.maps
                    let mapDirectoryContents = try fileManager.contentsOfDirectory(atPath: path)
                    let urlToMaps = URL(fileURLWithPath: path)
                    let mapIDs: [Map.ID] = mapDirectoryContents.map {
                        let mapPath = urlToMaps.appendingPathComponent($0)
                        return Map.ID.init(absolutePath: mapPath.path)
                    }
                    promise(.success(mapIDs))
                } catch let error as AssetsProvider.Error {
                    promise(.failure(error))
                } catch { uncaught(error: error, expectedType: AssetsProvider.Error.self) }
            }
        }.eraseToAnyPublisher()
    }
    
    func loadBasicInfoForAllMaps() -> AnyPublisher<[Map.BasicInformation], Never> {
        print("✨ Loading basic info for all maps...")
        var start: CFAbsoluteTime!
        return loadMapIDs().flatMap { (ids: [Map.ID]) -> AnyPublisher<[Map.BasicInformation], AssetsProvider.Error> in
            let publishers: [AnyPublisher<Map.BasicInformation, AssetsProvider.Error>] = ids.map { [self] (id: Map.ID) -> AnyPublisher<Map.BasicInformation, AssetsProvider.Error>  in
                let basicInfoPublisher: AnyPublisher<Map.BasicInformation, AssetsProvider.Error> = loadBasicInfoForMap(id: id)
                return basicInfoPublisher
            }
            
            return Publishers.MergeMany(publishers)
                .collect()
                .eraseToAnyPublisher()
        }
        .handleEvents(
            receiveOutput: { maps in
            let diff = CFAbsoluteTimeGetCurrent() - start
            print(String(format: "✨✅ Successfully loaded basic info for #\(maps.count) maps, took %.3f seconds", diff))
            },
            receiveRequest: { _ in
                start = CFAbsoluteTimeGetCurrent()
            }
        )
        .assertNoFailure()
        .eraseToAnyPublisher()
    }
    
    func loadImageFrom(
        pcx: PCXImage
    ) -> AnyPublisher<CGImage, AssetsProvider.Error> {
        imageLoader.loadImageFrom(pcx: pcx).mapError({
            AssetsProvider.Error.failedToLoadImage(name: pcx.name, error: $0)
        }).eraseToAnyPublisher()
    }
    
    func loadImageFrom(
        defFilFrame frame: DefinitionFile.Frame,
        palette: Palette?
    ) -> AnyPublisher<CGImage, Never> {
        
        let cacheKey = frame.imageCacheKey
        if let cached = imageCache[cacheKey] {
            print("✅ Cache contains image for DEF frame: \(frame.fileName)")
            return Just(cached).eraseToAnyPublisher()
        }
        print("⚠️ Image not found in cache")
        return imageLoader.loadImageFrom(
            pixelData: frame.pixelData,
            width: frame.width,
            palette: palette
        ).assertNoFailure().eraseToAnyPublisher().handleEvents(receiveOutput: { [self]
            newImage in
            assert(imageCache[cacheKey] == nil)
            imageCache[cacheKey] = newImage
            assert(imageCache[cacheKey] != nil)
        }).eraseToAnyPublisher()
        
    }
    
    
    func loadImage(terrain: Map.Tile.Terrain) -> AnyPublisher<CGImage, Never> {
        
        guard let needleDefFileName = terrainToDefFileName[terrain.kind] else {
            incorrectImplementation(shouldAlwaysBeAbleTo: "Get expected DEF file name for terrain kind.")
        }
        
//        let archiveFilePublisher: AnyPublisher<ArchiveFile, Never> = open(archive: .lod(.restorationOfErathiaSpriteArchive))
//
//        let lodFilePublisher: AnyPublisher<LodFile, Never> = archiveFilePublisher.flatMap { [self] archiveFile in
//            loadLODArchive(file: archiveFile)
//        }.eraseToAnyPublisher()
        
        let lodFilePublisher: AnyPublisher<LodFile, Never> = archiveCache[.lod(.restorationOfErathiaSpriteArchive)].map {
            guard case .archive(let spriteLodFile) = $0 else {
                incorrectImplementation(reason: "Wrong archive")
            }
            return Just(spriteLodFile).eraseToAnyPublisher()
        }!
        
        let fileEntryPublisher: AnyPublisher<LodFile.FileEntry, Never> = lodFilePublisher.map { lodFile in
            guard let fileEntry = lodFile.entries.first(where: { $0.fileName.lowercased() == needleDefFileName.lowercased() }) else {
                incorrectImplementation(shouldAlwaysBeAbleTo: "Find file entry matching expected DEF file.")
            }
            return fileEntry
        }.eraseToAnyPublisher()

        let defFilePublisher: AnyPublisher<DefinitionFile, Never> = fileEntryPublisher.flatMap({ (fileEntry: LodFile.FileEntry) -> AnyPublisher<DefinitionFile, Never> in
            guard case .def(let defFilePublisher) = fileEntry.content else {
                incorrectImplementation(reason: "Should be def file")
            }
            return defFilePublisher
        }).eraseToAnyPublisher().map { defFile in
            assert(defFile.kind == .terrain)
            return defFile
        }.eraseToAnyPublisher()

        return defFilePublisher.flatMap { [self] (defFile: DefinitionFile) -> AnyPublisher<CGImage, Never> in
            assert(defFile.blocks.count == 1)
            let block = defFile.blocks[0]
            let frame = block.frames[0]
            return self.loadImageFrom(defFilFrame: frame, palette: defFile.palette) // uses cache
        }.eraseToAnyPublisher()

    }
}

private enum ImageCacheKey: Hashable {
    case defFileFrame(id: DefinitionFile.Frame.ID)
}
private extension DefinitionFile.Frame {
    var imageCacheKey: ImageCacheKey {
        .defFileFrame(id: self.id)
    }
}

// MARK: Private
private extension AssetsProvider {
    
    func open(archive: Archive) -> AnyPublisher<ArchiveFile, Never> {
        
        if let cached = archiveFileCache[archive] {
            print("✅ Cache contains archive file: \(archive.fileName)")
            return Just(cached).eraseToAnyPublisher()
        }
        return Future<ArchiveFile, Never> { [self] promise in
            dispatchQueue.async {
                do {
                    print("✨ Opening contents of archive named: \(archive.fileName)")
                    let data = try loadContentsOfDataFile(name: archive.fileName)
                    let archiveFile = ArchiveFile(kind: archive, data: data)
                    archiveFileCache[archive] = archiveFile
                    promise(.success(archiveFile))
                } catch {
                    uncaught(error: error)
                }
            }
        }
        .share()
        .eraseToAnyPublisher()
       
    }
    
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
    public let basicInfoOfMaps: [Map.BasicInformation]
    private let loadedArchives: [LoadedArchive]
    
    internal init(
        loadedArchives: [LoadedArchive],
        basicInfoOfMaps: [Map.BasicInformation]
    ) {
        self.loadedArchives = loadedArchives
        self.basicInfoOfMaps = basicInfoOfMaps
    }
}

// MARK: Provide
private extension AssetsProvider {
    func provide(
        config: Config,
        progressSubject: PassthroughSubject<LoadingProgress, Never>?,
        fileManager: FileManager = .default
    ) -> AnyPublisher<Assets, Never> {

        var numberOfLoadedItems = 0
        let assetParsedInspector = AssetParsedInspector(
            onParseFileEntry: { fileEntry in
                numberOfLoadedItems += 1
            }
        )
        
        var startLoadingArchivesTime: CFAbsoluteTime!
        let loadedArchives = loadArchives().flatMap({ (archiveFiles: [ArchiveFile]) -> AnyPublisher<[LoadedArchive], Never> in
               
            let numberOfItemsToLoad = archiveFiles.map { try! self.archiveLoader.peekFileEntryCount(of: $0) }.reduce(0, +)
            
            let publishers = archiveFiles.map { [self] (archiveFile: ArchiveFile) in
                return load(archiveFile: archiveFile, inspector: assetParsedInspector).handleEvents(receiveOutput: { loadedArchive in
//                    numberOfLoadedItems += loadedArchive.numberOfEntries
                    print("numberOfLoadedItems: \(numberOfLoadedItems)")
                    progressSubject?.send(LoadingProgress.namedProgress("Load archive \(String(describing: archiveFile.fileName))", step: numberOfLoadedItems, of: numberOfItemsToLoad))
                }).eraseToAnyPublisher()
            }
            return Publishers.MergeMany(publishers).collect().eraseToAnyPublisher()
        })
            .handleEvents(
                receiveOutput: { loadedArchives in
                let diff = CFAbsoluteTimeGetCurrent() - startLoadingArchivesTime
                print(String(format: "✨✅ Successfully loaded #\(loadedArchives.count) archives, took %.3f seconds", diff))
                },
                receiveRequest: { _ in
                    startLoadingArchivesTime = CFAbsoluteTimeGetCurrent()
                }
            )
            .eraseToAnyPublisher()
        
        return Publishers.CombineLatest(
            loadedArchives,
            loadBasicInfoForAllMaps()
        ).map { (loadedArchives: [LoadedArchive], basicInfoOfMaps: [Map.BasicInformation]) -> Assets in
            let assets = Assets(
                loadedArchives: loadedArchives,
                basicInfoOfMaps: basicInfoOfMaps
            )
            if AssetsProvider.sharedAssets == nil {
                AssetsProvider.sharedAssets = assets
            }
            return assets
        }.eraseToAnyPublisher()
    }
}

public extension AssetsProvider {
    static func provide(
        config: Config,
        progressSubject: PassthroughSubject<LoadingProgress, Never>? = nil,
        fileManager: FileManager = .default
    ) -> AnyPublisher<Assets, Never> {
        if let assets = AssetsProvider.sharedAssets {
            return Just(assets).eraseToAnyPublisher()
        }
        let provider: AssetsProvider
        if let sharedProvider = shared {
            provider = sharedProvider
            assert(provider.config == config, "Figure out what to do if different configs...")
        } else {
            provider = AssetsProvider.init(config: config)
            shared = provider
        }
        return shared.provide(
            config: config,
            progressSubject: progressSubject,
            fileManager: fileManager
        )
    }
}

public extension Assets {
    func loadImageFrom(
        defFilFrame frame: DefinitionFile.Frame,
        palette: Palette?
    ) -> AnyPublisher<CGImage, Never> {
        fatalError()
    }
    
    func loadImage(terrain: Map.Tile.Terrain) -> AnyPublisher<CGImage, Never> {
        fatalError()
    }
    
    func loadBasicInfoForAllMaps() -> AnyPublisher<[Map.BasicInformation], Never> {
        fatalError()
    }
    
    
    func loadImageFrom(
        pcx: PCXImage
    ) -> AnyPublisher<CGImage, Never> {
        fatalError()
    }
    
    func loadArchives() -> AnyPublisher<[ArchiveFile], Never> {
        fatalError()
    }
    
//    func loadMap(id mapID: Map.ID, inspector: Map.Loader.Parser.Inspector? = nil) -> AnyPublisher<Map, Never> {
//
//    }
    func loadMap(id mapID: Map.ID, inspector: Map.Loader.Parser.Inspector? = nil) -> AnyPublisher<Map, Never> {
        Deferred {
            Future<Map, Never> { [self] promise in
                loadMapQueue.async {
                    do {
                        print("✨ Loading map...")
                        let start = CFAbsoluteTimeGetCurrent()
                        let map = try Map.load(mapID, inspector: inspector)
                        let diff = CFAbsoluteTimeGetCurrent() - start
                        print(String(format: "✨✅ Successfully loaded map '%@', took %.1f seconds", map.basicInformation.name, diff))
                        promise(.success(map))
                    } catch {
//                        promise(.failure(AssetsProvider.Error.failedToLoadMap(id: mapID, error: error)))
                        uncaught(error: error)
                    }
                }
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    func load(archiveFile: ArchiveFile) -> AnyPublisher<LoadedArchive, Never> {
        fatalError()
    }
}
