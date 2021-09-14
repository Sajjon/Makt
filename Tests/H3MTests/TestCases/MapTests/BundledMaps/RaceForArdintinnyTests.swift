//
//  RaceForArdintinnyTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-27.
//

import XCTest
import Foundation
import Malm
@testable import H3M
    
final class RaceForArdintinnyTests: BaseMapTest {
    
    func test_raceForArdintinny() throws {
        // Delete any earlier cached maps.
        let mapID: Map.ID = .raceforArdintinny
        Map.loader.cache.__deleteMap(by: mapID)
        let basicInfoInspector = Map.Loader.Parser.Inspector.BasicInfoInspector(
            onParseFormat: { format in
                XCTAssertEqual(format, .restorationOfErathia)
            }, onParseName: { name in
                XCTAssertEqual(name, "Race for Ardintinny")
            }, onParseDescription: { description in
                XCTAssertEqual(description, "You and four other lords covet Medallion Bay, a profitable trade route.  Before your opponents or before six months is up you must take control of Ardintinny, the town controlling Medallion Bay.")
            }, onParseDifficulty: { difficulty in
                XCTAssertEqual(difficulty, .normal)
            }, onParseSize: { size in
                XCTAssertEqual(size, .extraLarge)
            }, onFinishedParsingBasicInfo: { basicInfo in
                XCTAssertEqual(basicInfo.fileName, "Race for Ardintinny.h3m")
                XCTAssertEqual(basicInfo.fileSizeCompressed, 65_306)
                XCTAssertEqual(basicInfo.fileSize, 387_938)
                XCTAssertTrue(basicInfo.hasTwoLevels)
            }
        )
        
        var players: [Player]!

        let playersInfoInspector = Map.Loader.Parser.Inspector.PlayersInfoInspector(
            onParseIsPlayableByHuman: { isPlayableByHuman, player in
                switch try! sixPlayers(player) {
                case .playerSix: XCTAssertFalse(isPlayableByHuman)
                default: XCTAssertTrue(isPlayableByHuman)
                }
            },
            onParseIsPlayableByAI:  { isPlayableByAI, player in
                switch try! sixPlayers(player) {
                case .playerSix: XCTAssertFalse(isPlayableByAI)
                default: XCTAssertTrue(isPlayableByAI)
                }
            },
            onParseBehaviour: { behaviour, _ in
                XCTAssertEqual(behaviour, .explorer) // found this expected value by opening this map in `Map Editor`
            },
            onParseTownTypes: { townTypes, player in
                switch try! fivePlayers(player) {
                case .playerOne:
                    XCTAssertEqual(townTypes, [.castle]) // found this expected value by opening this map in `Map Editor`
                case .playerTwo:
                    XCTAssertEqual(townTypes, [.tower]) // found this expected value by opening this map in `Map Editor`
                case .playerThree:
                    XCTAssertEqual(townTypes, [.inferno]) // found this expected value by opening this map in `Map Editor`
                case .playerFour:
                    XCTAssertEqual(townTypes, [.fortress]) // found this expected value by opening this map in `Map Editor`
                case .playerFive:
                    XCTAssertEqual(townTypes, [.stronghold]) // found this expected value by opening this map in `Map Editor`
                }
            },
            onParseHasMainTown: { hasMainTown, _ in
                XCTAssertFalse(hasMainTown)
            },
            onParseMainTown: { maybeMainTown, _ in
                XCTAssertNil(maybeMainTown)
            },
            onFinishParsingInformationAboutPlayers:  { informationAboutPlayers in
                players = informationAboutPlayers.availablePlayers
            }
        )
        
        let victoryLossInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector.VictoryLossInspector(
            onParseVictoryConditions: { victoryConditions in
                XCTAssertEqual(victoryConditions.map { $0.kind }, [.captureSpecificTown(locatedAt: .init(x: 84, y: 41, inUnderworld: false))])
            },
            onParseLossConditions: { lossConditions in
                XCTAssertEqual(lossConditions.map { $0.kind }, [.timeLimit6Months, .standard])
            }
        )
        
        let additionalInfoInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector(
            victoryLossInspector: victoryLossInspector,
            onParseTeamInfo: { teamInfo in
                XCTAssertEqual(teamInfo, .noTeams)
            },
            onParseAvailableHeroes: { availableHeroes in
//                XCTArraysEqual(availableHeroes.heroIDs, Hero.ID.playable(in: .restorationOfErathia))
            },
            onParseCustomHeroes: { XCTAssertNil($0) },
            onParseAvailableArtifacts: { XCTAssertNil($0) },
            onParseAvailableSpells: { XCTAssertNil($0) },
            onParseAvailableSecondarySkills: { XCTAssertNil($0) },
            onParseRumors: { rumors in
                XCTAssertEqual(rumors.count, 2)
                let rumor0 = rumors[0]
                XCTAssertEqual(rumor0.name, "Gates")
                XCTAssertEqual(rumor0.text, "There are two Gates to the Underworld.")
                
                let rumor1 = rumors[1]
                XCTAssertEqual(rumor1.name, "Island")
                XCTAssertEqual(rumor1.text, "An island only reachable by monolith is the way to Ardintinny.")
            },
            onParseHeroSettings: { XCTAssertTrue($0.isEmpty) }
        )
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: basicInfoInspector,
            playersInfoInspector: playersInfoInspector,
            additionalInformationInspector: additionalInfoInspector,
            onParseWorld: { world in
                XCTAssertNotNil(world.belowGround)
            },
            onParseObject: { [self] object in
                func assertEvent(expected: Map.GeoEvent, line: UInt = #line) {
                    assertObjectEvent(expected: expected, actual: object, line: line)
                }
                
                
                func assertPrisonHero(expected: Hero, line: UInt = #line) {
                    assertObjectPrisonHero(expected: expected, actual: object, line: line)
                }
                
                func assertHero(`class`: Hero.Class, expected: Hero, line: UInt = #line) {
                    assertObjectHero(class: `class`, expected: expected, actual: object, line: line)
                }
                
                switch object.position {
                case at(25, y: 65):
                    // Aha! The same tile might contain multiple objects!
                    if case .hero = object.kind {
                        assertHero(
                            class: .knight,
                            expected: Hero(
                                identifierKind: .specificHeroWithID(.sorsha),
                                owner: .playerOne,
                                army: .init(stacks: [
                                    .specific(id: .halberdier, quantity: 30),
                                    .specific(id: .marksman, quantity: 15),
                                    .specific(id: .royalGriffin, quantity: 5)
                                ]),
                                artifactsInSlots: .init(values: [
                                    .init(
                                        slot: .backpack(.init(0)!),
                                        artifactID: .bowOfElvenCherrywood
                                    )
                                ]),
                                gender: nil
                            )
                        )
                    } else if case let .resource(resource) = object.kind {
                        XCTAssertEqual(resource.kind, .specific(.ore))
                    } else {
                        XCTFail("Unexpected object")
                    }
                 
                case at(50, y: 28):
                    assertEvent(
                        expected: .init(
                            message: "Warming a freezing old woman she blesses you with good luck for your next battle.",
                            contents: .init(luckToBeGainedOrDrained: 1),
                            playersAllowedToTriggerThisEvent: players
                        )
                    )
                case at(83, y: 110):
                    assertPrisonHero(
                        expected: .init(
                            identifierKind: .specificHeroWithID(Hero.ID.christian),
                            gender: nil
                        )
                    )
                case at(87, y: 22):
                    assertEvent(
                        expected: .init(
                            message: "Your master always said, \"Before traversing into unknown areas it is wise to be well prepared for the possibility of long arduous battles.\" You have learned through experience that he was right. Maybe it is best to double check your troops, just in case.",
                            playersAllowedToTriggerThisEvent: [.playerTwo]
                        )
                    )
                case at(100, y: 60):
                    assertEvent(
                        expected: .init(
                            message: "Being so far from home causes your troops to miss their families.",
                            contents: .init(moraleToBeGainedOrDrained: -2),
                            playersAllowedToTriggerThisEvent: players
                        )
                    )
                default: break
                }
            }
        )
        
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
        waitForExpectations(timeout: 1)
    }
}

