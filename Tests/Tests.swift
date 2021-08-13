//
//  Tests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-13.
//

import XCTest
import HoMM3SwiftUI

final class Tests: XCTestCase {

    func test_assert_can_create_config_without_arguments() throws {
        XCTAssertNoThrow(try Config())
    }

    func test_assert_can_read_known_map_by_known_name() throws {
        let config = try Config()
        let mapFile_tutorial = config.map(named: .tutorial)
        XCTAssertEqual(mapFile_tutorial.fileName, "Tutorial.tut")
        XCTAssertEqual(mapFile_tutorial.fileSize, 6152)
    }
    
    func test_assert_can_read_known_map_by_known_name2() throws {
        let config = try Config()
        let mapFile_tutorial = config.map(named: .titansWinter)
        XCTAssertEqual(mapFile_tutorial.fileName, "Titans Winter.h3m")
        XCTAssertEqual(mapFile_tutorial.fileSize, 30374)
    }
}
