//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation

enum ExportTarget {
    case anyFileWithExtension(String)
    case specificFileList([String])
}
