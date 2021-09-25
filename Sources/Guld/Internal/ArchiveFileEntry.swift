//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-25.
//

import Foundation

public protocol ArchiveFileEntry {
    var parentArchiveName: String { get }
    var fileName: String { get }
    var byteCount: Int { get }
}
