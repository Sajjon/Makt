//
//  DataReader.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public final class DataReader {
    private let source: Data
    public let sourceSize: Int
    public private(set) var offset: Int = 0
    public init(data: Data) {
        source = data
        sourceSize = data.count
    }
}

public extension DataReader {
 
    
    convenience init(readMap: Map.Loader.ReadMap) {
        self.init(data: readMap.data)
    }
    
}


internal extension DataReader {

    func readUInt<U>(byteCount: Int, endianess: Endianess = .little) throws -> U where U: FixedWidthInteger & UnsignedInteger {
        let bytes = try read(byteCount: byteCount)
        
        switch endianess {
        case .little:
            return bytes.withUnsafeBytes {
                $0.load(as: U.self)
            }
        case .big:
            var endianessSwappedBytes = bytes
            endianessSwappedBytes.reverse()
            return endianessSwappedBytes.withUnsafeBytes {
                $0.load(as: U.self)
            }
        }
    }
    
    func readInt<I>(byteCount: Int, endianess: Endianess = .little) throws -> I where I: FixedWidthInteger & SignedInteger {
        let bytes = try read(byteCount: byteCount)

        let littleEndianInt = bytes.withUnsafeBytes {
            $0.load(as: I.self)
        }
        
        switch endianess {
        case .little:
            return littleEndianInt
        case .big:
            fatalError("what to do?")
        }
    }
}



public enum Endianess {
    case big, little
    
}

public extension DataReader {
    
    enum Error: Swift.Error {
        case outOfBounds
    }
    
    func readUInt8(endianess: Endianess = .little) throws -> UInt8 {
        try readUInt(byteCount: 1, endianess: endianess)
    }
    
    
    func readInt8(endianess: Endianess = .little) throws -> Int8 {
        try readInt(byteCount: 1, endianess: endianess)
    }
    
    func readUInt16(endianess: Endianess = .little) throws -> UInt16 {
        try readUInt(byteCount: 2, endianess: endianess)
    }
    
    func readInt16(endianess: Endianess = .little) throws -> Int16 {
        try readInt(byteCount: 2, endianess: endianess)
    }
    
    func readUInt32(endianess: Endianess = .little) throws -> UInt32 {
        try readUInt(byteCount: 4, endianess: endianess)
    }
    
    func readInt32(endianess: Endianess = .little) throws -> Int32 {
        try readInt(byteCount: 4, endianess: endianess)
    }
    
    
    func read(byteCount: Int) throws -> Data {
        guard source.count >= byteCount else {
            throw Error.outOfBounds
        }
        let startIndex = Data.Index(offset)
        let endIndex = startIndex.advanced(by: byteCount)
        assert(endIndex <= source.count, "'source.count': \(source.count), but 'endIndex': \(endIndex)")
        self.offset += byteCount
        return Data(source[startIndex..<endIndex])
    }
    
    func readInt(endianess: Endianess = .little) throws -> Int {
        try readInt(byteCount: MemoryLayout<Int>.size, endianess: endianess)
    }
    
    func readFloat() throws -> Float {
        var floatBytes = try read(byteCount: 4)
        let float: Float = floatBytes.withUnsafeMutableBytes {
            $0.load(as: Float.self)
        }
        return float
    }
    
    func seek(to targetOffset: Int) throws {
        guard targetOffset < source.count else {
            throw Error.outOfBounds
        }

        self.offset = targetOffset
    }
    
    func skip(byteCount: Int) throws {
        // Discard data
        let _ = try read(byteCount: byteCount)
    }
    
    
    func readString() throws -> String {
        let length = Int(try readUInt32())
        assert(length <= 500_000, "This string is unresonably long. Probably some offset error...")
        guard length > 0 else {
            return ""
        }
        let data = try read(byteCount: length)
        return String(bytes: data, encoding: .utf8)!
    }
    
    func readBool() throws -> Bool {
        try readUInt8() != 0
    }

    func readPosition() throws -> Position {
        try .init(
            x: .init(readUInt8()),
            y: .init(readUInt8()),
            z: .init(readUInt8())
        )
    }
}

