//
//  MandateOfHeavenTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-08.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class MandateOfHeavenTests: BaseMapTest {
    
    func test_mandate_of_heaven() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .theMandateOfHeaven)
        let inspector = Map.Loader.Parser.Inspector(
            playersInfoInspector: .init(
                onFinishParsingInformationAboutPlayers: { info in
                    XCTArraysEqual(
                        info.players.flatMap { $0.townTypes },
                        [.castle, .necropolis, .inferno, .dungeon, .dungeon]
                    )
                    
                    XCTArraysEqual(
                        info.players.map { $0.player.color },
                        [.red, .blue, .tan, .green, .pink]
                    )
                    
                    
                    XCTAssertFalse(info.players[2].hasRandomHero)
                    guard let queen = info.players[2].mainHero else {
                        XCTFail("Expected custom main hero for player 3")
                        return
                    }
                    XCTAssertEqual(queen.name, "The Queen")
                    XCTAssertEqual(queen.portraitId, .calid)
                }
            ),
            additionalInformationInspector: .init(
                victoryLossInspector: .init(onParseVictoryConditions: { victoryConditions in
                    XCTArraysEqual(victoryConditions, [.init(kind: .captureSpecificTown(locatedAt: .init(x: 5, y: 16)), appliesToAI: false)])
                    
                })
            ),
            onParseObject: { [self] object in
                switch object.position {
                case at(124, y: 105):
                    assertObjectTown(expected: .init(
                        id: .position(.init(x: 124, y: 105)),
                        faction: .castle,
                        owner: .red,
                        name: "New Sorpigal",
                        garrison: .init(stacks: [
                            .specific(id: .archer, quantity: 5),
                            .specific(id: .archer, quantity: 5),
                            .specific(id: .pikeman, quantity: 10),
                            .specific(id: .pikeman, quantity: 10)
                        ]),
                        buildings: .custom(.init(built: [
                            .townHall, .tavern, .mageGuildLevel1, .shipyard, .dwelling1, .dwelling2
                        ], forbidden: [.fort, .grail])),
                        alignment: nil
                    ), actual: object)
                default: break
                }
            }
        )
        try loadMap(id: .theMandateOfHeaven, inspector: inspector)
        waitForExpectations(timeout: 1)
    }
    
}
