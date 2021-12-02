//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-25.
//

import Foundation

public final class AssetParsedInspector {
    public typealias OnParseFileEntry = (ArchiveFileEntry) -> Void
    public typealias OnParsePCXImage = (PCXImage) -> Void
    private let onParseFileEntry: OnParseFileEntry?
    private let onParsePCXImage: OnParsePCXImage?
    
    public init(
        onParseFileEntry: OnParseFileEntry? = nil,
        onParsePCXImage: OnParsePCXImage? = nil
    ) {
        self.onParseFileEntry = onParseFileEntry
        self.onParsePCXImage = onParsePCXImage
    }
    
}

internal extension AssetParsedInspector {
    
    
    func didParseFileEntry(_ fileEntry: ArchiveFileEntry) {
        onParseFileEntry?(fileEntry)
    }
    
    func didParsePCXImage(_ pcx: PCXImage) {
        onParsePCXImage?(pcx)
    }
}
