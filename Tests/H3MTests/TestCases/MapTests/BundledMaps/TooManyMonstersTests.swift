//
//  TooManyMonstersTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class TooManyMonstersTests: BaseMapTest {
    func test_tooManyMonsters() throws {
        let mapID: Map.ID = .tooManyMonsters
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector()
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
//        waitForExpectations(timeout: 1)
    }
}

//func test_assert_small_map_tooManyMonsters() throws {
//    let map = try Map.load(.tooManyMonsters)
//    XCTAssertEqual(map.about.summary.fileName, "Too Many Monsters.h3m")
//    XCTAssertEqual(map.about.summary.fileSizeCompressed, 7_569)
//    XCTAssertEqual(map.about.summary.fileSize, 1)
//}
