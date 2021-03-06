//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation

enum ExportTarget {
    case allFilesMatchingAnyOfExtensions(`in`: [String])
    static func allFilesMatching(`extension`: String) -> Self {
        return .allFilesMatchingAnyOfExtensions(in: [`extension`])
    }
    case specificFileList([String])
}
