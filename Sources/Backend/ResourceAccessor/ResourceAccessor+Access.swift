//
//  ResourceAccessor+Access.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

/// Public access file handlers
public extension ResourceAccessor.Directory {
    func handleFor(file fileId: Kind.Content) -> ResourceAccessor.File<Kind> {
        guard let file = files[fileId] else {
            fatalError("Expected to find file named: \(fileId.fileName)")
        }
        return file
    }
}

public extension ResourceAccessor {
    func map(named fileId: Maps.Content) -> File<Maps> {
        mapsDirectory.handleFor(file: fileId)
    }
}

