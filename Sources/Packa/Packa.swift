//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-08.
//

import Foundation
import Util

public func syncPack<Content: Packable>(packables: [Content]) throws -> FittedItems<Content> {

    let packer = GrowingPacker()
    let fittedItems = try packer.fit(packables: packables)
    
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

