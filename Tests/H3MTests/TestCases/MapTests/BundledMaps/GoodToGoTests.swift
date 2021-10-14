//
//  GoodToGo.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-08.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class GoodToGoMapTest: BaseMapTest {
    
    /// Smallest compressed file size
    func test_good_to_go() throws {
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(onParseFormat: {
                XCTAssertEqual($0, .restorationOfErathia)
            },
            onParseName: { XCTAssertEqual($0, "Good to Go") },
            onParseDescription: {  XCTAssertEqual($0, "In an effort to reduce the frequency of wars between the various nations, the Emperor has set aside a small region to be used as a battleground to settle differences between quarreling Lords. Your castle starts fully constructed so that you may concentrate on defeating your opponent. Good luck!") },
            onParseDifficulty: { XCTAssertEqual($0, .normal) },
            onParseSize: { XCTAssertEqual($0, .small) }),

            additionalInformationInspector: .init(
                onParseTeamInfo: { XCTAssertEqual($0, [[1], [2], [4, 5]]) }
            ),
            onParseObject: { [unowned self] object in
                switch object.position {
                case at(34, y: 4):
                    assertObjectTown(
                        expected: .init(
                            id: .position(.init(x: 34, y: 4, inUnderworld: false)),
                            faction: .fortress,
                            owner: .green,
                            buildings: .custom(.init(
                                built: [
                                    .townHall, .cityHall, .capitol,
                                    .fort, .citadel, .castle,
                                    .tavern, .blacksmith, .marketplace, .resourceSilo,
                                    .mageGuildLevel1, .mageGuildLevel2, .mageGuildLevel3,
                                    .special1, .special2, .special3,
                                    .dwellingLevel1, .dwellingLevel1Upgraded, .horde1,
                                    .dwellingLevel2, .dwellingLevel2Upgraded,
                                    .dwellingLevel3, .dwellingLevel3Upgraded,
                                    .dwellingLevel4, .dwellingLevel4Upgraded
                                ]
                            )),
                            alignment: nil
                        ),
                        actual: object
                    )
                case at(5, y: 5):
                    if object.objectID.stripped == .randomTown {
                        assertObjectRandomTown(expected: .init(
                            id: .position(.init(x: 5, y: 5, inUnderworld: false)),
                            owner: .red,
                            buildings: .custom(.init(built: Building.ID.Common.all(but: [.shipyard, .special1, .special2, .special3, .special4]), forbidden: [.shipyard])),
                            spells: .init(
                                possible: .init(
                                    values: Spell.ID.all(
                                        but: [.summonBoat, .scuttleBoat, .waterWalk]
                                    )
                                )
                            ),
                            alignment: nil
                        ), actual: object)
                    } else if object.objectID.stripped == .randomHero {
                        assertObjectRandomHero(
                            expected: .init(
                                identifierKind: .randomHero,
                                owner: .red,
                                startingExperiencePoints: 6_000,
                                gender: nil
                            ), actual: object)
                    } else {
                        XCTFail("Unexpected object of kind: \(object.kind).")
                    }


                case at(5, y: 33):
                    assertObjectTown(
                        expected: .init(
                            id: .position(.init(x: 5, y: 33, inUnderworld: false)),
                            faction: .stronghold,
                            owner: .orange,
                            buildings: .custom(.init(
                                built: [
                                    .townHall, .cityHall, .capitol,
                                    .fort, .citadel, .castle,
                                    .tavern, .blacksmith, .marketplace, .resourceSilo,
                                    .mageGuildLevel1, .mageGuildLevel2, .mageGuildLevel3,
                                    .special1, .special2, .special3, .special4,
                                    .dwellingLevel1, .dwellingLevel1Upgraded, .horde1,
                                    .dwellingLevel2, .dwellingLevel2Upgraded,
                                    .dwellingLevel3, .dwellingLevel3Upgraded,
                                    .dwellingLevel4, .dwellingLevel4Upgraded
                                ]
                            )),
                            alignment: nil
                        ),
                        actual: object
                    )

                case at(26, y: 6):
                    assertObjectHero(
                        class: .beastmaster,
                        expected: .init(
                            identifierKind: .specificHeroWithID(.korbac),
                            owner: .green,
                            army: .init(stacks: [
                                .specific(id: .gnoll, quantity: 100),
                                .specific(id: .gnoll, quantity: 100)
                            ]),
                            startingExperiencePoints: 18_500,
                            gender: nil
                        ),
                        actual: object)
                case at(33, y: 8):
                    assertObjectHero(
                        class: .witch,
                        expected: .init(
                            identifierKind: .specificHeroWithID(.verdish),
                            owner: .green,
                            army: .init(stacks: [
                                .specific(id: .gnoll, quantity: 100),
                                .specific(id: .gnoll, quantity: 100)
                            ]),
                            startingExperiencePoints: 18_500,
                            gender: nil
                        ),
                        actual: object)
                case at(2, y: 28):
                    assertObjectHero(
                        class: .barbarian,
                        expected: .init(
                            identifierKind: .specificHeroWithID(.yog),
                            owner: .orange,
                            army: .init(stacks: [
                                .specific(id: .goblin, quantity: 100),
                                .specific(id: .goblin, quantity: 100)
                            ]),
                            startingExperiencePoints: 18_500,
                            gender: nil
                        ),
                        actual: object)

                case at(7, y: 35):
                    assertObjectHero(
                        class: .battleMage,
                        expected: .init(
                            identifierKind: .specificHeroWithID(.oris),
                            owner: .orange,
                            army: .init(stacks: [
                                .specific(id: .goblin, quantity: 100),
                                .specific(id: .goblin, quantity: 100)
                            ]),
                            startingExperiencePoints: 18_500,
                            gender: nil
                        ),
                        actual: object)

                case at(34, y: 33):
                    if object.objectID.stripped == .randomTown {
                        assertObjectRandomTown(expected: .init(
                            id: .position(.init(x: 34, y: 33, inUnderworld: false)),
                            owner: .blue,
                            buildings: .custom(.init(built: Building.ID.Common.all(but: [.shipyard, .special1, .special2, .special3, .special4]), forbidden: [.shipyard])),
                            spells: .init(
                                possible: .init(
                                    values: Spell.ID.all(
                                        but: [.summonBoat, .scuttleBoat, .waterWalk]
                                    )
                                )
                            ),
                            alignment: nil
                        ), actual: object)
                    } else if object.objectID.stripped == .randomHero {
                        assertObjectRandomHero(
                            expected: .init(
                                identifierKind: .randomHero,
                                owner: .blue,
                                startingExperiencePoints: 6_000,
                                gender: nil
                            ), actual: object)
                    } else {
                        XCTFail("Unexpected object of kind: \(object.kind).")
                    }

                default: break
                }

            },
        onParseEvents: { maybeEvents in
            guard let events = maybeEvents else {
                XCTFail("Expected events")
                return
            }
            XCTAssertEqual(events.count, 2)

            XCTAssertEqual(
                events[0],
                .init(
                    name: "Starting Resources",
                    message: "The duel has begun, and will end only when one of you remains. As part of the ritual of combat in this region, you are provided with enough supplies with which to wage war.",
                    firstOccurence: 1-1,
                    affectedPlayers: [1, 2, 4, 5],
                    appliesToHumanPlayers: true,
                    appliesToComputerPlayers: true,
                    resources: .init(resources: [
                        .init(kind: .wood, quantity: 75),
                        .init(kind: .mercury, quantity: 50),
                        .init(kind: .ore, quantity: 75),
                        .init(kind: .sulfur, quantity: 50),
                        .init(kind: .crystal, quantity: 50),
                        .init(kind: .gems, quantity: 50),
                        .init(kind: .gold, quantity: 50_000),
                    ])
                )
            )

            XCTAssertEqual(
                events[1],
                .init(
                    name: "Warning",
                    message: "You must also be careful, as the natives will try to stop both you and your opponent from winning!",
                    firstOccurence: 1-1,
                    affectedPlayers: [1, 2, 4, 5],
                    appliesToHumanPlayers: true,
                    appliesToComputerPlayers: true
                )
            )
        }
        )
        try loadMap(id: .goodToGo, inspector: inspector)
        waitForExpectations(timeout: 1)
    }
    
    func testJSONRoundtrip() throws {
        let mapID: Map.ID = .goodToGo
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: mapID)
        
        var start = CFAbsoluteTimeGetCurrent()
        let mapFromBinary = try Map.load(mapID)
        let timeBinary = CFAbsoluteTimeGetCurrent() - start
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(mapFromBinary)
        let jsonDecoder = JSONDecoder()
        start = CFAbsoluteTimeGetCurrent()
        let mapFromJSON = try jsonDecoder.decode(Map.self, from: jsonData)
        let timeJson = CFAbsoluteTimeGetCurrent() - start
        XCTAssertEqual(mapFromBinary, mapFromJSON)
        
        XCTAssertEqual(timeBinary, timeJson, accuracy: 0.01)
//        print(String(format: "timeBinary: %.3f seconds", timeBinary))
//        print(String(format: "timeJson: %.3f seconds", timeJson))
//        
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//        
//        print(jsonString)
    }
}
