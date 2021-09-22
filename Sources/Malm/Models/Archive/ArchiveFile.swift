//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-22.
//

import Foundation

public struct ArchiveFile: Equatable {
    public let kind: Archive
    public let data: Data
    public init(
        kind: Archive,
        data: Data
    ) {
        self.kind = kind
        self.data = data
    }
}
public extension ArchiveFile {
    var fileName: String { kind.fileName }
    var kindName: String { kind.kindName }
}
