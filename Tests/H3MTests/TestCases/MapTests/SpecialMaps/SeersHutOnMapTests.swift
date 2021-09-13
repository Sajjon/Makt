//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-12.
//

import XCTest
import Foundation
import Malm
@testable import H3M

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/seers-hut.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/seers-hut.h3m

final class SeersHutOnMapTests: BaseMapTest {
    
    func testSeersHut() throws {
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, "") },
                onParseDescription: { XCTAssertEqual($0, "") },
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .small) },
                onFinishedParsingBasicInfo: { XCTAssertFalse($0.hasTwoLevels) }
            ),
            onParseObject: { [self] object in
                
                func assertSeersHut(expected: Map.Seershut, line: UInt = #line) {
                    assertObjectSeersHut(expected: expected, actual: object, line: line)
                }
                
                switch object.position {
                case at(2, y: 10):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .reachHeroLevel(5),
                                messages: .init(
                                    proposalMessage: "I am old and wise, and I do not admit just anyone into my home.  You may enter when you have reached experience level 5.",
                                    progressMessage: "Faugh.  You again.  Come back when you are level 5, as I told you.",
                                    completionMessage: "I thought you had promise.  You have indeed reached level 5. Come in, come in.  Here, I have something to reward you for your efforts.  Do you accept?"
                                ),
                                deadline: .of(month: 3, week: 2, day: 1)
                            ),
                            bounty: .experience(1000)
                        )
                    )

                default: break
                }
            }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension SeersHutOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "seers-hut", inspector: inspector)
    }
}
