//
//  ResourceAccessor+File.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

public extension ResourceAccessor {
    
    struct File<Kind>: Equatable, Hashable where Kind: ResourceKind {
        public let fileHandle: FileHandle
        public let content: Kind.Content
    }
    
}

public extension ResourceAccessor.File {
    var fileName: String { content.fileName }
    var data: Data { fileHandle.availableData }
    var fileSize: Int { data.count }
}
