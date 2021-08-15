//
//  Map+Loader+Parser.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map.Loader {
    final class Parser {
        private let config: Config
        init(config: Config) {
            self.config = config
        }
    }
}

public extension Map.Loader.Parser {
    func parse(readMap: Map.Loader.ReadMap) throws -> Map {
        .init(about: .init(id: readMap.id, fileSize: readMap.fileHandle.availableData.count))
    }
}
