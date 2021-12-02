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


public extension String {
    func trimWhitespacesIncludingNullTerminators() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: .null)))
    }
    static var null: String { String(.null) }
}

public extension Character {
    static var null: Self { Character.init(.init(0x00)) }
}


public extension DataReader {
    
    enum Error: Swift.Error {
        case dataReaderHasNoMoreBytesToBeRead
        case dataEmpty
        case failedToDecodeStringAsUTF8(asASCII: String?)
        case failedToDecodeStringAsEvenASCII
        case stringLongerThanExpectedMaxLength(got: Int, butExpectedAtMost: Int)
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
    
    func readLengthOfStringAndString(
        assertingMaxLength: UInt32 = 100_000,
        trim: Bool = true
    ) throws -> String? {
        
        let length = try readUInt32()
        
        guard length <= assertingMaxLength else {
            
            throw Error.stringLongerThanExpectedMaxLength(
                got: .init(length),
                butExpectedAtMost: .init(assertingMaxLength)
            )
        }
        return try readStringOfKnownMaxLength(length, trim: trim)
    }
    
    func readStringOfKnownMaxLength(_ maxLength: UInt32, trim: Bool = true) throws -> String? {
        guard maxLength > 0 else { return nil }
        let data = try read(byteCount: .init(maxLength))
        
        
        if trim {
            let trimmedData = data.prefix(while: { $0 != 0x00 })
            
            guard let string = String(bytes: trimmedData, encoding: .utf8) else {
                throw Error.failedToDecodeStringAsUTF8(asASCII: .init(bytes: data, encoding: .ascii))
            }
            let trimmedString = string.trimWhitespacesIncludingNullTerminators()
            return trimmedString
        } else {
            guard let string = String(bytes: data, encoding: .utf8) ?? String(bytes: data, encoding: .nonLossyASCII) ?? String(bytes: data, encoding: .ascii) else {
                throw Error.failedToDecodeStringAsEvenASCII
            }
            return string
        }

    }
    
 
    func readBool() throws -> Bool {
        try readUInt8() != 0
    }
}

