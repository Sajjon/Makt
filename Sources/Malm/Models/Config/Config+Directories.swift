//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-22.
//

import Foundation

public extension Config.Directories {
  
    enum Error: Swift.Error, Equatable {
        case noMapsFound
        case missingDataFile(named: String)
    }

    static let defaultGamesFilesDirectoryPath = "~/Library/Application Support/Tritium/Original/"
    static let defaultMapsDirectoryName = "Maps"
    static let defaultDataDirectoryName = "Data"
    static let defaultMapsDirectoryPath = defaultGamesFilesDirectoryPath.appending(defaultMapsDirectoryName)
    static let defaultDataDirectoryPath = defaultGamesFilesDirectoryPath.appending(defaultDataDirectoryName)
    
    enum Directory: Hashable {
        case `default`
        case customRelative(to: String)
    }
}
