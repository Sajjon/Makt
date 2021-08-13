//
//  Config+OriginalResourceDirectory.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

public extension Config {
    
    /// Original resources that you need to buy in order to run this game.
    ///
    /// Three folders are required:
    ///  * Data
    ///  * Maps
    ///  * Mp3
    ///
    /// Each directory is expected to contain these files:
    ///
    /// # Data
    /// Must contain:
    /// * H3ab_ahd.snd
    /// * H3ab_ahd.vid
    /// * H3ab_bmp.lod
    /// * H3ab_spr.lod
    /// * H3bitmap.lod
    /// * H3sprite.lod
    /// * Heroes3.snd
    /// * VIDEO.VID
    ///
    /// # Maps
    /// Contains the playable scenario maps, e.g. `"Titans Winter"`,
    /// expected file extension is `.h3m` with exception for the tutorial
    /// map which has file extension `".tut"`.
    ///
    /// # Music
    /// Mp3 files or ogg files (if you have converted them, which I (Cyon) have for some reason
    /// (I think VCMI recommended me to do it?)), e.g. `"TowerTown.ogg"` or `"SNOW.ogg"`
    ///
    struct OriginalResourceDirectory<Kind>: Equatable, Hashable where Kind: OriginalResourceDirectoryKind {
        public struct File: Equatable, Hashable {
            public let fileHandle: FileHandle
            public let content: Kind.Content
        }
        public let path: String
        public let files: [Kind.Content: File]
        public init(parentDirectory: String, fileManager: FileManager = .default) throws {
            let path = parentDirectory.appending("/").appending(Kind.name)
            self.files = try Dictionary(uniqueKeysWithValues: Kind.requiredDirectoryContents.map { content in
                let fileName = content.fileName
                let filePath = path.appending("/").appending(fileName)
                guard fileManager.fileExists(atPath: filePath) else {
                    throw Config.Error.gameFiles(directory: Kind.name, doesNotContainRequiredFile: filePath)
                }
                guard let fileHandle = FileHandle(forReadingAtPath: filePath) else {
                    throw Config.Error.failedToOpenFileForReading(filePath: filePath)
                }
                return .init(fileHandle: fileHandle, content: content)
            }.map({ (key: $0.content, value: $0) }))
            self.path = path
        }
    }
}

public extension Config.OriginalResourceDirectory.File {
    var fileName: String { content.fileName }
    var data: Data { fileHandle.availableData }
    var fileSize: Int { data.count }
}
