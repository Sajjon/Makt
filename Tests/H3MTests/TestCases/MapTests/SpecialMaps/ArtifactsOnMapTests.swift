//
//  ArtifactsOnMapTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-01.
//

import XCTest
import Foundation
import Malm
@testable import H3M

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/artifacts.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/artifacts.h3m

final class ArtifactsOnMapTests: BaseMapTest {
    
    func testArtifactsOnMap() throws {

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
                if object.position == at(15, y: 17) {
                    XCTAssertEqual(object.kind, .grail(.init(radius: 5)))
                    fulfill(object: object)
                } else {
                    
                    func assertArtifact(expected: Map.GuardedArtifact, line: UInt = #line) {
                        assertObjectArtifact(expected: expected, actual: object, line: line)
                    }
                    
                    func assertSpellScroll(expected: Map.SpellScroll, line: UInt = #line) {
                        assertObjectSpellScroll(expected: expected, actual: object, line: line)
                    }

                    switch object.position {
                    case at(1, y: 0):
                        assertSpellScroll(expected: .init(id: .slow, message: "spell scroll slow"))
                    case at(3, y: 0):
                        assertSpellScroll(expected: .init(
                            id: .visions,
                            message: "spellscrol guardians",
                            guardians: .init(creatureStackAtSlot: [
                                .one: .specific(id: .griffin, quantity: 1),
                                .six: .specific(id: .swordsman, quantity: 1)
                            ])
                        ))
                    case at(1, y: 1):
                        assertArtifact(expected: .specific(id: .centaurAxe, message: "centaurus axe"))
                    case at(1, y: 2):
                        assertArtifact(expected: .specific(id: .shieldOfTheDwarvenLords, message: "shield dwarven lords"))
                    case at(1, y: 3):
                        assertArtifact(expected: .specific(id: .helmOfTheAlabasterUnicorn, message: "helm unicorn"))
                    case at(1, y: 4):
                        assertArtifact(expected: .specific(id: .breastplateOfPetrifiedWood, message: "breastplate of pertified wood"))
                    case at(1, y: 5):
                        assertArtifact(expected: .specific(id: .sandalsOfTheSaint, message: "sandals saint"))
                    case at(1, y: 6):
                        assertArtifact(expected: .specific(id: .celestialNecklaceOfBliss, message: "necklace bliss"))
                    case at(1, y: 7):
                        assertArtifact(expected: .specific(id: .quietEyeOfTheDragon, message: "eye dragon"))
                    case at(1, y: 12):
                        assertArtifact(expected: .specific(id: .cloakOfTheUndeadKing, message: "cloak undead king"))
                    case at(1, y: 14):
                        assertArtifact(
                            expected: .random(
                                class: Artifact.Class.any,
                                message: "random",
                                guardians: .init(
                                    stacksAtSlots: [
                                        (CreatureStacks.Slot.one, .specific(id: .archer, quantity: 1)),
                                        (CreatureStacks.Slot.seven, .specific(id: .archer, quantity: 1))
                                    ]
                                )
                            )
                        )
                    case at(3, y: 14):
                        assertArtifact(expected: .random(class: .treasure, message: "random treasure"))
                    case at(5, y: 14):
                        assertArtifact(expected: .random(class: .minor, message: "random minor"))
                    case at(7, y: 14):
                        assertArtifact(expected: .random(class: .major, message: "random major"))
                    case at(9, y: 14):
                        assertArtifact(expected: .random(class: .relic, message: "random relic"))
                       
                    default: break
                    }
                }
            }
        )
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension ArtifactsOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "artifacts", inspector: inspector)
    }
}


