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

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/random-RoE.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/random-RoE.h3m

final class GeneratedMapRoETests: BaseMapTest {
    
    func testGeneratedRandomMapRoE() throws {
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .restorationOfErathia) },
                onParseName: { XCTAssertEqual($0, "Random Map") },
                onParseDescription: { XCTAssertEqual($0, "Map created by the Random Map Generator.  Template was 8MM6, Random seed was 1558282385, size 144, levels 2, humans 8, computers 0, water normal, monsters 4, original map") },
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
                    XCTAssertEqual(teams, [[2, 5], [1, 3], [4, 6], [7, 8]])
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
                case at(121, y: 126):
                    assertObjectPrisonHero(
                        expected: .init(
                            identifierKind: .specificHeroWithID(.iona),
                            gender: nil
                        ),
                        actual: object
                    )
                case at(109, y: 121, inUnderworld: true):
                    assertObjectPrisonHero(
                        expected: .init(
                            identifierKind: .specificHeroWithID(.xsi),
                            startingExperiencePoints: 5000,
                            gender: nil
                        ),
                        actual: object
                    )
                case at(70, y: 69, inUnderworld: true):
                    assertObjectPrisonHero(
                        expected: .init(
                            identifierKind: .specificHeroWithID(.torosar),
                            startingExperiencePoints: 15000,
                            gender: nil
                        ),
                        actual: object
                    )
                case at(85, y: 15, inUnderworld: true):
                    assertObjectPandorasBox(
                        expected: .init(creaturesGained: [.harpyHag(30)]),
                        actual: object
                    )
                case at(90, y: 31, inUnderworld: true):
                    XCTAssertEqual(object.objectID.stripped, .subterraneanGate)
                    fulfill(object: object)
                case at(141, y: 143):
                    assertObjectResource(expected: .init(kind: .random, quantity: .random), actual: object)
                default: break
                }
            },
            onParseEvents: { XCTAssertNil($0) }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension GeneratedMapRoETests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "random-RoE", inspector: inspector)
    }
}
