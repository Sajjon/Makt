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

// MARK: Error
public extension AssetLoader {
    enum Error: Swift.Error {
        case noAssetExistsAtPath(String)
        case failedToLoadAssetAtPath(String)
    }
}

// MARK: Load
public extension AssetLoader {
    func load(archive: Archive) throws -> ArchiveFile {
        let data = try loadContentsOfDataFile(name: archive.fileName)
        return ArchiveFile(kind: archive, data: data)
    }
    
    func loadArchives() -> AnyPublisher<[ArchiveFile], AssetLoader.Error> {
        Future { promise in
            DispatchQueue(label: "LoadAsset", qos: .background).async { [self] in
                do {
                    let assetFiles = try config.gamesFilesDirectories.allArchives.map(load(archive:))
                    promise(Result.success(assetFiles))
                } catch let error as AssetLoader.Error {
                    promise(Result.failure(error))
                } catch { uncaught(error: error, expectedType: AssetLoader.Error.self) }
            }
        }.eraseToAnyPublisher()
    }
}

// MARK: Private
private extension AssetLoader {
    
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
