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

public protocol ArchiveProtocol {
    
    associatedtype FileEntry: ArchiveFileEntry

    /// Name of archive
    ///
    /// This is the file name of archive including file extension and with
    /// original upper/lowercase values intact.
    ///
    var archiveName: String { get }
    
    /// Entries found in this archive.
    var entries: [FileEntry] { get }
}
