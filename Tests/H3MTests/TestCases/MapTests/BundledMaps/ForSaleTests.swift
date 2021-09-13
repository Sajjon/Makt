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
            onParseObject: { [self] object in
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
            onParseEvents: { events in
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
