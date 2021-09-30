//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation

public struct DefinitionFile: ArchiveProtocol, ArchiveFileEntry, Hashable, CustomDebugStringConvertible {
    public let archiveName: String
    
    public let parentArchiveName: String
    
    public let fileName: String
    
    /// Original Definition file data size
    public let byteCount: Int
    
    public let kind: Kind
    
    public let width: Scalar
    public let height: Scalar
    public let palette: Palette
    public let blocks: [Block]
    public var entries: [Frame] { blocks.flatMap({ $0.frames }) }
}

public extension DefinitionFile {
    typealias Scalar = Int
}

public extension DefinitionFile {
    
    var debugDescription: String {
        """
        DEF file
        kind: \(kind)
        width: \(width)
        height: \(height)
        palette: #\(palette.colors)colors
        blocks: \(blocks.map { String(describing: $0) }.joined(separator: "\n"))
        """
    }
    
    enum Kind: UInt32, Hashable, CustomDebugStringConvertible {
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

public extension DefinitionFile.Kind {
    var debugDescription: String {
        switch self {
        case .spell: return "spell"
        case .sprite: return "sprite"
        case .creature: return "creature"
        case .map: return "map"
        case .mapHero: return "mapHero"
        case .terrain: return "terrain"
        case .cursor: return "cursor"
        case .interface: return "interface"
        case .spriteFrame: return "spriteFrame"
        case .battleHero: return "battleHero"
        }
    }
}
