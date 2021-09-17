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

public enum LoadedAsset: Hashable, NamedAssetFile {
    case archive(LodFile)
    
    public var fileName: String {
        switch self {
        case .archive(let lodFile):
            return lodFile.lodFileName
        }
    }
}

public final class ArchiveLoader {
    public init() {}
}

public extension ArchiveLoader {
    typealias Error = LodParser.Error
    func loadArchive(assetFile: AssetFile) -> AnyPublisher<LoadedAsset, Error> {
        let lodParser = LodParser()
        return Future { promise in
            DispatchQueue(label: "LodParser", qos: .background).async {
                do {
                    let lodFile = try lodParser.parse(assetFile: assetFile)
                    let loadedAsset: LoadedAsset = .archive(lodFile)
                    promise(Result.success(loadedAsset))
                } catch let error as Error {
                    promise(Result.failure(error))
                } catch { uncaught(error: error, expectedType: Error.self) }
            }
        }.eraseToAnyPublisher()
    }
}
