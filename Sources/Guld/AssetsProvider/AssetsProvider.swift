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
    private let archiveLoader: ArchiveLoader = .init()
    private let mapLoaderQueue: DispatchQueue = DispatchQueue(label: "MapLoader", qos: .background)
    private let dispatchQueue: DispatchQueue = DispatchQueue(label: "AssetsProvider", qos: .background)
    
    private var archiveFileCache: [Archive: ArchiveFile] = [:]
    private var archiveCache: [Archive: LoadedArchive] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    private static var shared: AssetsProvider!
    
    private init(
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
            .handleEvents(receiveOutput: { [unowned self] (loadedArchive: LoadedArchive) in
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
//        return Future<LodFile, Never> { [unowned self] promise in
//            dispatchQueue.async { [unowned self] in
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
        Future { [unowned self] promise in
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
        Future { [unowned self] promise in
            dispatchQueue.async { [unowned self] in
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
            let publishers: [AnyPublisher<Map.BasicInformation, AssetsProvider.Error>] = ids.map { [unowned self] (id: Map.ID) -> AnyPublisher<Map.BasicInformation, AssetsProvider.Error>  in
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
    
}


// MARK: Private
private extension AssetsProvider {
    
    func open(archive: Archive) -> AnyPublisher<ArchiveFile, Never> {
        
        if let cached = archiveFileCache[archive] {
            print("✅ Cache contains archive file: \(archive.fileName)")
            return Just(cached).eraseToAnyPublisher()
        }
        return Future<ArchiveFile, Never> { [unowned self] promise in
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

    private let loadedArchives: [LoadedArchive]
   
    public let basicInfoOfMaps: [Map.BasicInformation]
    private let imageLoader: ImageLoader
    
    internal init(
        loadedArchives: [LoadedArchive],
        basicInfoOfMaps: [Map.BasicInformation],
        imageLoader: ImageLoader
    ) {
        self.loadedArchives = loadedArchives
        self.basicInfoOfMaps = basicInfoOfMaps
        self.imageLoader = imageLoader
    }
}

//public extension Assets {
//    final class TerrainSprites {
//
//        public let surfaceSprites: SurfaceSprites
//        public let roadSprites: RoadSprites
//        public let riverSprites: RiverSprites
//
//        internal init(
//            surfaceSprites: SurfaceSprites,
//            roadSprites: RoadSprites,
//            riverSprites: RiverSprites
//        ) {
//            self.surfaceSprites = surfaceSprites
//            self.roadSprites = roadSprites
//            self.riverSprites = riverSprites
//        }
//    }
//}
//
//public extension Assets.TerrainSprites {
//
//    final class SurfaceSprites {
//
//    }
//    final class RoadSprites {}
//    final class RiverSprites {}
//}

// MARK: Provide
private extension AssetsProvider {
    
    func imageLoaderWithPreloadedTerrainSprites(
        archives: [LoadedArchive],
        progressSubject: PassthroughSubject<LoadingProgress, Never>?
    ) -> AnyPublisher<ImageLoader, Never> {
        let imageLoader = ImageLoader(lodFiles: archives.compactMap { $0.lodArchive })
        
        let terrainPublishers = Map.Tile.Terrain.Kind.allCases.map { terrainKind in
            imageLoader.loadAllSpritesForTerrainKind(terrainKind).handleEvents(receiveOutput: { _ in
                progressSubject?.send(.step(named: "Loaded image for terrain kind: \(String(describing: terrainKind))"))
            }).eraseToAnyPublisher()
        }
        let terrainImagesPublisher = Publishers.MergeMany(terrainPublishers).collect().eraseToAnyPublisher()
        
        return terrainImagesPublisher.map { _ in
            return imageLoader
        }.eraseToAnyPublisher()
    }
    
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
            
            let publishers = archiveFiles.map { [unowned self] (archiveFile: ArchiveFile) in
                return load(archiveFile: archiveFile, inspector: assetParsedInspector).handleEvents(receiveOutput: { loadedArchive in
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
            .share()
            .eraseToAnyPublisher()
        
        let imageLoaderWithTerrainSprites = loadedArchives.flatMap { [self ]loadedArchives in
            imageLoaderWithPreloadedTerrainSprites(archives: loadedArchives, progressSubject: progressSubject)
        }.eraseToAnyPublisher()
        
        return Publishers.CombineLatest3(
            loadedArchives,
            loadBasicInfoForAllMaps(),
            imageLoaderWithTerrainSprites
        ).map {
            (
                loadedArchives: [LoadedArchive],
                basicInfoOfMaps: [Map.BasicInformation],
                imageLoaderWithTerrainSprites: ImageLoader
            ) -> Assets in
            
            let assets = Assets(
                loadedArchives: loadedArchives,
                basicInfoOfMaps: basicInfoOfMaps,
                imageLoader: imageLoaderWithTerrainSprites
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
    
    func loadImage(terrain: Map.Tile.Terrain) -> AnyPublisher<LoadedImage, Never> {
        imageLoader.loadImage(terrain: terrain)
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
            Future<Map, Never> { [unowned self] promise in
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
