//
//  NoahsArkTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
@testable import HoMM3SwiftUI

final class NoahsArkTests: BaseMapTest {
    func test_noahsark() throws {
        let mapID: Map.ID = .noahsArk
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector()
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
//        waitForExpectations(timeout: 1)
    }
}

//func test_assert_can_load_map_by_id__noahsArk() throws {
//    // Delete any earlier cached maps.
//    Map.loader.cache.__deleteMap(by: .noahsArk)
//    let map = try Map.load(.noahsArk)
//    XCTAssertEqual(map.about.summary.fileName, "Noahs Ark.h3m")
//    XCTAssertEqual(map.about.summary.name, "Noah's Ark")
//    XCTAssertEqual(map.about.summary.description, "The great flood is coming, and only by controlling two of every creature dwelling can you hope to survive.")
//    XCTAssertEqual(map.about.summary.fileSizeCompressed, 38_907)
//    XCTAssertEqual(map.about.summary.fileSize, 222_532)
//    XCTAssertTrue(map.about.summary.hasTwoLevels)
//    XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
//    XCTAssertEqual(map.about.summary.difficulty, .normal)
//    XCTAssertEqual(map.about.summary.size, .large)
//    XCTAssertEqual(map.about.playersInfo.players.count, 3)
//
//    XCTAssertTrue(map.about.playersInfo.players.prefix(2).allSatisfy({ $0.isPlayableBothByHumanAndAI }))
//    XCTAssertTrue(map.about.playersInfo.players[2].isPlayableOnlyByAI)
//
//    XCTAssertEqual(map.about.playersInfo.players[0].townTypes, Faction.playable(in: .restorationOfErathia))
//    XCTAssertEqual(map.about.playersInfo.players[1].townTypes, Faction.playable(in: .restorationOfErathia))
//    XCTAssertEqual(map.about.playersInfo.players[2].townTypes, Faction.playable(in: .restorationOfErathia))
//
//    XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.flagAllCreatureDwellings, .standard])
//    XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
//}
