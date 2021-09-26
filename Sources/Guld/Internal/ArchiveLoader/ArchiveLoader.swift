//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation
import Malm
import Util
import Combine

internal final class ArchiveLoader {
    
    private let dispatchQueue: DispatchQueue = .init(label: "LoadArchive", qos: .background)
    
    internal init() {
    }
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
    ) -> AnyPublisher<LoadedArchive, Error> {
        
        
        return Future { [unowned self] promise in
            dispatchQueue.async {
                do {
                    print("✨ ArchiveLoader loading archive file: \(archiveFile.fileName)")
                    switch archiveFile.kind {
                    case .sound:
                        let sndArchiveParser = SNDArchiveParser()
                        let sndFile = try sndArchiveParser.parse(archiveFile: archiveFile, inspector: inspector)
                        let loadedAsset: LoadedArchive = .sound(sndFile)
                        promise(Result.success(loadedAsset))
                    case .lod:
                        let lodParser = LodParser()
                        let lodFile = try lodParser.parse(archiveFile: archiveFile, inspector: inspector)
                        let loadedAsset: LoadedArchive = .archive(lodFile)
                        promise(Result.success(loadedAsset))
                    case .video:
                        let vidParser = VIDArchiveParser()
                        let vidArchiveFile = try vidParser.parse(archiveFile: archiveFile, inspector: inspector)
                        let loadedAsset: LoadedArchive = .video(vidArchiveFile)
                        promise(Result.success(loadedAsset))
                    }
                } catch let error as Error {
                    promise(Result.failure(error))
                } catch { uncaught(error: error, expectedType: Error.self) }
            }
        }
        .share()
        .eraseToAnyPublisher()
    }
}
