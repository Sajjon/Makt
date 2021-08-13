//
//  ResourceAccessor+Error.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

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
