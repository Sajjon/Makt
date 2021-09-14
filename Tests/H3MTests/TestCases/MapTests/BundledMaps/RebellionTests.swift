//
//  RebellionTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class RebellionsTests: BaseMapTest {
    
    func test_rebellion() throws {
        let mapID: Map.ID = .rebellion
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(onParseFormat: { XCTAssertEqual($0, .restorationOfErathia) }),
            playersInfoInspector: .init(
                onFinishParsingInformationAboutPlayers: { info in
                    XCTArraysEqual(info.players[0].townTypes, Faction.playable(in: .restorationOfErathia))
                    XCTArraysEqual(info.players[1].townTypes, [.inferno])
                    XCTArraysEqual(info.players[2].townTypes, [.stronghold])
                }
            ),
            additionalInformationInspector:
                .init(
                    victoryLossInspector:
                        .init(
                            onParseVictoryConditions: { victoryConditions in
                                XCTAssertEqual(
                                    victoryConditions,
                                    [
                                        .init(kind: .buildGrailBuilding(inTownLocatedAt: .init(x: 36, y: 35)), appliesToAI: true),
                                        .standard
                                    ]
                                )
                            }
                        )
                ),
            onParseObject: { [self] object in
                switch object.position {
                case at(52, y: 57):
                    if object.objectID.stripped == .resourceGenerator {
                        assertObjectResourceGenerator(
                            expected: .init(kind: .crystalCavern),
                            actual: object
                        )
                    } else if object.objectID.stripped == .rock {
                        fulfill(object: object)
                    } else if object.objectID.stripped == .mountain {
                        fulfill(object: object)
                    } else {
                        XCTFail("Unexpected object: \(object)")
                    }
                case at(52, y: 62):
                    assertObjectScholar(expected: .init(bonus: .random), actual: object)
                case at(58, y: 48):
                    assertObjectEvent(
                        expected: .init(
                            message: "These desolate wastelands are home to the hardy barbarians.  The remains of those who have tried to conquer this kingdom lie at the pass to warn all who would try to take them.",
                            playersAllowedToTriggerThisEvent: [1, 2],
                            canBeTriggeredByComputerOpponent: true,
                            cancelEventAfterFirstVisit: true),
                        actual: object
                    )
                default: break
                }
            }
        )
        
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
        waitForExpectations(timeout: 1)
    }
}

