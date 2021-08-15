//
//  Map+Loader+Reader.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map.Loader {
    
    /// A type resonsible for reading raw data from map files on disc.
    struct ReadMap: Equatable {
        public let fileHandle: FileHandle
        public let filePath: String
        public let id: Map.ID
    }
}

public extension Map.Loader {
    final class Reader {
        private let config: Config
        init(config: Config) {
            self.config = config
        }
    }
}

// MARK: Private
private extension Map.Loader.Reader {
    var mapsDirectoryPath: String { config.gamesFilesDirectoryPath.appending("Maps/") }
}


// MARK: Public
public extension Map.Loader.Reader {
    
    func read(by mapId: Map.ID) throws -> Map.Loader.ReadMap {
        let mapPath = mapsDirectoryPath.appending(mapId.fileName)
        guard let fileHandle = FileHandle(forReadingAtPath: mapPath) else {
            throw Map.Loader.Error.mapFileNotFound(at: mapPath)
        }
        
        return .init(fileHandle: fileHandle, filePath: mapPath, id: mapId)
    }
}
