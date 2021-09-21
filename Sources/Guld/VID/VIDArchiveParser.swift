//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-20.
//

import Foundation
import Util
import Malm

public final class VIDArchiveParser {
    public init() {}
}

public struct VIDFile: Hashable {
    public let videoArchiveFileName: String
    public let fileEntries: [FileEntry]
}

public extension VIDFile {
    
    struct FileEntry: Hashable {
        public let fileName: String
        public let contents: Data
        public var fileExtension: String {
            fileName.fileExtension!
        }
        
        /// Without file extension
        public var name: String {
            String(fileName.split(separator: ".").first!)
        }
    }
}

extension VIDFile.FileEntry: Identifiable {
    public typealias ID = String
    public var id: ID { fileName }
}

public extension VIDArchiveParser {
    func parse(assetFile: AssetFile) throws -> VIDFile {
        precondition(assetFile.kind.isVIDFile)
        
        let reader = DataReader(data: assetFile.data)
        
        let fileCount = try reader.readUInt32()
       
        let nameAndOffsetList: [(name: String, offset: Int)] = try fileCount.nTimes {
            let fileName = try reader.readStringOfKnownMaxLength(40)!
            let fileOffset = try reader.readInt32()
            
            return (
                name: fileName,
                offset: .init(fileOffset)
            )
        }
      
        let metaDatas: [(name: String, offset: Int, size: Int)] = nameAndOffsetList.enumerated().map {
            let (name, offset) = $0.element
            let index = $0.offset
            
            let size: Int
            if index == fileCount - 1 { // last element
                size = assetFile.data.count - offset
            } else {
                let offsetNext = nameAndOffsetList[index + 1].offset
                assert(offsetNext > offset)
                size = offsetNext - offset
            }
            
            return (name, offset, size)
        }
        
        let fileEntries: [VIDFile.FileEntry] = try metaDatas.map {
            try reader.seek(to: $0.offset)
            let contents = try reader.read(byteCount: $0.size)
            return .init(fileName: $0.name, contents: contents)
        }
        
        return .init(
            videoArchiveFileName: assetFile.fileName,
            fileEntries: fileEntries
        )
    }
}

