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
            var endianessSwappedBytes = bytes
            endianessSwappedBytes.reverse()
            return endianessSwappedBytes.withUnsafeBytes {
                $0.load(as: I.self)
            }
        }
    }
}



public enum Endianess {
    case big, little
    
}

public extension DataReader {
    
    enum Error: Swift.Error {
        case dataReaderHasNoMoreBytesToBeRead
        case dataEmpty
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
            throw Error.dataReaderHasNoMoreBytesToBeRead
        }
        let startIndex = Data.Index(offset)
        let endIndex = startIndex.advanced(by: byteCount)
        assert(endIndex <= source.count, "'source.count': \(source.count), but 'endIndex': \(endIndex)")
        self.offset += byteCount
        return Data(source[startIndex..<endIndex])
    }
    
    func readRest(throwIfEmpty: Bool = true) throws -> Data {
        let remainingByteCount = source.count - offset
        guard remainingByteCount > 0 else { throw Error.dataEmpty }
        return try read(byteCount: remainingByteCount)
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
            throw Error.dataReaderHasNoMoreBytesToBeRead
        }

        self.offset = targetOffset
    }
    
    func skip(byteCount: Int) throws {
        // Discard data
        let _ = try read(byteCount: byteCount)
    }
    
    
    func readString() throws -> String {
       try _readString(maxByteCount: 50_000)!
    }
    
    func readString(maxByteCount: UInt32) throws -> String? {
        try _readString(maxByteCount: maxByteCount)
    }
    
    private func _readString(maxByteCount: UInt32? = nil) throws -> String? {
        let lengthU32 = try readUInt32()
        if let max = maxByteCount, lengthU32 > max {
            print("String too long. Max was \(max), but this will be \(lengthU32) => returning nil")
            return nil
        }
        assert(lengthU32 <= 500_000, "This string is unresonably long, lenght: \(lengthU32) bytes. Probably some offset error...")
        guard lengthU32 > 0 else {
            return nil
        }
        let data = try read(byteCount: .init(lengthU32))
        if let string = String(bytes: data, encoding: .utf8) {
            return string
        } else {
            return String(bytes: data, encoding: .ascii)!
        }
    }
    
    func readBool() throws -> Bool {
        try readUInt8() != 0
    }
}

