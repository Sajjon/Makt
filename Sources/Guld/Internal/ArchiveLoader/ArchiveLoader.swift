//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation
import Malm
import Util

internal final class ArchiveLoader {
    
    internal init() {}
}

internal extension ArchiveLoader {
    
    typealias Error = LodParser.Error
    
    
    func peekFileEntryCount(of archiveFile: ArchiveFile) throws -> Int {
        let archiveParser: ArchiveFileCountParser = {
            switch archiveFile.kind {
            case .sound:
                return SNDArchiveParser()
            case .lod:
                return LodParser()
            case .video:
                return VIDArchiveParser()
            }
        }()
        
        return try archiveParser.peekFileEntryCount(of: archiveFile)
    }
    
    func load(
        archiveFile: ArchiveFile,
        inspector: AssetParsedInspector? = nil
    ) throws -> LoadedArchive {
        
        print("✨ ArchiveLoader loading archive file: \(archiveFile.fileName)")
        switch archiveFile.kind {
        case .sound:
            let sndArchiveParser = SNDArchiveParser()
            let sndFile = try sndArchiveParser.parse(archiveFile: archiveFile, inspector: inspector)
            let loadedAsset: LoadedArchive = .sound(sndFile)
            return loadedAsset
        case .lod:
            let lodParser = LodParser()
            let lodFile = try lodParser.parse(archiveFile: archiveFile, inspector: inspector)
            let loadedAsset: LoadedArchive = .archive(lodFile)
            return loadedAsset
        case .video:
            let vidParser = VIDArchiveParser()
            let vidArchiveFile = try vidParser.parse(archiveFile: archiveFile, inspector: inspector)
            let loadedAsset: LoadedArchive = .video(vidArchiveFile)
            return loadedAsset
        }
        
    }
}
