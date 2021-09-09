//
//  CRC32Tests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation
import XCTest
@testable import Makt

final class CRC32Tests: XCTestCase {
    func test_crc32_vectors() {
        func doTest(message: String, expectedChecksum: UInt32) {
            let actual = CRC32.checksum(message.data(using: .utf8)!)
            XCTAssertEqual(actual, expectedChecksum)
        }
        
        doTest(message: "", expectedChecksum: 0x00000000)

        // Source: https://rosettacode.org/wiki/CRC-32
        doTest(message: "The quick brown fox jumps over the lazy dog", expectedChecksum: 0x414FA339)

        // Source: http://cryptomanager.com/tv.html
        doTest(message: "various CRC algorithms input data", expectedChecksum: 0x9BD366AE)
        
        // Source: http://www.febooti.com/products/filetweak/members/hash-and-crc/test-vectors/
        doTest(message: "Test vector from febooti.com", expectedChecksum: 0x0C877F61)
    }
}
