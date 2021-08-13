//
//  Config+OriginalResourceDirectory+Maps.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

public extension OriginalResourceDirectories {

    enum Maps: OriginalResourceDirectoryKind {
        public enum Content: String, FileNameConvertible, Equatable, Hashable, CaseIterable {
            case tutorial = "Tutorial.tut"
            case titansWinter = "Titans Winter.h3m"
        }
      
    }
}

public extension OriginalResourceDirectoryKind where Content: CaseIterable, Content.AllCases == [Content] {
    static var requiredDirectoryContents: [Content] { Content.allCases }
}
