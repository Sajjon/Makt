//
//  Config+OriginalResourceDirectory+Music.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

public extension OriginalResourceDirectories {

    enum Music: OriginalResourceDirectoryKind {
        
        /// The name of the music folder should be "Mp3", and not "music", even though
        /// it might contain OGG files instead of MP3 files.
        public static var name: String { "Mp3" }
        
        public static let requiredDirectoryContents = [
            "TowerTown.ogg"
        ]
    }
}
