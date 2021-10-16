//
//  Data+Hex.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation

public extension Data {
    struct HexEncodingOptions: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        public static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}


public extension Data {
    init(hex: String) throws {
        guard hex.count.isMultiple(of: 2) else {
            throw Fail(description: "Expected hexadecimal string to have an even number of characters.")
        }
        
        let chars = hex.map { $0 }
        let bytes: [UInt8] = try stride(from: 0, to: chars.count, by: 2)
            .map { String(chars[$0]) + String(chars[$0 + 1]) }
            .map { char -> UInt8 in
                guard let byte = UInt8(char, radix: 16) else {
                    throw Fail(description: "Faild to decode char to byte - char: '\(char)'")
                }
                return byte
            }
     
        self.init(bytes)
    }
}

