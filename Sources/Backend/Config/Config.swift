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
    
    private let dataDirectory: DataDirectory
    private let mapsDirectory: MapsDirectory
    private let musicDirectory: MusicDirectory
    
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

public protocol OriginalResourceDirectoryKind: Hashable {
    static var name: String { get }
    static var requiredDirectoryContents: [String] { get }
}
public extension OriginalResourceDirectoryKind {
    static var name: String { .init(describing: self) }
}

/// Namespace for OriginalResourceDirectory kinds
public enum OriginalResourceDirectories {}

