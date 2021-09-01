//
//  CreaturesOnMapTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-01.
//

import XCTest
import Foundation
@testable import HoMM3SwiftUI

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/creatures.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/creatures.h3m

final class CreaturesOnMapTests: BaseMapTest {
    func testLoad() throws {
        
        var expectations: [XCTestExpectation] = []
        func at(_ x: Int32, y: Int32) -> Position {
            let position = Position(x: x, y: y, inUnderworld: false)
            let expectedObjectAt = expectation(description: "Expected object at: (\(x), \(y))")
            expectations.append(expectedObjectAt)
            return position
        }
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, "") },
                onParseDescription: { XCTAssertEqual($0, "") },
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .small) },
                onFinishedParsingBasicInfo: { XCTAssertFalse($0.hasTwoLevels) }
            ),
            onParseObject: { object in
                
                func assertCreature(
                    _ creatureID: Creature.ID,
                    _ quantity: Map.Monster.Quantity = .random,
                    grows: Bool = true,
                    disposition: Map.Monster.Disposition = .aggressive,
                    mayFlee: Bool = true,
                    message: String? = nil,
                    treasure: Map.Monster.Bounty? = nil,
                    _ line: UInt = #line
                ) {
                    guard case let .monster(monster) = object.kind else {
                        XCTFail("Expected monster, but got: \(object.kind)")
                        return
                    }
                    XCTAssertEqual(monster.creatureID, creatureID, line: line)
                }
                
                switch object.position {
                case at(0, y: 0):
                    assertCreature(
                        .dwarf,
                        .custom(1337),
                        disposition: .savage,
                        mayFlee: false,
                        message: "Added by Cyon: Dwarfes, 1337 of them and savage! Also never flees. Rewarded with Shackles of War artifact and 40 wood, 50 mercury, 60 ore, 70 sulfur, 80 crystal, 90 gems and 100 gold. Make sure 100 gold is not counted as just 1 gold. Parsed number should be multiplied by one hundred I think.",
                        treasure: .init(
                            artifactID: .shacklesOfWar,
                            resources: .init(
                                resources: [
                                    .init(kind: .wood, amount: 40),
                                ]
                            )
                        )
                    )
                case at(1, y: 1):
                    assertCreature(.pikeman)
                default: break
                }
            }
        )
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension CreaturesOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "creatures-cyon-modified", inspector: inspector)
    }
}
