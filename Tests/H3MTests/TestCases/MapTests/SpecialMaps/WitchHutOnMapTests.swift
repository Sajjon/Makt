//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-13.
//

import XCTest
import Foundation
import Malm
@testable import H3M

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/witch-hut.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/witch-hut.h3m

final class WitchHutOnMapTests: BaseMapTest {
    
    func testWitchHut() throws {
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
                
                func assertWitchHut(expected: Map.WitchHut, line: UInt = #line) {
                    assertObjectWitchHut(expected: expected, actual: object, line: line)
                }
                
                func assertHut(_ skill: Hero.SecondarySkill.Kind, line: UInt = #line) {
                    assertWitchHut(expected: .init(learnableSkills: [skill]), line: line)
                }
                
                switch object.position {
                case at(2, y: 2):
                    assertHut(.airMagic)
                case at(5, y: 2):
                    assertHut(.archery)
                case at(8, y: 2):
                    assertHut(.armorer)
                case at(11, y: 2):
                    assertHut(.artillery)
                case at(14, y: 2):
                    assertHut(.ballistics)
                case at(17, y: 2):
                    assertHut(.diplomacy)
                case at(20, y: 2):
                    assertHut(.eagleEye)
                case at(23, y: 2):
                    assertHut(.earthMagic)
                case at(26, y: 2):
                    assertHut(.estates)
                case at(29, y: 2):
                    assertHut(.fireMagic)
                case at(32, y: 2):
                    assertHut(.firstAid)
                case at(35, y: 2):
                    assertHut(.intelligence)
                case at(2, y: 5):
                    assertHut(.leadership)
                case at(5, y: 5):
                    assertHut(.learning)
                case at(8, y: 5):
                    assertHut(.logistics)
                case at(11, y: 5):
                    assertHut(.luck)
                case at(14, y: 5):
                    assertHut(.mysticism)
                case at(17, y: 5):
                    assertHut(.navigation)
                case at(20, y: 5):
                    assertHut(.necromancy)
                case at(23, y: 5):
                    assertHut(.offense)
                case at(26, y: 5):
                    assertHut(.pathfinding)
                case at(29, y: 5):
                    assertHut(.resistance)
                case at(32, y: 5):
                    assertHut(.scholar)
                case at(35, y: 5):
                    assertHut(.scouting)
                case at(2, y: 8):
                    assertHut(.sorcery)
                case at(5, y: 8):
                    assertHut(.tactics)
                case at(8, y: 8):
                    assertWitchHut(expected: .init(learnableSkills: [.airMagic, .waterMagic]))
                case at(11, y: 8):
                    assertWitchHut(expected: .init(learnableSkills: [.wisdom, .airMagic]))
              
                default: break
                }
            }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension WitchHutOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "witch-hut", inspector: inspector)
    }
}
