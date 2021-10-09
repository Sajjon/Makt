//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-09.
//

import Foundation
import Util

internal final class GrowingPacker {
    private var rootNode: Node!
}

extension GrowingPacker {
    
    func fit<Content: Packable>(
        packables: [Content],
        sorting: Sorting
    ) throws -> [Packed<Content>] {

        guard !packables.isEmpty else {
            throw Fail(description: "`packables` must not be empty")
        }
        
        let squares: [Content]
        switch sorting {
        case .alreadySorted: squares = packables
        case .byMaxSide:
            squares = packables.sorted(by: \.maxSide, descending: true)
        case .byArea:
            squares = packables.sorted(by: \.area, descending: true)
        }
        
        self.rootNode = Node(
            origin: .zero,
            size: squares[0].size
        )
        
        return squares.map { square in
            let size = square.size
            let positionOnCanvas: CGPoint
            if let node = find(
                node: rootNode,
                size: size
            ) {
                positionOnCanvas = split(node: node, size: size).origin
            } else {
                positionOnCanvas = growRootNode(size: size).origin
            }
            
            return Packed(content: square, positionOnCanvas: positionOnCanvas)
        }
    }
}

private extension GrowingPacker {
   
    func find(
        node: Node?,
        size: CGSize
    ) -> Node? {
        guard let node = node else { return nil }
        if node.isUsed {
            return find(node: node.right, size: size) ?? find(node: node.down, size: size)
        } else if size.width <= node.width && size.height <= node.height {
            return node
        }
        return nil
    }
    
    func split(
        node: Node,
        size: CGSize
    ) -> Node {
        let height = size.height
        let width = size.width
        node.isUsed = true
        node.down = Node(
            origin: .init(
                x: node.x,
                y: node.y + height),
            size: .init(width: node.width,
                        height: node.height - height)
        )
        node.right = Node(
            origin: .init(x: node.x + width, y: node.y),
            size: .init(width: node.width - width,
                        height: node.height)
        )
        return node
    }
    
    func growRootNode(
        size: CGSize
    ) -> Node {
        let width = size.width
        let height = size.height
        
        func growRight() -> Node? {
            
            let newRightNode = Node(
                origin: .init(x: rootNode.width,
                              y: 0),
                size: .init( width: width,
                             height: rootNode.height)
            )
            
            let oldRoot = rootNode
            
            rootNode = Node(
                origin: .init(x: 0,
                              y: 0),
                size: .init(width: rootNode.width + width,
                            height: rootNode.height),
                isUsed: true,
                down: oldRoot,
                right: newRightNode
            )
            
            guard let node = find(node: rootNode, size: size) else {
                return nil
            }
            
            return split(node: node, size: size)
            
        }
        func growDown() -> Node? {
            let newDownNode = Node(
                origin: .init(x: 0,
                              y: rootNode.height),
                size: .init(width: rootNode.width,
                            height: height)
            )
            
            let oldRoot = rootNode
            rootNode = Node(
                origin: .init(x: 0,
                              y: 0),
                size: .init(width: rootNode.width,
                            height: rootNode.height + height),
                isUsed: true,
                down: newDownNode,
                right: oldRoot
            )
            
            guard let node = find(node: rootNode, size: size) else {
                return nil
            }
            
            return split(node: node, size: size)
        }
     
        let canGrowDown = width <= rootNode.width
        let canGrowRight = height <= rootNode.height
        
        // attempt to keep square-ish by growing right when height is much greater than width
        let shouldGrowRight = canGrowRight && rootNode.height >= (rootNode.width + width)
        
        // attempt to keep square-ish by growing down  when width  is much greater than height
        let shouldGrowDown = canGrowDown && rootNode.width >= (rootNode.height + height)
        
        var fit: Node?
        
        if shouldGrowRight {
            fit = growRight()
        } else if shouldGrowDown {
           fit = growDown()
        } else if canGrowRight {
            fit = growRight()
        } else if canGrowDown {
            fit = growDown()
        }
        
        guard let fit = fit else {
            incorrectImplementation(shouldAlwaysBeAbleTo: "Grow the canvas.")
        }
        
        return fit
    }
}

