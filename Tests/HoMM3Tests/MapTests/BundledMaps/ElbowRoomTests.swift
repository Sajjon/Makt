//
//  ElbowRoomTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-08.
//

import Foundation
import XCTest
@testable import HoMM3SwiftUI

final class ElbowRoomTests: BaseMapTest {
    func test_elbow_room() throws {
        let mapID: Map.ID = .elbowRoom
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .armageddonsBlade) },
                onParseName: { XCTAssertEqual($0, "Elbow Room") }
            ),
            onParseObject: { [self] object in
                switch object.position {
                case at(5, y: 19):
                    assertObjectRandomTown(
                        expected: .init(
                            id: .fromMapFile(3352760721),
                            garrison: .init(stacks: []),
                            buildings: .init(
                                built: [
                                .townHall, .fort, .tavern, .mageGuildLevel1, .dwelling1, .horde1
                            ], forbidden: []
                            ),
                            events: .init(values: [
                                .init(
                                    townID: .fromMapFile(3352760721),
                                    timedEvent: .init(
                                        name: "Stuff",
                                        message: "As you wake up, your scouts give you what they have been foraging for the week",
                                        firstOccurence: 8-1,
                                        subsequentOccurence: .everySevenDays,
                                        affectedPlayers: [1, 2, 3, 6, 7, 8],
                                        resources: .init(resources: [
                                            .init(kind: .wood, amount: 14),
                                            .init(kind: .mercury, amount: 7),
                                            .init(kind: .ore, amount: 14),
                                            .init(kind: .sulfur, amount: 7),
                                            .init(kind: .crystal, amount: 7),
                                            .init(kind: .gems, amount: 7),
                                            .init(kind: .gold, amount: 7000),
                                        ]))
                                    )
                            ])
                        ),
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
