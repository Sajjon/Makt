//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-25.
//

import Foundation

internal final class AssetParsedInspector {
    
    private let onParseFileEntry: OnParseFileEntry
    
    internal init(
        onParseFileEntry: @escaping OnParseFileEntry
    ) {
        self.onParseFileEntry = onParseFileEntry
    }
    
}

internal extension AssetParsedInspector {
    typealias OnParseFileEntry = (ArchiveFileEntry) -> Void
    
    func didParseFileEntry(_ fileEntry: ArchiveFileEntry) -> Void {
        onParseFileEntry(fileEntry)
    }
    
}
