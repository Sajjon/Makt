//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-09.
//

import Foundation

public struct Packer {
    public init() {}
}

public enum Sorting {
    case alreadySorted
    case byArea
    case byMaxSide
}

public extension Packer {
    
    var sync: SyncPacker { .init() }
    
    func pack<Content: Packable>(
        packables: [Content],
        sorting: Sorting,
        done: @escaping (Result<FittedItems<Content>, Error>) -> Void
    ) {
        DispatchQueue.global(qos: .background).async { [sync] in
            do {
                let success = try sync.pack(packables: packables, sorting: sorting)
                DispatchQueue.main.sync {
                    done(Result.success(success))
                }
            } catch {
                DispatchQueue.main.sync {
                    done(Result.failure(error))
                }
            }
        }
    }
    
}

public struct SyncPacker {
    fileprivate init() {}
}

public extension SyncPacker {
    func pack<Content: Packable>(
        packables: [Content],
        sorting: Sorting
    ) throws -> FittedItems<Content> {
        
        let packer = GrowingPacker()
        let fittedItems = try packer.fit(packables: packables, sorting: sorting)
        
        let canvasWidth = fittedItems.reduce(0) { curr, item in
            max(curr, item.x + item.width)
        }
        let canvasHeight = fittedItems.reduce(0) { curr, item in
            max(curr, item.y + item.height)
        }
        
        return .init(
            packed: fittedItems,
            canvasSize: .init(
                width: canvasWidth,
                height: canvasHeight
            )
        )
    }
}
