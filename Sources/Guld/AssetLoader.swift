//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation
import Malm
import Combine

public final class AssetLoader {
    private let config: Config
    private let fileManager: FileManager
    public init(config: Config, fileManager: FileManager = .default) {
        self.config = config
        self.fileManager = fileManager
    }
}

public extension AssetLoader {
   
    
    func load(archive: Asset.Archive) -> AnyPublisher<LodFile, Error> {
        fatalError()
    }
    
    enum Error: Swift.Error {
        case noAssetExistsAtPath(String)
        case failedToLoadAssetAtPath(String)
    }
}

private extension AssetLoader {
    func loadRawAsset(_ asset: Asset) throws -> Data {
        let path = config.gamesFilesDirectories.data.appending("/").replacingOccurrences(of: "//", with: "/").appending(asset.fileName)
        
        guard fileManager.fileExists(atPath: path) else {
            throw Error.noAssetExistsAtPath(path)
        }
        
        guard let data = fileManager.contents(atPath: path) else {
            throw Error.failedToLoadAssetAtPath(path)
        }
        
        return data
    }
}
