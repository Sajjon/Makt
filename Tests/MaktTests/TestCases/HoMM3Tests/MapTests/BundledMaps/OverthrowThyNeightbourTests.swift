//
//  OverthrowThyNeightbourTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
@testable import Makt

final class OverthrowThyNeighbourTests: BaseMapTest {
    func test_overthrowThyNeightbour() throws {
        let mapID: Map.ID = .overthrowThyNeighbour
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector()
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
//        waitForExpectations(timeout: 1)
    }
}

//func test_assert_can_load_map_by_id__overthrowThyNeighbour() throws {
//    // Delete any earlier cached maps.
//    Map.loader.cache.__deleteMap(by: .overthrowThyNeighbour)
//    let map = try Map.load(.overthrowThyNeighbour)
//    XCTAssertEqual(map.about.summary.fileName, "Overthrow Thy Neighbors.h3m")
//    XCTAssertEqual(map.about.summary.name, "Overthrow Thy Neighbors")
//    XCTAssertEqual(map.about.summary.description, "The good, the bad, and the over crowded.")
//    XCTAssertEqual(map.about.summary.fileSizeCompressed, 27_119)
//    XCTAssertEqual(map.about.summary.fileSize, 132_820)
//    XCTAssertTrue(map.about.summary.hasTwoLevels)
//    XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
//    XCTAssertEqual(map.about.summary.difficulty, .normal)
//    XCTAssertEqual(map.about.summary.size, .medium)
//    XCTAssertEqual(map.about.playersInfo.players.count, 3)
//
//    XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))
//
//    XCTAssertEqual(map.about.playersInfo.players[0].townTypes, [.inferno])
//    XCTAssertEqual(map.about.playersInfo.players[1].townTypes, [.stronghold])
//    XCTAssertEqual(map.about.playersInfo.players[2].townTypes, [.castle])
//
//    XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.flagAllMines, .standard])
//    XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
//}
