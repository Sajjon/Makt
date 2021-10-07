//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public extension DefinitionFile {
    
    /// A picture frame as part of a file defined in the defintion file
    struct Frame: ArchiveFileEntry, Hashable, Identifiable, CustomDebugStringConvertible {
        public typealias ID = String
        
        enum EncodingFormat: UInt32, Hashable {
            case nonCompressed
            
            /// Compressed with repeating code fragments
            /// For each line we have offset of pixel data
            case repeatingCodeFragment
            
            /// Compressed with repeating segment fragments
            case repeatingSegmentFragments
            
            /// Compressed with repeating segment fragments.
            /// Each row is split into 32 byte long blocks which are individually encoded
            /// two bytes store the offset for each block per line
            case repeatingSegmentFragmentsEncodingEachLineIndividually
        }
        
        /// internals only... completely irrelevant for clients. this is what encoding
        internal let encodingFormat: EncodingFormat
        
        public var id: ID { fileName }
        public let defFileName: String
        public let blockIndex: Int
        public let fileName: String
        public let fullSize: CGSize
        public let rect: CGRect
        public let pixelData: Data
        
        public var debugDescription: String {
            """
            
            =========================================
            DEF frame
            fileName: \(fileName)
            fullSize: \(String(describing: fullSize))
            rect: \(String(describing: rect))
            pixelData: \(pixelData.hexEncodedString())
            ------------------------------------------
            
            """
        }
    }
}

public extension DefinitionFile.Frame {
    var byteCount: Int {
        pixelData.count
    }
   
    var parentArchiveName: String {
        defFileName
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.size)
        hasher.combine(self.origin)
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}
