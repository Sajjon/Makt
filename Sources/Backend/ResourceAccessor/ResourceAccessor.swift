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
        
   
        func create<D>() throws -> Directory<D> where D: ResourceKind {
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


// MARK: Public
public extension ResourceAccessor {
    typealias DataDirectory = Directory<ResourceAccessor.Data>
    typealias MapsDirectory = Directory<Maps>
    typealias MusicDirectory = Directory<Music>
}
