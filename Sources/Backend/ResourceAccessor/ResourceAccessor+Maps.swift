//
//  ResourceAccessor+Directory+Maps.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

public extension ResourceAccessor {
    enum Maps: ResourceKind {}
}

public extension ResourceAccessor.Maps {
    enum Content: String, FileNameConvertible, Equatable, Hashable, CaseIterable {
        case tutorial = "Tutorial.tut"
        case titansWinter = "Titans Winter.h3m"
    }
}

