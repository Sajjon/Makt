//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-09.
//

import Foundation

/// Represents the space that a block is placed.
final class Node {
    typealias Scalar = CGFloat

    // Size
    var size: CGSize
    
    let origin: CGPoint
    
    var isUsed: Bool
    var down: Node?
    var right: Node?
    

    init(
        origin: CGPoint,
        size: CGSize,
        
        isUsed: Bool = false,
        down: Node? = nil,
        right: Node? = nil
    ) {
        self.origin = origin
        self.size = size
        
        self.isUsed = isUsed
        self.down = down
        self.right = right
    }
    
    convenience init(
        x: Scalar,
        y: Scalar,
        width: Scalar,
        height: Scalar,
        
        isUsed: Bool = false,
        down: Node? = nil,
        right: Node? = nil
    ) {
        self.init(
            origin: .init(x: x, y: y),
            size: .init(width: width, height: height),
            isUsed: isUsed,
            down: down,
            right: right
        )
    }
}

extension Node {
    var x: Scalar { origin.x }
    var y: Scalar { origin.y }
    var width: Scalar { size.width }
    var height: Scalar { size.height }
}
