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
    ) throws {
        try gamesFilesDirectories.validate()
        self.gamesFilesDirectories = gamesFilesDirectories
        self.fileManager = fileManager
    }
    
}

public extension Config {
    
    struct Directories: Hashable {
        public let maps: String
        public let data: String
        
        public init(resourcePath: String) {
            self.init(
                maps: .customRelative(to: resourcePath),
                data: .customRelative(to: resourcePath)
            )
        }
        
        public init(
            maps: Directory = .default,
            data: Directory = .default
        ) {
            self.maps = (Self.resolve(maps: maps) as NSString).expandingTildeInPath.appending("/")
            self.data = (Self.resolve(data: data) as NSString).expandingTildeInPath.appending("/")
        }
    }
        
    
}

internal extension Config.Directories {
    
    static func resolve(maps: Directory) -> String {
        switch maps {
        case .customRelative(let customBase): return customBase.appending(defaultMapsDirectoryName)
        case .default: return self.defaultMapsDirectoryPath
        }
    }
    
    static func resolve(data: Directory) -> String {
        switch data {
        case .customRelative(let customBase): return customBase.appending(defaultDataDirectoryName)
        case .default: return self.defaultDataDirectoryPath
        }
    }
    
    func validateMapsDirectory() throws {
        let maps = try FileManager.default.contentsOfDirectory(atPath: maps)
        guard maps.contains(where: { map in
            map.hasSuffix(Map.fileExtension)
        }) else {
            throw Error.noMapsFound
        }
    }
 
    func validateDataDirectory() throws {
        let foundFiles = try FileManager.default.contentsOfDirectory(atPath: data)
        
        func exists(dataFileNamed name: String) throws {
            guard foundFiles.contains(name) else {
                throw Error.missingDataFile(named: name)
            }
        }
        
        try Self.allArchives.map({ $0.fileName }).forEach(exists(dataFileNamed:))
    }
   
}
