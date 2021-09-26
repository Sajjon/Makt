//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-14.
//

import XCTest
import Foundation
import Malm
@testable import H3M

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/scholar.h3m

/// MIT License
///
/// Copyright (c) 2018 Sergey Kostyrko
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/scholar.h3m

final class ScholarOnMapTests: BaseMapTest {
    
    func testScholar() throws {
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, "") },
                onParseDescription: { XCTAssertEqual($0, "") },
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .small) },
                onFinishedParsingBasicInfo: { XCTAssertFalse($0.hasTwoLevels) }
            ),
            onParseObject: { [unowned self] object in
                
                func assertScholar(
                    expected: Map.Scholar,
                    line: UInt = #line
                ) {
                    assertObjectScholar(expected: expected, actual: object)
                }
                
                switch object.position {
                case at(1, y: 1):
                    assertScholar(expected: .init(bonus: .random))
                case at(3, y: 1):
                    assertScholar(expected: .init(bonus: .primarySkill(.power)))
                case at(5, y: 1):
                    assertScholar(expected: .init(bonus: .secondarySkill(.wisdom)))
                case at(7, y: 1):
                    assertScholar(expected: .init(bonus: .spell(.prayer)))
              
                default: XCTFail("Unexpected object found at: \(object.objectID), object: \(object)")
                }
            }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension ScholarOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "scholar", inspector: inspector)
    }
}
