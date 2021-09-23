//
//  JudgementDayTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class JudgementDayTests: BaseMapTest {
    func test_judgementDay() throws {
        let mapID: Map.ID = .judgementDay
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .restorationOfErathia) },
                onParseName: { XCTAssertEqual($0, "Judgment Day") },
                onParseDescription: { XCTAssertEqual($0, "Legend has it that the fabled Sword of Judgment rests somewhere in these caverns.  Three Dungeon Overlords have vowed to find it, for he who controls the Sword, controls all.") } ,
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .small) }
            ),
            additionalInformationInspector: .init(
                victoryLossInspector: .init(
                    onParseVictoryConditions: {
                        XCTAssertEqual($0, [.init(kind: .acquireSpecificArtifact(.swordOfJudgement), appliesToAI: true), .standard])
                    }
                )
            ),
            onParseObject: { [self] object in
                switch object.position {
                case at(1, y: 16):
                    assertObjectArtifact(
                        expected: .init(
                            .specific(id: .swordOfJudgement),
                            message: "Placed on an altar made of pure obsidian lies a sword forged from the finest steel.  Do you wish to grasp its shimmering jeweled hilt?"
                        ),
                        actual: object)
                default: break
                }
            }
        )
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
        waitForExpectations(timeout: 1)
    }
}


//func test_assert_a_really_small_map_judgementDay() throws {
//
//
//
//    let inspector = Map.Loader.Parser.Inspector(
//        settings: .init(),
//        onParseAbout: { about in
//            let summary = about.summary
//
//            XCTAssertEqual(summary.fileName, "Judgement Day.h3m")
//            XCTAssertEqual(summary.fileSizeCompressed, 5_059)
//            XCTAssertEqual(summary.fileSize, 21201)
//            XCTAssertEqual(summary.format, .restorationOfErathia)
//        },
//        onParseDisposedHeroes: { disposedHeroes in
//            XCTAssertTrue(disposedHeroes.isEmpty)
//        },
//        onParseAllowedArtifacts: { allowedArtifacts in
//            XCTAssertEqual(allowedArtifacts, Artifact.ID.available(in: .restorationOfErathia))
//        },
//        onParseAllowedSpells: { allowedSpells in
//            XCTAssertEqual(allowedSpells, Spell.ID.allCases)
//        },
//        onParseAllowedHeroAbilities: { allowedSeconarySkills in
//            XCTAssertEqual(allowedSeconarySkills, Hero.SecondarySkill.Kind.allCases)
//        },
//        onParseRumors: { rumors in
//            XCTAssertTrue(rumors.isEmpty)
//        },
//        onParsePredefinedHeroes: { predefinedHeroes in
//            XCTAssertTrue(predefinedHeroes.isEmpty)
//        },
//        onParseWorld: { world in
//            XCTAssertNil(world.underground)
//            XCTAssertFalse(world.above.isUnderworld)
//            let tiles = world.above.tiles
//            XCTAssertEqual(tiles.count, 36*36)
//        },
//        onParseAttributes: { attributes in
//            XCTAssertEqual(attributes.attributes.count, 111)
//
//        },
//        onParseObject: { object in
//        })
//
//    do {
//        let _ = try Map.load(.judgementDay, inspector: inspector)
//    } catch {
//        // errors are ignored for now.
//    }
//}
