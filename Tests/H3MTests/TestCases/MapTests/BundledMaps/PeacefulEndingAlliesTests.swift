//
//  PeacefulEndingAlliesTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class PeacefulEndingAlliesTests: BaseMapTest {
    func test_peacefulEndingAllies() throws {
        let mapID: Map.ID = .peacefulEndingAllies
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath)},
                onParseName: { XCTAssertEqual($0, "Peaceful Ending (Allies)")},
                onParseDescription: { XCTAssertEqual($0, "Trade has been the key to peace for as long as everyone can remember.  Everything was going well until one nation stopped trading with the others, their reasons unknown.  War broke out, for nations desperately needed resources, and it has raged ever since.  A peace must be reached. ")},
                onParseDifficulty: { XCTAssertEqual($0, .hard)},
                onParseSize: { XCTAssertEqual($0, .large)}
            ),
            onParseObject: { [self] object in
                switch object.position {
                case at(55, y: 34):
                    if object.objectID.stripped == .randomTown {
                    assertObjectRandomTown(expected: .init(
                                            id: .fromMapFile(3027977090),
                                   
                                            garrison: .init(stacksAtSlots: [
                                                (CreatureStacks.Slot.one, .placeholder(level: .one, upgraded: true, quantity: 60)),
                                                (.three, .placeholder(level: .three, upgraded: true, quantity: 35)),
                                                (.five, .placeholder(level: .five, upgraded: true, quantity: 20)),
                                                (.seven, .placeholder(level: .seven, upgraded: true, quantity: 3)),
                                            ]),
                                            buildings: .custom(.init(built: [
                                                .townHall, .cityHall,
                                                .fort, .citadel, .castle,
                                                .tavern, .blacksmith, .marketplace,
                                                .mageGuildLevel1, .mageGuildLevel2, .mageGuildLevel3,
                                                .dwelling1, .dwelling2, .dwelling3, .dwelling4
                                                
                                            ], forbidden: []))), actual: object)
                    } else if object.objectID.stripped == .cactus {
                        fulfill(object: object)
                    } else {
                        XCTFail("unexpected object: \(object)")
                    }
                default: break
                }
            }
            )
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
        waitForExpectations(timeout: 1)
    }
}
