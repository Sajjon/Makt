//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-15.
//

import XCTest
import Foundation
import Malm
@testable import H3M

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/random-SoD.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/random-SoD.h3m

final class GeneratedMapSoDTests: BaseMapTest {
    
    func testGeneratedRandomMapSoD() throws {
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, "Random Map") },
                onParseDescription: { XCTAssertEqual($0, "Map created by the Random Map Generator.  Template was Ring, Random seed was 1558282329, size 144, levels 2, humans 8, computers 0, water normal, monsters 4, second expansion map") },
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .extraLarge) },
                onFinishedParsingBasicInfo: { XCTAssertTrue($0.hasTwoLevels) }
            ),
            playersInfoInspector: .init(onFinishParsingInformationAboutPlayers: { playersInfo in
               
                XCTArraysEqual(playersInfo.availablePlayers, Player.allCases)
                
                playersInfo.players.forEach({ playerInfo in
                    XCTAssertNotNil(playerInfo.mainTown)
                    XCTAssertEqual(playerInfo.behaviour, .random)
                })
            }),
            additionalInformationInspector: .init(
                onParseTeamInfo: { teams in
                    XCTAssertEqual(teams, [[6, 7], [5, 8], [2, 3], [1, 4]])
                },
                onParseAvailableHeroes: nil,
                onParseCustomHeroes: nil,
                onParseAvailableArtifacts: nil,
                onParseAvailableSpells: nil,
                onParseAvailableSecondarySkills: nil,
                onParseRumors: { XCTAssertNil($0) },
                onParseHeroSettings: nil
            ),
            onParseObject: { [unowned self] object in
                
                switch object.position {

                case at(108, y: 134, inUnderworld: true):
                    assertObjectResource(expected: .init(kind: .random, quantity: .random), actual: object)
                case at(79, y: 143):
                    XCTAssertEqual(object.objectID.stripped, .flotsam)
                    fulfill(object: object)
                default: break
                }
            },
            onParseEvents: { XCTAssertNil($0) }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension GeneratedMapSoDTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "random-SoD", inspector: inspector)
    }
}
