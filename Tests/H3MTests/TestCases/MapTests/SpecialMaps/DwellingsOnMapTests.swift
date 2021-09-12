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

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/dwellings.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/dwellings.h3m

final class DwellingsOnMapTests: BaseMapTest {
    
    func testDwellingsOnMap() throws {
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
                
                func assertRandomDwelling(
                    expected expectedRandom: Map.Dwelling.Kind.Random,
                    owner: Player? = nil,
                    line: UInt = #line
                ) {
                    assertObjectRandomDwelling(expected: expectedRandom, owner: owner, actual: object, line: line)
                }
                
                
                func assertRandomDwelling(
                    faction: Faction,
                    minLevel: Creature.Level,
                    owner: Player? = nil,
                    line: UInt = #line
                ) {
                    assertRandomDwelling(
                        expected: .init(
                            possibleFactions: [faction],
                            possibleLevels: .range(.init(min: minLevel, max: .seven))
                        ),
                        owner: owner,
                        line: line
                    )
                }
                
                func assertRandomDwelling(
                    level: Creature.Level,
                    owner: Player? = nil,
                    line: UInt = #line
                ) {
                    assertRandomDwelling(
                        expected: .init(possibleFactions: .init(values: Faction.playable(in: .shadowOfDeath)), possibleLevels: .specific(level)),
                        owner: owner,
                        line: line
                    )
                }
                
                func assertRandomDwelling(
                    faction: Faction,
                    owner: Player? = nil,
                    line: UInt = #line
                ) {
                    assertRandomDwelling(
                        expected: .init(possibleFactions: .init(values: [faction]), possibleLevels: .all),
                        owner: owner,
                        line: line
                    )
                }
                
                switch object.position {
                case at(2, y: 11):
                    assertRandomDwelling(faction: .castle, minLevel: .one)
                case at(5, y: 11):
                    assertRandomDwelling(faction: .rampart, minLevel: .two)
                case at(8, y: 11):
                    assertRandomDwelling(faction: .tower, minLevel: .three)
                case at(11, y: 11):
                    assertRandomDwelling(faction: .inferno, minLevel: .four)
                case at(14, y: 11):
                    assertRandomDwelling(faction: .necropolis, minLevel: .five)
                case at(17, y: 11):
                    assertRandomDwelling(faction: .dungeon, minLevel: .six)
                case at(20, y: 11):
                    assertRandomDwelling(faction: .stronghold, minLevel: .seven)
                case at(23, y: 11):
                    assertRandomDwelling(
                        expected: .init(
                            possibleFactions: [.fortress, .conflux],
                            possibleLevels: .range(.init(min: .two, max: .two))
                        ),
                        owner: nil
                    )
                case at(26, y: 11):
                    assertRandomDwelling(
                        expected: .init(
                            possibleFactions: [.conflux],
                            possibleLevels: .range(.init(min: .two, max: .three))
                        ),
                        owner: nil
                    )
                    
                    
                case at(2, y: 17):
                    assertRandomDwelling(level: .one)
                case at(5, y: 17):
                    assertRandomDwelling(level: .two)
                case at(8, y: 17):
                    assertRandomDwelling(level: .three)
                case at(11, y: 17):
                    assertRandomDwelling(level: .four)
                case at(14, y: 17):
                    assertRandomDwelling(level: .five)
                case at(17, y: 17):
                    assertRandomDwelling(level: .six)
                case at(20, y: 17):
                    assertRandomDwelling(level: .seven)
                    
                case at(2, y: 22):
                    assertRandomDwelling(faction: .castle)
                case at(5, y: 22):
                    assertRandomDwelling(faction: .rampart)
                case at(8, y: 22):
                    assertRandomDwelling(faction: .tower)
                case at(11, y: 22):
                    assertRandomDwelling(faction: .inferno)
                case at(14, y: 22):
                    assertRandomDwelling(faction: .necropolis)
                case at(17, y: 22):
                    assertRandomDwelling(faction: .dungeon)
                case at(20, y: 22):
                    assertRandomDwelling(faction: .stronghold)
                case at(23, y: 22):
                    assertRandomDwelling(faction: .fortress)
                case at(26, y: 22):
                    assertRandomDwelling(faction: .conflux)
                    
//                case at(2, y: 28):
//                    assertRandomDwelling(expected: .init(possibleFactions: .sameAsTown(), possibleLevels: <#T##Map.Dwelling.Kind.Random.PossibleLevels#>), owner: <#T##Player?#>)
                default: break
                }
            }
        )
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}


private extension DwellingsOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "dwelling", inspector: inspector)
    }
}
