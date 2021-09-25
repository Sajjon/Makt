//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-22.
//

import Foundation

public enum LoadedArchive: Hashable {
    case archive(LodFile)
    case sound(SNDFile)
    case video(VIDFile)
}

public extension LoadedArchive {
    var fileName: String {
        switch self {
        case .archive(let lodFile):
            return lodFile.lodFileName
        case .sound(let sndFile):
            return sndFile.sndArchiveFileName
        case .video(let vidFie):
            return vidFie.videoArchiveFileName
        }
    }
    
    var numberOfEntries: Int {
        switch self {
        case .archive(let lodFile):
            return lodFile.entries.count
        case .sound(let sndFile):
            return sndFile.fileEntries.count
        case .video(let vidFie):
            return vidFie.fileEntries.count
        }
}
}
