//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-09.
//

import Foundation

/// End result of packing packable items.
public struct Packed<Content: Packable> {
    public let content: Content
    public let positionOnCanvas: CGPoint
}

extension Packed {
    var x: CGFloat { positionOnCanvas.x }
    var y: CGFloat { positionOnCanvas.y }
    var width: CGFloat { content.width }
    var height: CGFloat { content.height }
}
