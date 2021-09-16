//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

import Foundation
import Util

public final class LodParser {
    internal let reader: DataReader
    public init(data: Data) {
        self.reader = DataReader(data: data)
    }
}

public extension LodParser {
    func parse() throws -> LodFile {
        let header: String = try {
            let data = try reader.read(byteCount: 4)
            let string = String(bytes: data, encoding: .utf8) ?? String(bytes: data, encoding: .ascii)!
            return string.trimmingCharacters(in: .whitespacesAndNewlines)
        }()
        
        guard header == "LOD" else {
            throw Error.notLodFile(gotHeader: header)
        }
        
        try reader.seek(to: 8) // i.e. skip 4 bytes...
        let entryCount = try reader.readUInt32()
        try reader.seek(to: 92)
        
        let entries = try entryCount.nTimes {
            try parseEntry()
        }
        
        return .init(entries: entries)
    }
}

private extension LodParser {
    func parseEntry() throws -> LodFile.FileEntry {
        let fileName: String = try {
           let data = try reader.read(byteCount: 16)
           let string = String(bytes: data, encoding: .utf8) ?? String(bytes: data, encoding: .ascii)!
           return string.trimmingCharacters(in: .whitespacesAndNewlines)
       }()
        
        let offset = try reader.readUInt32()
        let size = try reader.readUInt32()
        let _ = try reader.readUInt32() // unknown
        let csize = try reader.readUInt32()
        
        fatalError()
    }
}

private extension LodParser {
    enum Error: Swift.Error, Equatable {
        case notLodFile(gotHeader: String)
    }
}
