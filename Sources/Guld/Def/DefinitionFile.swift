//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public struct DefinitionFile: Hashable {
    
    public let kind: Kind
    
    public let width: Scalar
    public let height: Scalar
    public let palette: [RGB]
    public let blocks: [Block]
}

public extension DefinitionFile {
    typealias Scalar = Int
}

public extension DefinitionFile {
    
    enum Kind: UInt32, Hashable {
        case spell = 0x40
        case sprite
        case creature
        case map
        case mapHero
        case terrain
        case cursor
        case interface
        case spriteFrame
        case battleHero
    }
}
