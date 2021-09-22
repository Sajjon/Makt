//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-22.
//

import Foundation

public extension Config.Directories {
  
    static let allArchives = Archive.allCases
    var allArchives: [Archive] { Self.allArchives }
    
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
