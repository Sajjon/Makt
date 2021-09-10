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
        let inspector = Map.Loader.Parser.Inspector()
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
//        waitForExpectations(timeout: 1)
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
//            XCTAssertNil(world.belowGround)
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
