//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation
import Malm
import Util
import Combine

public final class AssetLoader {
    public let config: Config
    private let fileManager: FileManager
    public init(config: Config, fileManager: FileManager = .default) {
        self.config = config
        self.fileManager = fileManager
    }
}

public extension AssetLoader {
   
    
    func load(archive: Asset.Archive) -> AnyPublisher<LodFile, AssetLoader.Error> {
        fatalError()
    }
    
    enum Error: Swift.Error {
        case noAssetExistsAtPath(String)
        case failedToLoadAssetAtPath(String)
    }

    func loadAssetFile(_ asset: Asset) throws -> AssetFile {
        let path = config.gamesFilesDirectories.data.appending("/").replacingOccurrences(of: "//", with: "/").appending(asset.fileName)
        
        guard fileManager.fileExists(atPath: path) else {
            throw Error.noAssetExistsAtPath(path)
        }
        
        guard let data = fileManager.contents(atPath: path) else {
            throw Error.failedToLoadAssetAtPath(path)
        }
        return AssetFile(kind: asset, data: data)
    }
    
    func loadAll() -> AnyPublisher<[AssetFile], AssetLoader.Error> {
        Future { promise in
            DispatchQueue(label: "LoadAsset", qos: .background).async { [self] in
                do {
                    let assetFiles = try config.gamesFilesDirectories.allAssets.map(loadAssetFile(_:))
                    promise(Result.success(assetFiles))
                } catch let error as AssetLoader.Error {
                    promise(Result.failure(error))
                } catch { uncaught(error: error, expectedType: AssetLoader.Error.self) }
            }
        }.eraseToAnyPublisher()
    }
    
}
