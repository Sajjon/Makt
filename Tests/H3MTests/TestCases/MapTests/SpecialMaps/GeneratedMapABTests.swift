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

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/random-AB.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/random-AB.h3m

final class GeneratedMapABTests: BaseMapTest {
    
    func testGeneratedRandomMapAB() throws {
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .restorationOfErathia) },
                onParseName: { XCTAssertEqual($0, "Random Map") },
                onParseDescription: { XCTAssertEqual($0, "Map created by the Random Map Generator.  Template was 8XM8, Random seed was 1558282361, size 144, levels 2, humans 8, computers 0, water normal, monsters 4, first expansion map") },
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
            onParseObject: { [self] object in
                
                switch object.position {
                case at(40, y: 1):
                    assertObjectResource(expected: .init(kind: .specific(.ore), quantity: .random), actual: object)
                case at(80, y: 143):
                    assertObjectMonster(expected: .init(.specific(creatureID: .centaurCaptain)), actual: object)
                case at(128, y: 13, inUnderworld: true):
                    assertObjectPandorasBox(expected: .init(experiencePointsToBeGained: 5000), actual: object)
                case at(128, y: 30, inUnderworld: true):
                    assertObjectMonster(expected: .init(.specific(creatureID: .iceElemental), quantity: .specified(75), disposition: .hostile), actual: object)
                case at(83, y: 143, inUnderworld: true):
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

private extension GeneratedMapABTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "random-AB", inspector: inspector)
    }
}
