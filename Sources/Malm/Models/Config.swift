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

private extension Config.Directories {
    
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
        let dataFiles = try FileManager.default.contentsOfDirectory(atPath: data)
        
        func exists(dataFileNamed name: String) throws {
            guard dataFiles.contains(name) else {
                throw Error.missingDataFile(named: name)
            }
        }
        
        try dataFiles.forEach(exists(dataFileNamed:))
    }
   
}

public protocol AssetFile {
    var fileName: String { get }
}
public extension AssetFile where Self: RawRepresentable, Self.RawValue == String {
    var fileName: String { rawValue }
}

public enum Asset: AssetFile, Hashable, CaseIterable {
    case archive(Archive)
case sound(Sound)
case video(Video)
    
    public var fileName: String {
        switch self {
        case .archive(let value): return value.fileName
        case .sound(let value): return value.fileName
        case .video(let value): return value.fileName
        }
    }
    
    public static var allCases: [Self] {
        return Archive.allCases.map { Self.archive($0) } +
        Sound.allCases.map { Self.sound($0) } +
        Video.allCases.map { Self.video($0) }
    }
}

public extension Asset {
    enum Archive: String, Hashable, CaseIterable, AssetFile {
        case armageddonsBladeBitmapArchive = "H3ab_bmp.lod"
        case armageddonsBladeSpriteArchive = "H3ab_spr.lod"
        case restorationOfErathiaBitmapArchive = "H3bitmap.lod"
        case restorationOfErathiaSpriteArchive = "H3sprite.lod"
    }
    
    enum Sound: String, Hashable, CaseIterable, AssetFile {
        case armageddonsBladeSoundFile = "H3ab_ahd.snd"
        case restorationOfErathiaSoundFile = "Heroes3.snd"
    }
    
    enum Video: String, Hashable, CaseIterable, AssetFile {
        case armageddonsBladeVideoFile = "H3ab_ahd.vid"
        case restorationOfErathiaVideoFile = "VIDEO.VID"
    }
}

public extension Config.Directories {
  
    static let dataFiles = Asset.allCases.map { $0.fileName }
    
    enum Error: Swift.Error, Equatable {
        case noMapsFound
        case missingDataFile(named: String)
    }
    
    /// Validates that DATA and MAPS directories are found and non-empty.
    /// Deep validation of DATA directory is performed, i.e. validate that expected files are in there.
    func validate() throws {
        try validateMapsDirectory()
        try validateDataDirectory()
    }
    
    static let defaultGamesFilesDirectoryPath = "~/Library/Application Support/Makt/"
    static let defaultMapsDirectoryName = "Maps"
    static let defaultDataDirectoryName = "Data"
    static let defaultMapsDirectoryPath = defaultGamesFilesDirectoryPath.appending(defaultMapsDirectoryName)
    static let defaultDataDirectoryPath = defaultGamesFilesDirectoryPath.appending(defaultDataDirectoryName)
    
    enum Directory: Hashable {
        case `default`
        case customRelative(to: String)
    }
}
