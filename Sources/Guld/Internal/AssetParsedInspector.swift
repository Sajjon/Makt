//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-25.
//

import Foundation

public final class AssetParsedInspector {
    public typealias OnParseFileEntry = (ArchiveFileEntry) -> Void
    private let onParseFileEntry: OnParseFileEntry
    
    public init(
        onParseFileEntry: @escaping OnParseFileEntry
    ) {
        self.onParseFileEntry = onParseFileEntry
    }
    
}

internal extension AssetParsedInspector {
    
    
    func didParseFileEntry(_ fileEntry: ArchiveFileEntry) -> Void {
        onParseFileEntry(fileEntry)
    }
    
}
