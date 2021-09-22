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

public final class ArchiveLoader {
    public init() {}
}

public extension ArchiveLoader {
    
    typealias Error = LodParser.Error
    
    func load(archiveFile: ArchiveFile) -> AnyPublisher<LoadedArchive, Error> {
        return Future { promise in
            DispatchQueue(label: "LoadArchive", qos: .background).async {
                do {
                    switch archiveFile.kind {
                    case .sound:
                        let sndArchiveParser = SNDArchiveParser()
                        let sndFile = try sndArchiveParser.parse(assetFile: archiveFile)
                        let loadedAsset: LoadedArchive = .sound(sndFile)
                        promise(Result.success(loadedAsset))
                    case .lod:
                        let lodParser = LodParser()
                        let lodFile = try lodParser.parse(assetFile: archiveFile)
                        let loadedAsset: LoadedArchive = .archive(lodFile)
                        promise(Result.success(loadedAsset))
                    case .video:
                        let vidParser = VIDArchiveParser()
                        let vidArchiveFile = try vidParser.parse(assetFile: archiveFile)
                        let loadedAsset: LoadedArchive = .video(vidArchiveFile)
                        promise(Result.success(loadedAsset))
                    }
                } catch let error as Error {
                    promise(Result.failure(error))
                } catch { uncaught(error: error, expectedType: Error.self) }
            }
        }.eraseToAnyPublisher()
    }
}
