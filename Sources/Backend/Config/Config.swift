//
//  ResourceAccessor.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

public struct Config: Equatable, Hashable {
    public let gameFilePath: String
    public let fileManager: FileManager
    public init(
        gameFilePath: String = Config.defaultGameFilePath,
        fileManager: FileManager = .default
    ) {
        self.gameFilePath = gameFilePath
        self.fileManager = fileManager
    }
}


public extension Config {
    static let defaultGameFilePath = "/Users/sajjon/Library/Application Support/HoMM3SwiftUI"
}
