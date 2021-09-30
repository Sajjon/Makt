//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-22.
//

import Foundation

public enum LoadedArchive {
    case archive(LodFile)
    case sound(SNDFile)
    case video(VIDFile)
}

public extension LoadedArchive {
    
    var lodArchive: LodFile? {
        switch self {
        case .archive(let lodFile): return lodFile
        case .sound, .video: return nil 
        }
    }
    
    var fileName: String {
        switch self {
        case .archive(let lodFile):
            return lodFile.archiveName
        case .sound(let sndFile):
            return sndFile.archiveName
        case .video(let vidFie):
            return vidFie.archiveName
        }
    }
    
    var enries: [ArchiveFileEntry] {
        switch self {
        case .archive(let lodFile):
            return lodFile.entries
        case .sound(let sndFile):
            return sndFile.entries
        case .video(let vidFie):
            return vidFie.entries
        }
}
}
