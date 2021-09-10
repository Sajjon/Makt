//
//  Map+Decrompress.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation
import Malm

/// https://github.com/1024jp/GzipSwift
import Gzip

public protocol Decompressor {
    func isHeaderCompressed(format: Map.Format.RawVersionValue) -> Bool
    func parser(readMap: Map.Loader.ReadMap) throws -> Map.Loader.Parser.H3M
}

public extension Map.Loader.Parser {
    final class GzipDecompressor: Decompressor {
        public init() {}
    }
}


public extension Map.Loader.Parser.GzipDecompressor {
    
    /// A "well known"/standardized unique header number idenitfying a file as a "gzip" file.
    ///
    /// Source1: https://github.com/vcmi/vcmi/blob/develop/lib/mapping/CMapService.cpp#L105
    /// Source2: https://github.com/brgl/busybox/blob/master/archival/gzip.c#L2081
    /// Source3: https://stackoverflow.com/a/33378248/1311272
    /// Source4: https://zenhax.com/viewtopic.php?p=62470#p62470
    private static let gzipped: UInt32 = 0x00088b1f
    
    func isHeaderCompressed(format: Map.Format.RawVersionValue) -> Bool {
        format == Self.gzipped
    }
    
    func parser(readMap: Map.Loader.ReadMap) throws -> Map.Loader.Parser.H3M {
        guard
            readMap.data.isGzipped // this computed property is an extension from `Gzip` SPM package imported above.
        else {
            fatalError("Gzip library does not think this data is gzipped")
        }
        
        // The method `gunzipped` is an extension from `Gzip` SPM package imported above.
        let decompressedData: Data = try readMap.data.gunzipped()
        
        let readMapDecompressed = Map.Loader.ReadMap(
            data: decompressedData,
            filePath: readMap.filePath,
            id: readMap.id
        )
        
        let h3mParser = Map.Loader.Parser.H3M(
            readMap: readMapDecompressed,
            fileSizeCompressed: readMap.data.count
        )
        
        return h3mParser
    }
}
