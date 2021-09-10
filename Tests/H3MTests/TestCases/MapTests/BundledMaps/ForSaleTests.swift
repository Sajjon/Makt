//
//  ForSaleTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class ForSaleTests: BaseMapTest {
    func test_forSale() throws {
        let mapID: Map.ID = .forSale
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector()
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
//        waitForExpectations(timeout: 1)
    }
}

//func test_assert_small_map_forSale() throws {
//    let map = try Map.load(.forSale)
//    XCTAssertEqual(map.about.summary.fileName, "For Sale.h3m")
//    XCTAssertEqual(map.about.summary.fileSizeCompressed, 8_434)
//    XCTAssertEqual(map.about.summary.fileSize, 1)
//}
