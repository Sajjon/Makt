//
//  File 2.swift
//  File 2
//
//  Created by Alexander Cyon on 2021-09-15.
//

import Foundation
import Util

public final class DefParser {
    internal let reader: DataReader
    public init(data: Data) {
        self.reader = DataReader(data: data)
    }
}

public enum DefKind: UInt32, Hashable {
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

public extension DefParser {
    func parse() throws -> DefinitionFile {
        let kind = try DefKind.init(integer: reader.readUInt32())
        let width = try reader.readUInt32()
        let height = try reader.readUInt32()
        let blockCount = try reader.readUInt32()
        let palette: [RGB] = try 256.nTimes {
            try .init(
                red: reader.readUInt8(),
                green: reader.readUInt8(),
                blue: reader.readUInt8()
            )
        }
        let blocks = try blockCount.nTimes {
            try parseBlock()
        }
        fatalError()
    }
    
    
}
private extension DefParser {
    enum Error: Swift.Error, Equatable {
        case offsetLeftLargerThanWidth
        case offsetTopLargerThanHeight
    }
}

private extension DefParser {
    
    
    
    func parseBlock() throws -> Block {
        let blockIdentifier = try reader.readUInt32()
        
        /// number of images in this block
        let entriesCount = try reader.readUInt32()
        
        let _ = try reader.readUInt32() // unknown 1
        let _ = try reader.readUInt32() // unknown 2
        
        let fileNames: [String] = try entriesCount.nTimes {
            let data = try reader.read(byteCount: 13)
            let string = String(bytes: data, encoding: .utf8) ?? String(bytes: data, encoding: .ascii)!
            return string.trimmingCharacters(in: .whitespaces)
        }
        
        let fileOffsets = try entriesCount.nTimes {
            try reader.readUInt32()
        }
        
        let pointers = try (0..<entriesCount).map { index in
            let size = try reader.readUInt32()
            let encodingFormat = try reader.readUInt32()
            let fullWidth = try reader.readUInt32()
            let fullHeight = try reader.readUInt32()
            let width = try reader.readUInt32()
            let height = try reader.readUInt32()
            let offsetLeft = try reader.readInt32()
            let offsetTop = try reader.readInt32()
            
            // Comment from `jocsch/lodextract`:
            // `SGTWMTA.def` and `SGTWMTB.def` fail here
            // they have inconsistent left and top margins
            // they seem to be unused
            guard offsetTop <= fullHeight else {
                throw Error.offsetTopLargerThanHeight
            }
            
            guard offsetLeft <= fullWidth else {
                throw Error.offsetLeftLargerThanWidth
            }
                
                
            let pixelData: Data
            switch encodingFormat {
            case 0:
                pixelData = try reader.read(byteCount: .init(width * height))
            default: incorrectImplementation(reason: "Unhandled encoding format: \(encodingFormat). This should NEVER happen. Probably some wrong byte offset.")
            }
            
        }
        
        fatalError()
    }
}
