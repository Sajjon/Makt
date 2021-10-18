//
//  UnholyQuest.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-08.
//

import Foundation
import XCTest
@testable import Malm
@testable import H3M

final class UnholyQuestMapTest: BaseMapTest {
    
    func test_unholy_quest() throws {
        // Delete any earlier cached maps.
        let mapID: Map.ID = .unholyQuest
        Map.loader.cache.__deleteMap(by: mapID)
        
        let expectationOnParseFormatCalled = expectation(description: "onParseFormat")
        let expectationOnParseName = expectation(description: "onParseName")
        let expectationOnParseDescription = expectation(description: "onParseDescription")
        let expectationOnParseDifficulty = expectation(description: "onParseDifficuly")
        let expectationOnParseSize = expectation(description: "onParseSize")
        let expectationOnFinishedParsingBasicInfo = expectation(description: "onFinishedParsingBasicInfo")
        let expectationPlayerRedCanBeHuman = expectation(description: "Player Red CanBeHuman")
        let expectationPlayerBlueCanBeHuman = expectation(description: "Player Blue CanBeHuman")
        let expectationPlayerRedCanBeAI = expectation(description: "Player Red CanBeAI")
        let expectationPlayerBlueCanBeAI = expectation(description: "Player Blue CanBeAI")
        let expectationVictoryConditions = expectation(description: "VictoryConditions")
        let expectationLossConditions = expectation(description: "LossConditions")
        let expectationPlayerRedBehaviour = expectation(description: "RED Behaviour")
        let expectationPlayerBlueBehaviour = expectation(description: "BLUE Behaviour")
        let expectationPlayerRedTownTypes = expectation(description: "RED TownTypes")
        let expectationPlayerBlueTownTypes = expectation(description: "BLUE TownTypes")
        let expectationPlayerRedHasMainTown = expectation(description: "RED hasMainTown")
        let expectationPlayerBlueHasMainTown = expectation(description: "BLUE hasMainTown")
        let expectationPlayerRedMainTown = expectation(description: "RED maintown")
        let expectationPlayerBlueMainTown = expectation(description: "BLUE maintown")
        
        let basicInfoInspector = Map.Loader.Parser.Inspector.BasicInfoInspector(
            onParseFormat: { format in
                XCTAssertEqual(format, .restorationOfErathia)
                expectationOnParseFormatCalled.fulfill()
            }, onParseName: { name in
                XCTAssertEqual(name, "Unholy Quest")
                expectationOnParseName.fulfill()
            }, onParseDescription: { description in
                XCTAssertEqual(description, "Deep below the surface lurk monsters the likes of which no one has ever seen. Word is that the monsters are preparing to rise from the depths and lay claim to the surface world. Go forth and slay their evil armies before they grow too large. You may be the world's only hope!")
                expectationOnParseDescription.fulfill()
            }, onParseDifficulty: { difficulty in
                XCTAssertEqual(difficulty, .hard)
                expectationOnParseDifficulty.fulfill()
            }, onParseSize: { size in
                XCTAssertEqual(size, .extraLarge)
                expectationOnParseSize.fulfill()
            }, onFinishedParsingBasicInfo: { basicInfo in
                XCTAssertEqual(basicInfo.fileName, "Unholy Quest.h3m")
                XCTAssertEqual(basicInfo.fileSizeCompressed, 53_956 )
                XCTAssertEqual(basicInfo.fileSize, 349_615)
                XCTAssertTrue(basicInfo.hasTwoLevels)
                expectationOnFinishedParsingBasicInfo.fulfill()
            }
        )
        
        let playersInfoInspector = Map.Loader.Parser.Inspector.PlayersInfoInspector(
            onParseIsPlayableByHuman: { isPlayableByHuman, player in
                switch try! threePlayers(player) {
                case .playerOne: XCTAssertFalse(isPlayableByHuman); expectationPlayerRedCanBeHuman.fulfill()
                case .playerTwo: XCTAssertTrue(isPlayableByHuman); expectationPlayerBlueCanBeHuman.fulfill()
                case .playerThree: XCTAssertFalse(isPlayableByHuman)
                }
            },
            onParseIsPlayableByAI:  { isPlayableByAI, player in
                switch try! threePlayers(player) {
                case .playerOne: XCTAssertTrue(isPlayableByAI); expectationPlayerRedCanBeAI.fulfill()
                case .playerTwo: XCTAssertTrue(isPlayableByAI); expectationPlayerBlueCanBeAI.fulfill()
                case .playerThree: XCTAssertFalse(isPlayableByAI)
                }
            },
            onParseBehaviour: { behaviour, player in
                switch try! twoPlayer(player) {
                case .playerOne:
                    XCTAssertEqual(behaviour, .builder) // found this expected value by opening this map in `Map Editor`
                    expectationPlayerRedBehaviour.fulfill()
                case .playerTwo:
                    XCTAssertEqual(behaviour, .random) // found this expected value by opening this map in `Map Editor`
                    expectationPlayerBlueBehaviour.fulfill()
                }
            },
            onParseTownTypes: { townTypes, player in
                switch try! twoPlayer(player) {
                case .playerOne:
                    XCTAssertEqual(townTypes, [.inferno]) // found this expected value by opening this map in `Map Editor`
                    expectationPlayerRedTownTypes.fulfill()
                case .playerTwo:
                    XCTAssertEqual(townTypes, [.castle]) // found this expected value by opening this map in `Map Editor`
                    expectationPlayerBlueTownTypes.fulfill()
                }
            },
            onParseHasMainTown: { hasMainTown, player in
                switch try! twoPlayer(player) {
                case .playerOne:
                    XCTAssertFalse(hasMainTown) // found this expected value by opening this map in `Map Editor`
                    expectationPlayerRedHasMainTown.fulfill()
                case .playerTwo:
                    XCTAssertFalse(hasMainTown)  // found this expected value by opening this map in `Map Editor`
                    expectationPlayerBlueHasMainTown.fulfill()
                }
            },
            onParseMainTown: { (maybeMainTown: Map.InformationAboutPlayers.PlayerInfo.MainTown?, player) in
                XCTAssertNil(maybeMainTown)
                switch try! twoPlayer(player) {
                case .playerOne:
                    expectationPlayerRedMainTown.fulfill()
                case .playerTwo:
                    expectationPlayerBlueMainTown.fulfill()
                }
            }
        )
        
        let victoryLossInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector.VictoryLossInspector(
            onParseVictoryConditions: { victoryConditions in
                XCTAssertEqual(
                    victoryConditions.map { $0.kind },
                    // found this expected value by opening this map in `Map Editor`
                    [.defeatSpecificHero(locatedAt: .init(column: 88, row: 34, inUnderworld: true))]
                )
                expectationVictoryConditions.fulfill()
            },
            onParseLossConditions: { lossConditions in
                XCTAssertEqual(lossConditions.map { $0.kind }, [.loseSpecificHero(locatedAt: .init(column: 71, row: 67, inUnderworld: false)), .standard])
                expectationLossConditions.fulfill()
            }
        )
        
        let expectationAvailableHeroes = expectation(description: "Available Heroes")
        let expectationTeamInfo = expectation(description: "TeamInfo")
        let expectationCustomHeroes = expectation(description: "Custom heroes")
        
        let additionalInfoInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector(
            victoryLossInspector: victoryLossInspector,
            onParseTeamInfo: { teamInfo in
                XCTAssertEqual(teamInfo, .noTeams)
                expectationTeamInfo.fulfill()
            },
            onParseAvailableHeroes: { availableHeroes in
//                XCTArraysEqual(availableHeroes.heroIDs, Hero.ID.playable(in: .restorationOfErathia))
                expectationAvailableHeroes.fulfill()
            },
            onParseCustomHeroes: {
                XCTAssertNil($0)
                expectationCustomHeroes.fulfill()
            },
            onParseAvailableArtifacts: { XCTAssertNil($0) },
            onParseAvailableSpells: { XCTAssertNil($0) },
            onParseAvailableSecondarySkills: { XCTAssertNil($0) },
            onParseRumors: {  XCTAssertNil($0) },
            onParseHeroSettings: { XCTAssertTrue($0.isEmpty) }
        )
            
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: basicInfoInspector,
            playersInfoInspector: playersInfoInspector,
            additionalInformationInspector: additionalInfoInspector,
            onParseObject: { [unowned self] object in
               
                func assertTown(expected: Map.Town, line: UInt = #line) {
                    assertObjectTown(expected: expected, actual: object, line: line)
                }
                
                switch object.position {
                case at(72, y: 66):
                    assertTown(
                        expected: .init(
                            id: .position(.init(x: 72, y: 66, inUnderworld: false)),
                            faction: .castle,
                            owner: .playerTwo,
                            buildings: .custom(.init(
                                built: [.fort],
                                forbidden: [.tavern]
                            )),
                            spells: .init(
                                possible: .init(
                                    values: Spell.ID.all(
                                        but: [.teleport, .waterWalk])
                                )
                            ),
                            alignment: nil
                        )
                    )
                case at(90, y: 33, inUnderworld: true):
                    assertTown(
                        expected: .init(
                            id: .position(.init(x: 90, y: 33, inUnderworld: true)),
                            faction: .inferno,
                            owner: .playerOne,
                            buildings: .custom(.init(
                                built: [.fort],
                                forbidden: [.tavern]
                            )),
                            spells: .init(
                                possible: .init(
                                    values: Spell.ID.all(but: [.protectionFromWater, .summonBoat, .viewAir, .lightningBolt, .protectionFromAir, .airShield, .chainLightning, .meteorShower, .townPortal, .waterWalk, .dimensionDoor, .fly])
                                )
                            ),
                            alignment: nil
                        )
                    )
                    
                case at(67, y: 90, inUnderworld: true):
                    assertObjectMonster(
                        expected: .init(
                            .specific(creatureID: .angel),
                            quantity: .specified(1),
                            message: "Shame on you! Don't follow the sulfur, follow the gems to your salvation!",
                            disposition: .compliant,
                            mightFlee: false,
                            growsInNumbers: false
                        ), actual: object
                    )
                default: break
                    
                    
                }
                
            }
        )
                
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
        
        waitForExpectations(timeout: 1)
    }

    
    func testJSONRoundtrip() throws {
        let mapID: Map.ID = .unholyQuest
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
        
        XCTAssertLessThan(timeJson, timeBinary)
        
        try jsonData.write(to: FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("\(mapFromBinary.basicInformation.name).json"))
        
        print(String(format: "timeBinary: %.3f seconds", timeBinary))
        print(String(format: "timeJson: %.3f seconds", timeJson))
        
        let mapConverter = MapConverter(
            outputURL: FileManager.default.homeDirectoryForCurrentUser,
            jsonEncoder: jsonEncoder
        )
        let scenario = try mapConverter.convert(map: mapFromBinary)
        XCTAssertEqual(scenario.info.summary.name, mapFromBinary.basicInformation.name)
        
    }
}
