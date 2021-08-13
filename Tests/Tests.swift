//
//  Tests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-13.
//

import XCTest
import HoMM3SwiftUI

final class Tests: XCTestCase {

    func testInitConfigWithoutArguments() throws {
        XCTAssertNoThrow(try Config())
    }

}
