//
//  ResourceAccessor.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

/// A type for accessing original game resource that are required to run the HoMM3 game.
///
/// Contains file handlers for data files, map files and music files.
public struct ResourceAccessor: Equatable, Hashable {
    
    public let dataDirectory: DataDirectory
    public let mapsDirectory: MapsDirectory
    public let musicDirectory: MusicDirectory
    
    public init(
        config: Config = .init()
    ) throws {
        let fileManager = config.fileManager
        let gameFilesPath = config.gameFilePath
        guard let filesAtPath = try? fileManager.contentsOfDirectory(atPath: gameFilesPath) else {
            throw Error.gameFileDirectoryNotFound(at: gameFilesPath)
        }
        
   
        func create<D>() throws -> OriginalResourceDirectory<D> where D: OriginalResourceDirectoryKind {
            let directoryName = D.name
            guard filesAtPath.contains(directoryName) else {
                throw Error.gameFilesDirectoryDoesNotContain(requiredDirectory: directoryName)
            }
            return try .init(parentDirectory: gameFilesPath, fileManager: fileManager)
        }

        self.dataDirectory = try create()
        self.mapsDirectory = try create()
        self.musicDirectory = try create()
        
    }
}

// MARK: Error
public extension ResourceAccessor {
    enum Error: Swift.Error, Equatable {
        case directoryNotFound(invalidPath: String, purpose: String)
        case gameFilesDirectoryDoesNotContain(requiredDirectory: String)
        case gameFiles(directory: String, doesNotContainRequiredFile: String)
        case failedToOpenFileForReading(filePath: String)
    }
}

public extension ResourceAccessor.Error {
    static func gameFileDirectoryNotFound(at invalidPath: String) -> Self {
        .directoryNotFound(invalidPath: invalidPath, purpose: "Game Files")
    }
}


// MARK: Directory kinds
public extension ResourceAccessor {
    typealias DataDirectory = OriginalResourceDirectory<OriginalResourceDirectories.Data>
    typealias MapsDirectory = OriginalResourceDirectory<OriginalResourceDirectories.Maps>
    typealias MusicDirectory = OriginalResourceDirectory<OriginalResourceDirectories.Music>
}

public protocol FileNameConvertible {
    var fileName: String { get }
}

public extension FileNameConvertible where Self: RawRepresentable, Self.RawValue == String {
    var fileName: String { rawValue }
}

public protocol OriginalResourceDirectoryKind: Hashable where Content: RawRepresentable, Content.RawValue == String {
    associatedtype Content: FileNameConvertible & Hashable
    static var name: String { get }
    static var requiredDirectoryContents: [Content] { get }
}
public extension OriginalResourceDirectoryKind {
    static var name: String { .init(describing: self) }
}

/// Namespace for OriginalResourceDirectory kinds
public enum OriginalResourceDirectories {}


/// Public access file handlers
public extension ResourceAccessor.OriginalResourceDirectory {
    func handleFor(file fileId: Kind.Content) -> File {
        guard let file = files[fileId] else {
            fatalError("Expected to find file named: \(fileId.fileName)")
        }
        return file
    }
}

public extension ResourceAccessor {
    func map(named fileId: OriginalResourceDirectories.Maps.Content) -> ResourceAccessor.OriginalResourceDirectory<OriginalResourceDirectories.Maps>.File {
        mapsDirectory.handleFor(file: fileId)
    }
    
    func data(named fileId: OriginalResourceDirectories.Data.Content) -> ResourceAccessor.OriginalResourceDirectory<OriginalResourceDirectories.Data>.File {
        dataDirectory.handleFor(file: fileId)
    }
    
    func music(named fileId: OriginalResourceDirectories.Music.Content) -> ResourceAccessor.OriginalResourceDirectory<OriginalResourceDirectories.Music>.File {
        musicDirectory.handleFor(file: fileId)
    }
}

