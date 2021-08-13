//
//  Config.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

/// A configuration required to run the HoMM3 game.
///
/// Contains e.g. paths to original game resources.
public struct Config: Equatable, Hashable {
    
    public let dataDirectory: DataDirectory
    public let mapsDirectory: MapsDirectory
    public let musicDirectory: MusicDirectory
    
    public init(
        absolutePathToGameFiles gameFilesPath: String = "/Users/sajjon/Library/Application Support/HoMM3SwiftUI",
        fileManager: FileManager = .default
    ) throws {
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
public extension Config {
    enum Error: Swift.Error, Equatable {
        case directoryNotFound(invalidPath: String, purpose: String)
        case gameFilesDirectoryDoesNotContain(requiredDirectory: String)
        case gameFiles(directory: String, doesNotContainRequiredFile: String)
        case failedToOpenFileForReading(filePath: String)
    }
}

public extension Config.Error {
    static func gameFileDirectoryNotFound(at invalidPath: String) -> Self {
        .directoryNotFound(invalidPath: invalidPath, purpose: "Game Files")
    }
}


// MARK: Directory kinds
public extension Config {
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
public extension Config.OriginalResourceDirectory {
    func handleFor(file fileId: Kind.Content) -> File {
        guard let file = files[fileId] else {
            fatalError("Expected to find file named: \(fileId.fileName)")
        }
        return file
    }
}

public extension Config {
    func map(named fileId: OriginalResourceDirectories.Maps.Content) -> Config.OriginalResourceDirectory<OriginalResourceDirectories.Maps>.File {
        mapsDirectory.handleFor(file: fileId)
    }
    
    func data(named fileId: OriginalResourceDirectories.Data.Content) -> Config.OriginalResourceDirectory<OriginalResourceDirectories.Data>.File {
        dataDirectory.handleFor(file: fileId)
    }
    
    func music(named fileId: OriginalResourceDirectories.Music.Content) -> Config.OriginalResourceDirectory<OriginalResourceDirectories.Music>.File {
        musicDirectory.handleFor(file: fileId)
    }
}

