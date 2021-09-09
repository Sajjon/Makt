//
//  MythAndLegendTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
@testable import HoMM3SwiftUI

final class MythAndLegendTests: BaseMapTest {
    func test_mythAndLegend() throws {
        let mapID: Map.ID = .mythAndLegend
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector()
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
//        waitForExpectations(timeout: 1)
    }
}

//func test_assert_can_load_map_by_id__mythAndLegend() throws {
//    // Delete any earlier cached maps.
//    Map.loader.cache.__deleteMap(by: .mythAndLegend)
//    let map = try Map.load(.mythAndLegend)
//    XCTAssertEqual(map.about.summary.fileName, "Myth and Legend.h3m")
//    XCTAssertEqual(map.about.summary.name, "Myth and Legend")
//    XCTAssertEqual(map.about.summary.description, "You are a God.  Scaring mortals, granting wishes and generally mucking about Greece has been great fun, but with all fun it eventually turns to boredom.  Fortunately Autolycus has provided you and the other gods with some amusement.  He has stolen the Titan's Cuirass and you must find it first.")
//    XCTAssertEqual(map.about.summary.fileSizeCompressed, 123_343)
//    XCTAssertEqual(map.about.summary.fileSize, 520_208)
//    XCTAssertTrue(map.about.summary.hasTwoLevels)
//    XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
//    XCTAssertEqual(map.about.summary.difficulty, .normal)
//    XCTAssertEqual(map.about.summary.size, .extraLarge)
//    XCTAssertEqual(map.about.playersInfo.players.count, 8)
//
//    XCTAssertTrue(map.about.playersInfo.players.prefix(3).allSatisfy({ $0.isPlayableOnlyByAI }))
//    XCTAssertTrue(map.about.playersInfo.players.suffix(5).allSatisfy({ $0.isPlayableBothByHumanAndAI }))
//
//    XCTAssertEqual(map.about.playersInfo.players[0].townTypes, [.castle])
//    XCTAssertEqual(map.about.playersInfo.players[1].townTypes, [.dungeon])
//    XCTAssertEqual(map.about.playersInfo.players[2].townTypes, [.inferno])
//    XCTAssertEqual(map.about.playersInfo.players[3].townTypes, [.castle])
//    XCTAssertEqual(map.about.playersInfo.players[4].townTypes, [.rampart])
//    XCTAssertEqual(map.about.playersInfo.players[5].townTypes, [.dungeon])
//    XCTAssertEqual(map.about.playersInfo.players[6].townTypes, [.tower])
//    XCTAssertEqual(map.about.playersInfo.players[7].townTypes, [.rampart])
//
//    XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.acquireSpecificArtifact, .standard])
//    XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
//}
