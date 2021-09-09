//
//  KneeDeepInTheDeadTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
@testable import HoMM3SwiftUI

final class KneeDeepInTheDeadTests: BaseMapTest {
    func test_kneeDeapInTheDead() throws {
        let mapID: Map.ID = .kneeDeepInTheDead
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector()
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
//        waitForExpectations(timeout: 1)
    }
}

//func test_assert_small_map_kneeDeepInTheDead() throws {
//    let map = try Map.load(.kneeDeepInTheDead)
//    XCTAssertEqual(map.about.summary.fileName, "Knee Deep in the Dead.h3m")
//    XCTAssertEqual(map.about.summary.fileSizeCompressed, 6_909)
//    XCTAssertEqual(map.about.summary.fileSize, 1)
//}
