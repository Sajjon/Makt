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

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/town-spells-4-5.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/town-spells-4-5.h3m

final class TownWithSpellsLevelFourToFiveTests: BaseMapTest {
    
    func testTownWithSpellsLevelFourToFive() throws {
        
        var next: UInt32 = 0
        let townIDBase: UInt32 = 4228396649
        
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
                
                func assertTown(
                    _ spell: Spell.ID,
                    name maybeName: String? = nil,
                    townID maybeTownID: ((_ base: UInt32) -> UInt32)? = nil,
                    line: UInt = #line
                ) {
                    defer { next += 1  }
                    let name = maybeName ?? String(describing: spell)
                    let townID = maybeTownID?(townIDBase) ?? next + townIDBase
                    assertObjectTown(
                        expected: .init(
                            id: .fromMapFile(townID),
                            faction: .tower,
                            name: name,
                            spells: .init(possible: .allCases, obligatory: [spell])
                        ),
                        actual: object,
                        line: line)
                }
                
                let positionEnum: SizeSmall = {
                    let positionEnum = SizeSmall(position: object.position)
                    expectObject(at: object.position)
                    return positionEnum
                }()
                
                switch positionEnum {
                case .x4y3:
                    assertTown(.armageddon, name: "armagedon", townID: { $0 - 1 })
                case .x9y3:
                    assertTown(.berserk)
                case .x14y3:
                    assertTown(.chainLightning, name: "chain lightnin") // SIC
                case .x19y3:
                    assertTown(.clone)
                case .x24y3:
                    assertTown(.counterstrike, name: "countrstrike")
                case .x29y3:
                    assertTown(.fireShield, name: "fire shield")
                case .x34y3:
                    assertTown(.frenzy)
                case .x4y6:
                    assertTown(.inferno)
                case .x9y6:
                    assertTown(.meteorShower, name: "meteor sower") // SIC
                case .x14y6:
                    assertTown(.prayer)
                case .x19y6:
                    assertTown(.resurrection, name: "ressurection") // SIC
                case .x24y6:
                    assertTown(.slayer)
                case .x29y6:
                    assertTown(.sorrow)
                case .x34y6:
                    assertTown(.townPortal, name: "town portal")
                case .x4y10:
                    assertTown(.waterWalk, name: "water walk")
                case .x9y10:
                    assertTown(.airElemental, name: "air elemental")
                case .x14y10:
                    assertTown(.dimensionDoor, name: "dimension door")
                case .x19y10:
                    assertTown(.earthElemental, name: "earth elementa") // Char cap reached
                case .x24y10:
                    assertTown(.fireElemental, name: "fire elemental")
                case .x29y10:
                    assertTown(.fly)
                case .x34y10:
                    assertTown(.implosion, name: "implsion") // SIC
                case .x4y14:
                    assertTown(.magicMirror, name: "magic mirror")
                case .x9y14:
                    assertTown(.sacrifice)
                case .x14y14:
                    assertTown(.waterElemental, name: "water elementa") // Char cap reached
              
                default:
                    XCTFail("Unexpected object found at: \(object.objectID), object: \(object)")
                }
            }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension TownWithSpellsLevelFourToFiveTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "town-spells-4-5", inspector: inspector)
    }
}
