//
//  TestMapArtifacts.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-01.
//

import XCTest
import Foundation
@testable import HoMM3SwiftUI

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

final class ArtifactsMapTest: BaseMapTest {
    
    func testLoad() throws {
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
                if object.position == .at(15, y: 17) {
                    XCTAssertEqual(object.kind, .grail(.init(radius: 5)))
                } else {
                    switch object.position {
                    case .at(1, y: 0):
                        XCTAssertSpellScroll(object) { spellScroll in
                            XCTAssertEqual(spellScroll, .init(id: .slow, message: "spell scroll slow"))
                        }
                    case .at(3, y: 0):
                        XCTAssertSpellScroll(object) { spellScroll in
                            XCTAssertEqual(
                                spellScroll,
                                .init(
                                    id: .visions,
                                    message: "spellscrol guardians",
                                    guardians: .init(creatureStackAtSlot: [
                                        .one: .init(creatureID: .griffin, quantity: 1),
                                        .six: .init(creatureID: .swordsman, quantity: 1)
                                    ])
                                )
                            )
                        }
                    default: break
                    }
                }
            }
        )
        try load(inspector: inspector)
    }
}

private extension ArtifactsMapTest {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "artifacts", inspector: inspector)
    }
}

func XCTAssertSpellScroll(_ object: Map.Object, assert: (Map.SpellScroll) -> Void) {
    guard case let .spellScroll(spellScroll) = object.kind else {
        XCTFail("Expected spellScroll, but got: \(object.kind)")
        return
    }
    assert(spellScroll)
}

func XCTAssertArtifact(_ object: Map.Object, assert: (Map.GuardedArtifact) -> Void) {
    guard case let .artifact(artifact) = object.kind else {
        XCTFail("Expected artifact, but got: \(object.kind)")
        return
    }
    assert(artifact)
}
