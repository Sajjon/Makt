//
//  TitansWinterTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class TitansWinterTests: BaseMapTest {
    func test_titansWinter() throws {
        let mapID: Map.ID = .titansWinter
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector()
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
//        waitForExpectations(timeout: 1)
    }
}
//func test_assert_can_load_map_by_id__titans_winter() throws {
//    // Delete any earlier cached maps.
//    Map.loader.cache .__deleteMap(by: .titansWinter)
//    let map = try Map.load(.titansWinter)
//    XCTAssertEqual(map.about.summary.fileName, "Titans Winter.h3m")
//    XCTAssertEqual(map.about.summary.name, "Titan's Winter")
//    XCTAssertEqual(map.about.summary.description, "A terrible earthquake has torn apart the land.  Many different factions have arisen.  Now is the time for you to reunite the Kingdom, but this time under YOUR banner! ")
//    XCTAssertEqual(map.about.summary.fileSizeCompressed, 30374)
//    XCTAssertEqual(map.about.summary.fileSize, 149258)
//    XCTAssertEqual(map.about.summary.hasTwoLevels, false)
//    XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
//    XCTAssertEqual(map.about.summary.difficulty, .hard)
//    XCTAssertEqual(map.about.summary.size, .large)
//    XCTAssertEqual(map.about.playersInfo.players.count, 6)
//    XCTAssertEqual(map.about.playersInfo.players.map { $0.player }, [.playerOne, .playerTwo, .playerThree, .playerFour, .playerFive, .playerSix])
//    XCTAssertEqual(map.about.playersInfo.players[0].isPlayableBothByHumanAndAI, true)
//    XCTAssertEqual(map.about.playersInfo.players[1].isPlayableBothByHumanAndAI, true)
//    XCTAssertEqual(map.about.playersInfo.players[2].isPlayableBothByHumanAndAI, true)
//
//    XCTAssertEqual(map.about.playersInfo.players[0].townTypes, [.tower])
//    XCTAssertEqual(map.about.playersInfo.players[1].townTypes, [.tower])
//    XCTAssertEqual(map.about.playersInfo.players[2].townTypes, [.tower])
//    XCTAssertEqual(map.about.playersInfo.players[3].townTypes, [.stronghold])
//    XCTAssertEqual(map.about.playersInfo.players[4].townTypes, [.dungeon])
//    XCTAssertEqual(map.about.playersInfo.players[5].townTypes, [.castle])
//
//    XCTAssertEqual(map.about.victoryLossConditions.victoryConditions, [.standard])
//    XCTAssertEqual(map.about.victoryLossConditions.lossConditions, [.standard])
//}


