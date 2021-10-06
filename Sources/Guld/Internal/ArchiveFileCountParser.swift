//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import Util
import Malm

public protocol ArchiveFileCountParser {
    func peekFileEntryCount(of archiveFile: SimpleFile) throws -> Int
}

public extension ArchiveFileCountParser {
    func peekFileEntryCount(of archiveFile: SimpleFile) throws -> Int {
        let reader = DataReader(data: archiveFile.data)
        let fileCount = try reader.readUInt32()
        return .init(fileCount)
    }
}
