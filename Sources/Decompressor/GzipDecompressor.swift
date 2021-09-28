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
}
