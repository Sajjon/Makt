//
//  Map+Loader.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map {
    final class Loader {
        
        private let config: Config
        private let reader: Reader
        private let parser: Parser
        
        /// A simple cache for maps so that they can be loaded faster
        /// next time.
        /// 
        /// `internal` access modifier so that it can be tested.
        internal let cache: Cache
        
        init(
            config: Config,
            reader: Reader,
            parser: Parser,
            cache: Cache
        ) {
            self.config = config
            self.reader = reader
            self.parser = parser
            self.cache = cache
        }
    }
}

public extension Map.Loader {
    
    static let shared = Map.Loader()
    
    convenience init(
        config: Config = .init()
    ) {
        self.init(
            config: config,
            reader: .init(config: config),
            parser: .init(config: config),
            cache: .init(config: config)
        )
    }
}

// MARK: Private
private extension Map.Loader {
    var mapsDirectoryPath: String { config.gamesFilesDirectoryPath.appending("Maps/") }
    
    func load(unparsed mapId: Map.ID) throws -> Map {
        let mapPath = mapsDirectoryPath.appending(mapId.fileName)
        guard let rawMapData = config.fileManager.contents(atPath: mapPath) else {
            throw Error.mapFileNotFound(at: mapPath)
        }
        return Map(
            about: .init(
                id: mapId,
                fileSize: rawMapData.count
            )
        )
    }
}

// MARK: Public
public extension Map.Loader {
    func load(id mapID: Map.ID) throws -> Map {
        if let cachedMap = cache.load(id: mapID) {
            return cachedMap
        }
        let map = try load(unparsed: mapID)
        cache.save(map: map)
        return map
    }
}

// MARK: Error
public extension Map.Loader {
    enum Error: Swift.Error {
        case mapFileNotFound(at: String)
    }
    
}
