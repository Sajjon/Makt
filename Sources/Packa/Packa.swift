//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-08.
//

import Foundation
import Util

public protocol Packable: Identifiable {
    var width: CGFloat { get }
    var height: CGFloat { get }
}

extension Packable {
    
    var size: CGSize { .init(width: width, height: height) }
    
    var area: CGFloat {
        width * height
    }
}

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

//internal protocol Boxing: Packable {
//    associatedtype Content: Packable
//    var content: Content { get }
//}

public enum Error: Swift.Error {
    case overflow
}

public struct Fail: Swift.Error, Hashable, CustomStringConvertible {
    public let description: String
}

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
}

extension Node {
    var x: Scalar { origin.x }
    var y: Scalar { origin.y }
    var width: Scalar { size.width }
    var height: Scalar { size.height }
}

internal final class GrowingPacker {
    private var rootNode: Node!
}

extension GrowingPacker {
    
    /// Sorts `packables` by `area`.
    func fit<Content: Packable>(packables nonSorted: [Content]) throws -> [Packed<Content>] {
        
        guard !nonSorted.isEmpty else { throw Fail(description: "Items must not be empty") }
        let squares = nonSorted.sorted(by: \.area)
        self.rootNode = Node(origin: .zero, size: squares[0].size)
        
        return squares.enumerated().map { squareIndex, square in
            let size = square.size
            let positionOnCanvas: CGPoint
            if let someNode = find(
                node: rootNode,
                size: size
            ) {
                positionOnCanvas = split(node: someNode, size: size).origin
            } else {
                guard let fit = growRootNode(size: size) else {
                    fatalError("Failed to grodNode, squareIndex: \(squareIndex), square: \(square), rootNode: \(rootNode!)")
                }
                positionOnCanvas = fit.origin
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
//            if let rightNode = node.right {
//                return find(node: rightNode, size: size)
//            } else if let downNode = node.down {
//                return find(node: downNode, size: size)
//            } else {
//                return nil
//            }
            return find(node: node.right, size: size) ?? find(node: node.down, size: size)
        } else if size.width <= node.width && size.height <= node.height {
            assert(node.isUsed == false)
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
    ) -> Node? {
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
                //                throw Fail(description: "Failed to grow right")
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
//                throw Fail(description: "Failed to grow down")
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
        
        if shouldGrowRight {
            return growRight()
        } else if shouldGrowDown {
           return growDown()
        } else if canGrowRight {
            return growRight()
        } else if canGrowDown {
            return growDown()
        } else {
            // need to ensure sensible root starting size to avoid this happening
//            throw Fail(description: "Failed to grow canvas, cannot fit more items.")
            fatalError("failed to grow canvas")
        }
    }
}


public struct FittedItems<Content: Packable> {
    public let packed: [Packed<Content>]
    public let canvasSize: CGSize
}

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

