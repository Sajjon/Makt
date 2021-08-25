//
//  Config.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

/// Global app configuration containing various settings needed to run the game.
public struct Config: Hashable {
    
    public let gamesFilesDirectories: Directories
    public let fileManager: FileManager
    
    public init(
        gamesFilesDirectories: Directories = .init(),
        fileManager: FileManager = .default
    ) {
        self.gamesFilesDirectories = gamesFilesDirectories
        self.fileManager = fileManager
    }
    
}

public extension Config {
    
    struct Directories: Hashable {
        public let maps: String
        public let data: String
        
        public init(
            maps: Directory = .default,
            data: Directory = .default
        ) {
            self.maps = Self.resolve(maps: maps)
            self.data = Self.resolve(data: data)
        }
    }
        
    
}

private extension Config.Directories {
    
    static func resolve(maps: Directory) -> String {
        switch maps {
        case .custom(let custom): return custom
        case .default: return self.defaultMapsDirectoryPath
        }
    }
    
    static func resolve(data: Directory) -> String {
        switch data {
        case .custom(let custom): return custom
        case .default: return self.defaultDataDirectoryPath
        }
    }
}

public extension Config.Directories {
    
    
    static let defaultGamesFilesDirectoryPath = "/Users/sajjon/Library/Application Support/HoMM3SwiftUI/"
    static let defaultMapsDirectoryPath = "\(defaultGamesFilesDirectoryPath)/Maps/"
    static let defaultDataDirectoryPath = "\(defaultGamesFilesDirectoryPath)/Data/"
    
    enum Directory: Hashable {
        case `default`
        case custom(String)
    }
}
