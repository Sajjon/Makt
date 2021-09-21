//
//  Map+Decrompress.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

/// https://github.com/1024jp/GzipSwift
import Gzip

public protocol Decompressor {
    func isCompressed(data: Data) -> Bool
    func isNumberFlaggingCompression(number: UInt32) -> Bool
    func decompress(data: Data) throws -> Data
}

public final class GzipDecompressor: Decompressor {
    public init() {}
}


public extension GzipDecompressor {
    
    func isCompressed(data: Data) -> Bool {
        // `isGzipped` is an extension from `Gzip` SPM package imported above.
        return data.isGzipped
    }
    
    func decompress(data: Data) throws -> Data {
        return try data.gunzipped()
    }
    
    
    func isNumberFlaggingCompression(number: UInt32) -> Bool {
        number == Self.gzipped
    }
}

private extension GzipDecompressor {
    
    /// A "well known"/standardized unique header number idenitfying a file as a "gzip" file.
    ///
    /// Source1: https://github.com/vcmi/vcmi/blob/develop/lib/mapping/CMapService.cpp#L105
    /// Source2: https://github.com/brgl/busybox/blob/master/archival/gzip.c#L2081
    /// Source3: https://stackoverflow.com/a/33378248/1311272
    /// Source4: https://zenhax.com/viewtopic.php?p=62470#p62470
    static let gzipped: UInt32 = 0x00088b1f
}
