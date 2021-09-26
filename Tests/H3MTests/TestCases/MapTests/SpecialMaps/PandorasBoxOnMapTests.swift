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

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/pandora-box.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/pandora-box.h3m

final class PandorasBoxOnMapTests: BaseMapTest {
    
    func testPandorasBox() throws {
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, "") },
                onParseDescription: { XCTAssertEqual($0, "") },
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .medium) },
                onFinishedParsingBasicInfo: { XCTAssertTrue($0.hasTwoLevels) }
            ),
            onParseObject: { [unowned self] object in
                
                func assertPandorasBox(expected: Map.PandorasBox, line: UInt = #line) {
                    assertObjectPandorasBox(expected: expected, actual: object, line: line)
                }
                
                switch object.position {
                case at(1, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "Experience", experiencePointsToBeGained: 1000)
                    )
                case at(3, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "spell points", spellPointsToBeGainedOrDrained: 5)
                    )
                case at(5, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "spell points take", spellPointsToBeGainedOrDrained: -5)
                    )
                    
                case at(7, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "morale", moraleToBeGainedOrDrained: 2)
                    )
                case at(9, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "-morale", moraleToBeGainedOrDrained: -3)
                    )
                case at(11, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "luck", luckToBeGainedOrDrained: 2)
                    )
                case at(13, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "-luck", luckToBeGainedOrDrained: -3)
                    )
                case at(15, y: 1):
                    assertPandorasBox(
                        expected: Map.PandorasBox(
                            resources: [
                                .wood(1),
                                .mercury(2),
                                .ore(3),
                                .sulfur(4),
                                .crystal(5),
                                .gems(6),
                                .gold(7),
                            ]
                        )
                    )
                case at(17, y: 1):
                    assertPandorasBox(
                        expected: Map.PandorasBox(
                            message: "take resources",
                            resources: [
                                .wood(-7),
                                .mercury(-6),
                                .ore(-5),
                                .sulfur(-4),
                                .crystal(-3),
                                .gems(-2),
                                .gold(-1),
                            ]
                        )
                    )
                case at(19, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "primary skills", primarySkills: [
                            .attack(1),
                            .defense(2),
                            .power(3),
                            .knowledge(4)
                        ])
                    )
                case at(21, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "secondary sckills", secondarySkills: [
                            .init(kind: .pathfinding, level: .basic),
                            .init(kind: .logistics, level: .advanced),
                            .init(kind: .diplomacy, level: .expert)
                        ])
                    )
                case at(23, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "artifacts", artifactIDs: [
                            .admiralHat
                        ])
                    )
                case at(25, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "spells", spellIDs: [
                            .airElemental
                        ])
                    )
                case at(27, y: 1):
                    assertPandorasBox(
                        expected: .init(message: "creatures", creaturesGained: [
                            .init(kind: .specific(creatureID: .pikeman), quantity: 1)
                        ])
                    )
                case at(1, y: 3):
                    assertPandorasBox(
                        expected: .init(message: "guardians", guardians: .init(creatureStackAtSlot: [
                            .one: .init(kind: .specific(creatureID: .archer), quantity: 2),
                            .seven: .init(kind: .specific(creatureID: .griffin), quantity: 3),
                        ]))
                    )
                default: break
                }
            }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension PandorasBoxOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "pandora-box", inspector: inspector)
    }
}
