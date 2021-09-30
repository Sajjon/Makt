//
//  ForSaleTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
import Malm
@testable import H3M

extension Array where Element == Map.Tile {
    func tile(at position: Position) -> Map.Tile {
        guard let tile = self.first(where: { $0.position == position }) else {
            fatalError("expected to find tile")
        }
        return tile
    }
}

final class ForSaleTests: BaseMapTest {
    
    func test_forSale() throws {
        let mapID: Map.ID = .forSale
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, "For Sale") },
                onParseDescription: { XCTAssertEqual($0, "A rich lord has put his beautiful kingdom up for sale.  While fighting off your opponents, you are to raise the money to purchase the kingdom before they do.  There is one catch: you cannot lose your home town.") },
                onParseDifficulty:  { XCTAssertEqual($0, .hard) },
                onParseSize:  { XCTAssertEqual($0, .small) }
            ),
            additionalInformationInspector: .init(
                victoryLossInspector: .init(
                    onParseVictoryConditions: {
                        XCTAssertEqual($0, [.init(kind: .captureSpecificTown(locatedAt: .init(x: 11, y: 14)), appliesToAI: true)])
                    },
                    onParseLossConditions: {
                        XCTAssertEqual($0, [.init(kind: .loseSpecificTown(locatedAt: .init(x: 12, y: 5))), .standard])
                    }
                ),
                onParseTeamInfo: {
                    XCTAssertEqual($0, [[1], [2, 3]])
                }
           ),
            onParseWorld: { [self] world in
                let tiles = world.above.tiles
                
                func terrainAt(
                    x: Int32,
                    y: Int32,
                    terrain expectedTerrainKind: Map.Terrain,
                    isCostal expectTileToBeCoastal: Bool? = nil,
                    frameIndex expectedFrameIndex: Int? = nil,
                    isMirroredVertically expectTileToBeMirroredVertically: Bool? = nil,
                    isMirroredHorizontally expectTileToBeMirroredHorizontally: Bool? = nil,
                    line: UInt = #line
                ) {
                    assertTile(
                        tiles.tile(at: .init(x: x, y: y)),
                        terrain: expectedTerrainKind,
                        isCostal: expectTileToBeCoastal,
                        frameIndex: expectedFrameIndex,
                        isMirroredVertically: expectTileToBeMirroredVertically,
                        isMirroredHorizontally: expectTileToBeMirroredHorizontally,
                        line: line
                    )
                }
                
                let expectedCostalTilePositions: [Position] = [.init(x: 0, y: 3), .init(x: 1, y: 3), .init(x: 33, y: 3), .init(x: 34, y: 3), .init(x: 35, y: 3), .init(x: 1, y: 4), .init(x: 2, y: 4), .init(x: 3, y: 4), .init(x: 4, y: 4), .init(x: 30, y: 4), .init(x: 31, y: 4), .init(x: 32, y: 4), .init(x: 33, y: 4), .init(x: 4, y: 5), .init(x: 5, y: 5), .init(x: 29, y: 5), .init(x: 30, y: 5), .init(x: 5, y: 6), .init(x: 6, y: 6), .init(x: 7, y: 6), .init(x: 8, y: 6), .init(x: 29, y: 6), .init(x: 8, y: 7), .init(x: 9, y: 7), .init(x: 29, y: 7), .init(x: 9, y: 8), .init(x: 10, y: 8), .init(x: 29, y: 8), .init(x: 10, y: 9), .init(x: 11, y: 9), .init(x: 29, y: 9), .init(x: 11, y: 10), .init(x: 29, y: 10), .init(x: 30, y: 10), .init(x: 11, y: 11), .init(x: 30, y: 11), .init(x: 10, y: 12), .init(x: 11, y: 12), .init(x: 30, y: 12), .init(x: 31, y: 12), .init(x: 9, y: 13), .init(x: 10, y: 13), .init(x: 31, y: 13), .init(x: 8, y: 14), .init(x: 9, y: 14), .init(x: 31, y: 14), .init(x: 32, y: 14), .init(x: 6, y: 15), .init(x: 7, y: 15), .init(x: 8, y: 15), .init(x: 32, y: 15), .init(x: 33, y: 15), .init(x: 5, y: 16), .init(x: 6, y: 16), .init(x: 33, y: 16), .init(x: 34, y: 16), .init(x: 4, y: 17), .init(x: 5, y: 17), .init(x: 34, y: 17), .init(x: 4, y: 18), .init(x: 34, y: 18), .init(x: 35, y: 18), .init(x: 4, y: 19), .init(x: 4, y: 20), .init(x: 4, y: 21), .init(x: 5, y: 21), .init(x: 5, y: 22), .init(x: 6, y: 22), .init(x: 6, y: 23), .init(x: 7, y: 23), .init(x: 8, y: 23), .init(x: 9, y: 23), .init(x: 10, y: 23), .init(x: 11, y: 23), .init(x: 1, y: 24), .init(x: 2, y: 24), .init(x: 11, y: 24), .init(x: 12, y: 24), .init(x: 13, y: 24), .init(x: 0, y: 25), .init(x: 1, y: 25), .init(x: 2, y: 25), .init(x: 3, y: 25), .init(x: 13, y: 25), .init(x: 14, y: 25), .init(x: 15, y: 25), .init(x: 3, y: 26), .init(x: 4, y: 26), .init(x: 15, y: 26), .init(x: 16, y: 26), .init(x: 4, y: 27), .init(x: 16, y: 27), .init(x: 4, y: 28), .init(x: 5, y: 28), .init(x: 16, y: 28), .init(x: 5, y: 29), .init(x: 15, y: 29), .init(x: 16, y: 29), .init(x: 5, y: 30), .init(x: 6, y: 30), .init(x: 14, y: 30), .init(x: 15, y: 30), .init(x: 6, y: 31), .init(x: 7, y: 31), .init(x: 13, y: 31), .init(x: 14, y: 31), .init(x: 7, y: 32), .init(x: 8, y: 32), .init(x: 9, y: 32), .init(x: 10, y: 32), .init(x: 11, y: 32), .init(x: 12, y: 32), .init(x: 13, y: 32)]
                
                let costalTiles = tiles.filter({ $0.isCoastal })
                
                XCTAssertEqual(costalTiles.count, expectedCostalTilePositions.count)
                
                XCTArraysEqual(
                    costalTiles.map { $0.position },
                    expectedCostalTilePositions
                )

                terrainAt(x: 0, y: 0, terrain: .dirt, frameIndex: 24)
                terrainAt(x: 0, y: 3, terrain: .dirt, frameIndex: 10)
                terrainAt(x: 0, y: 4, terrain: .water, frameIndex: 16, isMirroredVertically: false, isMirroredHorizontally: true)
                terrainAt(x: 0, y: 35, terrain: .grass, frameIndex: 55)
                
                terrainAt(x: 5, y: 6, terrain: .dirt, frameIndex: 16, isMirroredVertically: true, isMirroredHorizontally: false)
                terrainAt(x: 6, y: 6, terrain: .dirt, frameIndex: 8, isMirroredVertically: true, isMirroredHorizontally: false)


                terrainAt(x: 11, y: 22, terrain: .grass, frameIndex: 56)
                terrainAt(x: 11, y: 26, terrain: .water, frameIndex: 29)
                terrainAt(x: 15, y: 13, terrain: .dirt, frameIndex: 22)
                
                terrainAt(x: 21, y: 11, terrain: .rough, frameIndex: 50)
                terrainAt(x: 25, y: 20, terrain: .rough, frameIndex: 65)
                terrainAt(x: 31, y: 4, terrain: .sand, frameIndex: 0)
                terrainAt(x: 33, y: 16, terrain: .sand, frameIndex: 5)
                terrainAt(x: 35, y: 13, terrain: .water, frameIndex: 31)
                terrainAt(x: 35, y: 35, terrain: .grass, frameIndex: 53)
            },
            onParseObject: { [unowned self] object in
                switch object.position {
                case at(11, y: 15):
                    assertObjectQuestGuard(
                        expected: .init(
                            kind: .returnWithResources(.init(resources: [.init(kind: .gold, quantity: 50605)])!),
                            messages: .init(
                                proposalMessage: "The guards here will let no one pass unless they have enough gold to buy the castle.  They will let you pass for 50637 gold pieces.",
                                progressMessage: "Since you have not brought 50605 Gold, the guards forbid your passage.",
                                completionMessage: "Congratulations!  This exquisite castle is yours if you pay the price of 50605 gold.  Do you wish to buy it?"
                            )
                        ),
                        actual: object
                    )
                case at(13, y: 14):
                    if object.objectID.stripped == .town {
                        assertObjectTown(
                            expected: .init(
                                id: .fromMapFile(1353886176),
                                faction: .castle,
                                buildings: .custom(
                                    .init(
                                        built: [
                                            .townHall, .cityHall, .capitol,
                                            .fort, .citadel, .castle,
                                            .tavern,
                                            .blacksmith,
                                            .marketplace, .resourceSilo,
                                            .mageGuildLevel1, .mageGuildLevel2, .mageGuildLevel3, .mageGuildLevel4,
                                            .grail, .special2, .special3,
                                            .dwelling1, .upgradedDwelling1, .dwelling2, .upgradedDwelling2,
                                            .dwelling3, .upgradedDwelling3, .horde3,
                                            .dwelling4,. upgradedDwelling4,
                                            .dwelling5, .upgradedDwelling5,
                                            .dwelling6, .upgradedDwelling6,
                                            .dwelling7, .upgradedDwelling7
                                        ],
                                        forbidden: []
                                    )
                                )
                            ),
                            actual: object
                            
                        )
                    } else if object.objectID.stripped == .trees2 {
                        fulfill(object: object)
                    } else {
                        XCTFail("Unexpected object: \(object)")
                    }
                    
                    
                default: break
                }
            },
            onParseEvents: { maybeEvents in
                guard let events = maybeEvents else {
                    XCTFail("Expected events")
                    return
                }
                XCTAssertEqual(events.count, 5)
               let e0 =
                    Map.TimedEvent(
                        name: "Intro",
                        message: "A rich lord has put his beautiful castle up for sale.  He has plans of ruling bigger lands and wants to get out of this tiny place.  He is asking 50637 gold pieces.  The castle is fully built.  The word is out all over the land: the first hero to bring the lord the proper amount of gold gets the castle.  There is one catch: you cannot lose your home town.",
                        firstOccurence: 1-1,
                        subsequentOccurence: .never,
                        affectedPlayers: [1, 2, 3],
                        appliesToHumanPlayers: true,
                        appliesToComputerPlayers: false
                    )
                    let e1 = Map.TimedEvent(
                        name: "Thieves amuck",
                        message: "There are rumors spreading around of a mad band of thieves roaming the area stealing gold and killing those who don't give it up.  You order you troops to keep an eye out for anything suspicious.",
                        firstOccurence: 5-1, subsequentOccurence: .never,
                        affectedPlayers: [1, 2, 3],
                        appliesToHumanPlayers: true,
                        appliesToComputerPlayers: false
                    )
                let e2 = Map.TimedEvent(
                        name: "Thieves kill",
                        message: "A messenger delivers you terrible news.  The rumor about the band of thieves is true.  They attacked and killed an entire army last night, getting away with 15037 gold!  A cold chill runs down your spine as you have a moment of silence for the deceased.  You send home a message to have more battle-ready troops available for you to hire.  In the meantime, have them stand guard around the kingdom night and day, ready for any surprise attacks.",
                        firstOccurence: 13-1, subsequentOccurence: .never,
                        affectedPlayers: [1, 2, 3],
                        appliesToHumanPlayers: true,
                        appliesToComputerPlayers: false
                    )
                let e3 = Map.TimedEvent(
                        name: "Stole 5037 gold",
                        message: "The thieves ransacked your camp and got away with 5037 gold pieces.  Fortunately, they killed no one.  But losing that gold really hurt your towns' treasury.",
                        firstOccurence: 20-1, subsequentOccurence: .never,
                        affectedPlayers: [1, 2, 3],
                        appliesToHumanPlayers: true,
                        appliesToComputerPlayers: true,
                        resources: .init(resources: [.init(kind: .gold, quantity: -5000)])
                    )
                let e4 = Map.TimedEvent(
                        name: "Thieves strike again",
                        message: "Thieves have struck your town again.  There must be a way to stop these outlaws!",
                        firstOccurence: 40-1, subsequentOccurence: .everySevenDays,
                        affectedPlayers: [1, 2, 3],
                        appliesToHumanPlayers: true,
                        appliesToComputerPlayers: true,
                        resources: .init(resources: [.init(kind: .gold, quantity: -4237)])
                    )
                
                // Make sure that we sort events according to occurence, because they are sorted in the order they where added otherwise (it seems).
                XCTAssertEqual(events, [e0, e1, e2, e3, e4])
            }
        )
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
        waitForExpectations(timeout: 1)
    }
}
