//
//  Config.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation
public struct Config: Hashable {
    public static let defaultGamesFilesDirectoryPath = "/Users/sajjon/Library/Application Support/HoMM3SwiftUI/"
    public let gamesFilesDirectoryPath: String
    public let fileManager: FileManager
    public init(gamesFilesDirectoryPath: String = Self.defaultGamesFilesDirectoryPath, fileManager: FileManager = .default) {
        self.gamesFilesDirectoryPath = gamesFilesDirectoryPath
        self.fileManager = fileManager
    }
}
