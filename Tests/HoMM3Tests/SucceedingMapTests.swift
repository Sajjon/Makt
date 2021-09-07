//
//  SucceedingMapTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-27.
//

import XCTest
import Foundation
@testable import HoMM3SwiftUI
    
protocol FromPlayerColor: Equatable, RawRepresentable where RawValue == UInt8 {
    init?(playerColor: PlayerColor)
}

extension FromPlayerColor {
    init?(playerColor: PlayerColor) {
        self.init(rawValue: playerColor.rawValue)
    }
}

func XCTArraysEqual<S: Sequence>(_ lhsArray: S, _ rhsArray: S, file: StaticString = #file, line: UInt = #line) where S.Element: Hashable {
    let lhs = Set(lhsArray)
    let rhs = Set(rhsArray)
    if lhs != rhs {
        let diff = lhs.symmetricDifference(rhs)
        let lhsOnly = lhs.subtracting(rhs)
        let rhsOnly = rhs.subtracting(lhs)
        
        let lhsOnlyString = lhsOnly.isEmpty ? "" : "The following elements were found only in LHS sequence: \(lhsOnly)"
        let rhsOnlyString = rhsOnly.isEmpty ? "" : "The following elements were found only in RHS sequence: \(rhsOnly)"
        
        XCTAssertTrue(
            diff.isEmpty,
            ["Expected sequences to contain same elements, but they did not.", lhsOnlyString, rhsOnlyString].joined(separator: "\n"),
            file: file, line: line
        )
        
    } else {
        XCTAssert(true, "Ignoring order, the arrays equal each other.", file: file, line: line)
    }
}
enum TwoPlayer: UInt8, FromPlayerColor {
    case red, blue
}

enum ThreePlayer: UInt8, FromPlayerColor {
    case red, blue, tan
}

enum FivePlayer: UInt8, FromPlayerColor {
    case red, blue, tan, green, orange
}

enum SixPlayer: UInt8, FromPlayerColor {
    case red, blue, tan, green, orange, purple
}


func twoPlayer(_ player: PlayerColor) throws -> TwoPlayer {
    try XCTUnwrap(TwoPlayer(playerColor: player), "Expected only player Red and blue, but got: \(player)")
}

func threePlayers(_ player: PlayerColor) throws -> ThreePlayer {
    try XCTUnwrap(ThreePlayer(playerColor: player), "Expected only player Red, Blue and Tan, but got: \(player)")
}

func fivePlayers(_ player: PlayerColor) throws -> FivePlayer {
    try XCTUnwrap(FivePlayer(playerColor: player), "Expected only player Red, Blue, Tan, Green and Orange, but got: \(player)")
}

func sixPlayers(_ player: PlayerColor) throws -> SixPlayer {
    try XCTUnwrap(.init(playerColor: player), "Expected only player Red, Blue, Tan, Green, Orange and Purple, but got: \(player)")
}

extension Map.BasicInformation {
    var fileName: String { id.fileName }
}

final class MapTests: BaseMapTest {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func test_assert_can_load_map_by_id__unholy_quest() throws {
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
        let expectationPlayerRedAITactic = expectation(description: "RED AITactic")
        let expectationPlayerBlueAITactic = expectation(description: "BLUE AITactic")
        let expectationPlayerRedPlayableFactions = expectation(description: "RED PlayableFactions")
        let expectationPlayerBluePlayableFactions = expectation(description: "BLUE PlayableFactions")
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
                case .red: XCTAssertFalse(isPlayableByHuman); expectationPlayerRedCanBeHuman.fulfill()
                case .blue: XCTAssertTrue(isPlayableByHuman); expectationPlayerBlueCanBeHuman.fulfill()
                case .tan: XCTAssertFalse(isPlayableByHuman)
                }
            },
            onParseIsPlayableByAI:  { isPlayableByAI, player in
                switch try! threePlayers(player) {
                case .red: XCTAssertTrue(isPlayableByAI); expectationPlayerRedCanBeAI.fulfill()
                case .blue: XCTAssertTrue(isPlayableByAI); expectationPlayerBlueCanBeAI.fulfill()
                case .tan: XCTAssertFalse(isPlayableByAI)
                }
            },
            onParseAITactic: { aiTactic, player in
                switch try! twoPlayer(player) {
                case .red:
                    XCTAssertEqual(aiTactic, .builder) // found this expected value by opening this map in `Map Editor`
                    expectationPlayerRedAITactic.fulfill()
                case .blue:
                    XCTAssertEqual(aiTactic, .random) // found this expected value by opening this map in `Map Editor`
                    expectationPlayerBlueAITactic.fulfill()
                }
            },
            onParsePlayableFactions: { playableFactions, player in
                switch try! twoPlayer(player) {
                case .red:
                    XCTAssertEqual(playableFactions, [.inferno]) // found this expected value by opening this map in `Map Editor`
                    expectationPlayerRedPlayableFactions.fulfill()
                case .blue:
                    XCTAssertEqual(playableFactions, [.castle]) // found this expected value by opening this map in `Map Editor`
                    expectationPlayerBluePlayableFactions.fulfill()
                }
            },
            onParseHasMainTown: { hasMainTown, player in
                switch try! twoPlayer(player) {
                case .red:
                    XCTAssertFalse(hasMainTown) // found this expected value by opening this map in `Map Editor`
                    expectationPlayerRedHasMainTown.fulfill()
                case .blue:
                    XCTAssertFalse(hasMainTown)  // found this expected value by opening this map in `Map Editor`
                    expectationPlayerBlueHasMainTown.fulfill()
                }
            },
            onParseMainTown: { (maybeMainTown: Map.InformationAboutPlayers.PlayerInfo.MainTown?, player) in
                XCTAssertNil(maybeMainTown)
                switch try! twoPlayer(player) {
                case .red:
                    expectationPlayerRedMainTown.fulfill()
                case .blue:
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
                XCTAssertNil(teamInfo.teams)
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
            onParseRumors: {  XCTAssertTrue($0.rumors.isEmpty) },
            onParseHeroSettings: { XCTAssertTrue($0.settingsForHeroes.isEmpty) }
        )
            
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: basicInfoInspector,
            playersInfoInspector: playersInfoInspector,
            additionalInformationInspector: additionalInfoInspector,
            onParseObject: { [self] object in
                func assertEvent(expected: Map.GeoEvent, line: UInt = #line) {
                    XCTAssertEqual(object.objectID, .event)
                    guard case let .geoEvent(actual) = object.kind else {
                        XCTFail("expected event")
                        return
                    }
                    XCTAssertEqual(expected, actual, line: line)
                    fullfill(object: object)
                }
                
                func assertTown(expected: Map.Town, line: UInt = #line) {
                    XCTAssertEqual(object.objectID, .town(.castle))
                    guard case let .town(actual) = object.kind else {
                        XCTFail("expected town")
                        return
                    }
//                    XCTAssertEqual(expected, actual, line: line)
                    XCTAssertEqual(expected.name, actual.name, line: line)
                    XCTAssertEqual(expected.owner, actual.owner, line: line)
                    XCTAssertEqual(expected.faction, actual.faction, line: line)
                    XCTAssertEqual(expected.buildings, actual.buildings, line: line)
                    XCTAssertNil(actual.spells.obligatory, line: line)
                    XCTArraysEqual(expected.spells.possible, actual.spells.possible, line: line)
                    XCTAssertEqual(expected.garrison, actual.garrison, line: line)
                    fullfill(object: object)
                }
                
                switch object.position {
                case at(72, y: 66):
                    assertTown(
                        expected: .init(
                            id: .fromMapFile(1234),
                            faction: .castle,
                            owner: .blue,
                            buildings: .init(
                                built: [.fort],
                                forbidden: [.tavern]
                            ),
                            spells: .init(
                                possible: .init(
                                    values: Spell.ID.all(
                                        but: [.teleport, .waterWalk])
                                )
                            )
                        )
                    )
                default: break
                    
                    
                }
                
            }
        )
                
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
        
        waitForExpectations(timeout: 1)
    }
    
    func test_assert_can_load_map_by_id__taleOfTwoLands_allies() throws {
        // Delete any earlier cached maps.
        let mapID: Map.ID = .taleOfTwoLandsAllies
        Map.loader.cache.__deleteMap(by: mapID)
 
        let basicInfoInspector = Map.Loader.Parser.Inspector.BasicInfoInspector(
            onParseFormat: { format in
                XCTAssertEqual(format, .armageddonsBlade)
            }, onParseName: { name in
                XCTAssertEqual(name, "Tale of Two Lands (Allies)")
            }, onParseDescription: { description in
                XCTAssertEqual(description, "The continents of East and West Varesburg have decided to wage war one last time.  Securing the resources of your continent (with help from your ally) and then moving onto the other as quickly as possible is the best stategy for the battle of the Varesburgs.")
            }, onParseDifficulty: { difficulty in
                XCTAssertEqual(difficulty, .normal)
            }, onParseSize: { size in
                XCTAssertEqual(size, .extraLarge)
            }, onFinishedParsingBasicInfo: { basicInfo in
                XCTAssertEqual(basicInfo.fileName, "Tale of two lands (Allies).h3m")
                XCTAssertEqual(basicInfo.fileSizeCompressed, 73_233)
                XCTAssertEqual(basicInfo.fileSize, 400_340)
                XCTAssertTrue(basicInfo.hasTwoLevels)
            }
        )
        
        let playersInfoInspector = Map.Loader.Parser.Inspector.PlayersInfoInspector(
            onParseIsPlayableByHuman: nil,
            onParseIsPlayableByAI: nil,
            onParseAITactic: nil,
            onParsePlayableFactions: nil,
            onParseHasMainTown: nil,
            onParseMainTown: nil
        )
        
        let victoryLossInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector.VictoryLossInspector(
            onParseVictoryConditions: { victoryConditions in
                XCTAssertEqual(victoryConditions.map { $0.kind.stripped }, [.standard])
            },
            onParseLossConditions: { lossConditions in
                XCTAssertEqual(lossConditions.map { $0.kind.stripped }, [.standard])
            }
        )
        
        let additionalInfoInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector(
            victoryLossInspector: victoryLossInspector,
            onParseTeamInfo: { teamInfo in
                XCTAssertEqual(teamInfo, [[.red, .blue], [.tan, .green]])
            },
            onParseAvailableHeroes: { availableHeroes in
                XCTArraysEqual(availableHeroes.heroIDs, Hero.ID.restorationOfErathiaPlusConflux)
            },
            onParseCustomHeroes: {
                XCTAssertNil($0)
            },
            onParseAvailableArtifacts: { availableArtifacts in
                guard let actualArtifacts = availableArtifacts?.artifactIDs.values else {
                    XCTFail("Expected artifacts")
                    return
                }
                var allButTwo = Artifact.ID.available(in: .armageddonsBlade)
                allButTwo.removeAll(where: { $0 == .vialOfDragonBlood })
                allButTwo.removeAll(where: { $0 == .armageddonsBlade })
                XCTArraysEqual(allButTwo, actualArtifacts)
            },
            onParseAvailableSpells: { XCTAssertNil($0) },
            onParseAvailableSecondarySkills: { XCTAssertNil($0) },
            onParseRumors: {  XCTAssertTrue($0.rumors.isEmpty) },
            onParseHeroSettings: { XCTAssertTrue($0.settingsForHeroes.isEmpty) }
        )
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: basicInfoInspector,
            playersInfoInspector: playersInfoInspector,
            additionalInformationInspector: additionalInfoInspector
        )
        
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
    }
    
    func test_assert_can_load_map_by_id__raceForArdintinny() throws {
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
        
        var players: [PlayerColor]!

        let playersInfoInspector = Map.Loader.Parser.Inspector.PlayersInfoInspector(
            onParseIsPlayableByHuman: { isPlayableByHuman, player in
                switch try! sixPlayers(player) {
                case .purple: XCTAssertFalse(isPlayableByHuman)
                default: XCTAssertTrue(isPlayableByHuman)
                }
            },
            onParseIsPlayableByAI:  { isPlayableByAI, player in
                switch try! sixPlayers(player) {
                case .purple: XCTAssertFalse(isPlayableByAI)
                default: XCTAssertTrue(isPlayableByAI)
                }
            },
            onParseAITactic: { aiTactic, _ in
                XCTAssertEqual(aiTactic, .explorer) // found this expected value by opening this map in `Map Editor`
            },
            onParsePlayableFactions: { playableFactions, player in
                switch try! fivePlayers(player) {
                case .red:
                    XCTAssertEqual(playableFactions, [.castle]) // found this expected value by opening this map in `Map Editor`
                case .blue:
                    XCTAssertEqual(playableFactions, [.tower]) // found this expected value by opening this map in `Map Editor`
                case .tan:
                    XCTAssertEqual(playableFactions, [.inferno]) // found this expected value by opening this map in `Map Editor`
                case .green:
                    XCTAssertEqual(playableFactions, [.fortress]) // found this expected value by opening this map in `Map Editor`
                case .orange:
                    XCTAssertEqual(playableFactions, [.stronghold]) // found this expected value by opening this map in `Map Editor`
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
                XCTAssertNil(teamInfo.teams)
            },
            onParseAvailableHeroes: { availableHeroes in
//                XCTArraysEqual(availableHeroes.heroIDs, Hero.ID.playable(in: .restorationOfErathia))
            },
            onParseCustomHeroes: { XCTAssertNil($0) },
            onParseAvailableArtifacts: { XCTAssertNil($0) },
            onParseAvailableSpells: { XCTAssertNil($0) },
            onParseAvailableSecondarySkills: { XCTAssertNil($0) },
            onParseRumors: { rumorsList in
                let rumors = rumorsList.rumors
                XCTAssertEqual(rumors.count, 2)
                let rumor0 = rumors[0]
                XCTAssertEqual(rumor0.name, "Gates")
                XCTAssertEqual(rumor0.text, "There are two Gates to the Underworld.")
                
                let rumor1 = rumors[1]
                XCTAssertEqual(rumor1.name, "Island")
                XCTAssertEqual(rumor1.text, "An island only reachable by monolith is the way to Ardintinny.")
            },
            onParseHeroSettings: { XCTAssertTrue($0.settingsForHeroes.isEmpty) }
        )
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: basicInfoInspector,
            playersInfoInspector: playersInfoInspector,
            additionalInformationInspector: additionalInfoInspector,
            onParseWorld: { world in
                XCTAssertNotNil(world.belowGround)
//                print(world)
            },
            onParseObject: { [self] object in
                func assertEvent(expected: Map.GeoEvent, line: UInt = #line) {
                    XCTAssertEqual(object.objectID, .event)
                    guard case let .geoEvent(actual) = object.kind else {
                        XCTFail("expected event")
                        return
                    }
                    XCTAssertEqual(expected, actual, line: line)
                    fullfill(object: object)
                }
                
                func assertHeroOfKind(_ objectKind: Map.Object.ID, expected: Hero, line: UInt = #line) {
                    XCTAssertEqual(object.objectID, objectKind)
                    guard case let .hero(actual) = object.kind else {
                        XCTFail("expected hero")
                        return
                    }
                    XCTAssertEqual(expected, actual, line: line)
                    fullfill(object: object)
                }
                
                func assertPrisonHero(expected: Hero, line: UInt = #line) {
                    assertHeroOfKind(.prison, expected: expected, line: line)
                }
                
                func assertHero(`class`: Hero.Class, expected: Hero, line: UInt = #line) {
                    assertHeroOfKind(.hero(`class`), expected: expected, line: line)
                }
                
                switch object.position {
                case at(25, y: 65):
                    // Aha! The same tile might contain multiple objects!
                    if case .hero = object.kind {
                        assertHero(
                            class: .knight,
                            expected: Hero(
                                identifierKind: .specificHeroWithID(.sorsha),
                                owner: .red,
                                army: .init(stacks: [
                                    .init(creatureID: .halberdier, quantity: 30),
                                    .init(creatureID: .marksman, quantity: 15),
                                    .init(creatureID: .royalGriffin, quantity: 5)
                                ]),
                                artifactsInSlots: .init(values: [
                                    .init(
                                        slot: .backpack(.init(0)!),
                                        artifactID: .bowOfElvenCherrywood
                                    )
                                ])
                            )
                        )
                    } else if case let .resource(resource) = object.kind {
                        XCTAssertEqual(resource.resource.kind, .ore)
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
                            identifierKind: .specificHeroWithID(Hero.ID.christian)
                        )
                    )
                case at(87, y: 22):
                    assertEvent(
                        expected: .init(
                            message: "Your master always said, \"Before traversing into unknown areas it is wise to be well prepared for the possibility of long arduous battles.\" You have learned through experience that he was right. Maybe it is best to double check your troops, just in case.",
                            playersAllowedToTriggerThisEvent: [.blue]
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

extension Map.LossCondition.Kind {
    static func timeLimitMonths(_ monthCount: Int) -> Self { Self.timeLimit(dayCount: 7*4*monthCount) }
    static let timeLimit6Months: Self = .timeLimitMonths(6)
}
