//
//  TutorialMapTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
@testable import Makt

final class TutorialMapTests: BaseMapTest {
    func test_tutorialMap() throws {
        let mapID: Map.ID = .tutorial
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector()
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
//        waitForExpectations(timeout: 1)
    }
}

//func test_assert_can_load_map_by_id__tutorial_map() throws {
//    let map = try Map.load(.tutorial)
//    XCTAssertEqual(map.about.summary.fileName, "Tutorial.tut")
//    XCTAssertEqual(map.about.summary.fileSizeCompressed, 6_152)
//    XCTAssertEqual(map.about.summary.fileSize, 27_972)
//}
