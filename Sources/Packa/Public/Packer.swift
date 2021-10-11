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
        done: @escaping (Result<PackedCanvas<Content>, Error>) -> Void
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

private extension Packed {
    var rightMostPixel: CGFloat { x + width }
    var bottomMostPixel: CGFloat { y + height }
}

public extension SyncPacker {
    func pack<Content: Packable>(
        packables: [Content],
        sorting: Sorting
    ) throws -> PackedCanvas<Content> {
        
        let growingPacker = GrowingPacker()
        
        let packedItems = try growingPacker.pack(
            packables: packables,
            sorting: sorting
        )
        
        let canvasWidth = packedItems.map({ $0.rightMostPixel }).max()!
        let canvasHeight = packedItems.map({ $0.bottomMostPixel }).max()!
        
        // Sorting here does not affect the result of the growing packer above
        // But it makes sense to have the packed items sorted according to
        // their position relative to origin (0, 0).
        let sorted = packedItems
            .sorted(by: \.positionOnCanvas.x)
            .sorted(by: \.positionOnCanvas.y)
        
        return .init(
            packed: sorted,
            canvasSize: .init(
                width: canvasWidth,
                height: canvasHeight
            )
        )
    }
}
