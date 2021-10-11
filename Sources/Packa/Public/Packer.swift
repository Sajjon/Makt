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

// MARK: Pack
public extension Packer {
    
    /// "Packs" an array of 2D boxes with content onto a square-ish canvas with
    /// an as small as possible area, by use of binary tree packing algorithm.
    func pack<Content: Packable>(
        packables: [Content],
        sorting: Sorting,
        done: @escaping (Result<PackedCanvas<Content>, Error>) -> Void
    ) {
        DispatchQueue.global(qos: .background).async { [sync] in
            do {
                
                let packed = try sync.pack(
                    packables: packables,
                    sorting: sorting
                )
                
                DispatchQueue.main.sync {
                    done(.success(packed))
                }
            } catch {
                DispatchQueue.main.sync {
                    done(.failure(error))
                }
            }
        }
    }
    
}

// MARK: Sync
public extension Packer {
    var sync: SyncPacker { .init() }
}

public struct SyncPacker {
    fileprivate init() {}
}

private extension Packed {
    var rightMostPixel: CGFloat { x + width }
    var bottomMostPixel: CGFloat { y + height }
}

public extension SyncPacker {
    
    /// "Packs" an array of 2D boxes with content onto a square-ish canvas with
    /// an as small as possible area, by use of binary tree packing algorithm.
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
