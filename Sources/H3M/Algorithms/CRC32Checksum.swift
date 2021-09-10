//
//  crc32.swift
//  SuperSFV
//
//  Created by C.W. Betts on 8/23/15.
//
//

// originally created: https://gist.github.com/MaddTheSane/b43d467ad4c5c2e305b5

import Foundation
import Malm

/// Swift 5 improvement credits https://gist.github.com/antfarm/695fa78e0730b67eb094c77d53942216
internal enum CRC32 {
        
    static var table: [UInt32] = {
        (0...255).map { i -> UInt32 in
            (0..<8).reduce(UInt32(i), { c, _ in
                (c % 2 == 0) ? (c >> 1) : (0xEDB88320 ^ (c >> 1))
            })
        }
    }()

    static func checksum<S>(_ bytes: S) -> UInt32 where S: Sequence, S.Element == UInt8 {
        return ~(bytes.reduce(~UInt32(0), { crc, byte in
            (crc >> 8) ^ table[(Int(crc) ^ Int(byte)) & 0xFF]
        }))
    }
}
