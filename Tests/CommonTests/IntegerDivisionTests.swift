//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation
import XCTest
import Common

final class IntegerDivisionTests: XCTestCase {
    
    func testIntegerDivisionStandard() {
        doTest(actual: 1/2, expected: 0)
        doTest(actual: 1/3, expected: 0)
        doTest(actual: 2/3, expected: 0)
    }
    
    func testIntegerDivisionRoundDown() {
        doTest(actual: 1.divide(by: 2, rounding: .down), expected: 0)
        doTest(actual: 1.divide(by: 3, rounding: .down), expected: 0)
        doTest(actual: 2.divide(by: 3, rounding: .down), expected: 0)
     
    }
    
    func testIntegerDivisionRoundUp() {
        doTest(actual: 1.divide(by: 2, rounding: .up), expected: 1)
        doTest(actual: 1.divide(by: 3, rounding: .up), expected: 1)
        doTest(actual: 2.divide(by: 3, rounding: .up), expected: 1)
    }
}

private extension IntegerDivisionTests {
    func doTest(actual: Int, expected: Int, line: UInt = #line) {
        XCTAssertEqual(actual, expected, line: line)
    }
}
