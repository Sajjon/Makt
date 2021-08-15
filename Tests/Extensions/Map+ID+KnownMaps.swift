//
//  Map+ID+KnownMaps.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-15.
//

import HoMM3SwiftUI

extension Map.ID {
    
    static func h3m(_ name: String) -> Self {
        .init(fileName: name.appending("." + Self.fileExtension))
    }
    
    static let tutorial: Self = "Tutorial.tut"
    static let titansWinter: Self = .h3m("Titans Winter")
}
