//
//  ResourceAccessor+OriginalResourceDirectory+Music.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-13.
//

import Foundation

public extension OriginalResourceDirectories {

    enum Music: OriginalResourceDirectoryKind {
        public enum Content: String, FileNameConvertible, Equatable, Hashable, CaseIterable {
            case towerTown = "TowerTown.ogg"
        }
        
        /// The name of the music folder should be "Mp3", and not "music", even though
        /// it might contain OGG files instead of MP3 files.
        public static var name: String { "Mp3" }
        
     
    }
}
