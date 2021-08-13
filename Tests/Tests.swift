//
//  Tests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-13.
//

import XCTest
import HoMM3SwiftUI

final class Tests: XCTestCase {

    func test_assert_can_create_ResourceAccessor_without_arguments() throws {
        XCTAssertNoThrow(try ResourceAccessor())
    }

    func test_assert_can_access_known_map_by_known_name() throws {
        let resourceLocator = try ResourceAccessor()
        let mapFile_tutorial = resourceLocator.map(named: .tutorial)
        XCTAssertEqual(mapFile_tutorial.fileName, "Tutorial.tut")
        XCTAssertEqual(mapFile_tutorial.fileSize, 6152)
    }
    
    func test_assert_can_access_known_map_by_known_name2() throws {
        let resourceLocator = try ResourceAccessor()
        let mapFile_tutorial = resourceLocator.map(named: .titansWinter)
        XCTAssertEqual(mapFile_tutorial.fileName, "Titans Winter.h3m")
        XCTAssertEqual(mapFile_tutorial.fileSize, 30374)
    }
}
