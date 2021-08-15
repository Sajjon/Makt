//
//  Tests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-13.
//

import XCTest
@testable import HoMM3SwiftUI


final class LoadMapTests: XCTestCase {
    

    func test_assert_can_load_map_by_id__tutorial_map() throws {
        let map = try Map.load(.tutorial)
        XCTAssertEqual(map.about.fileName, "Tutorial.tut")
        XCTAssertEqual(map.about.fileSize, 6152)
    }
    
  
    func test_assert_can_load_map_by_id__titans_winter_map() throws {
        let map = try Map.load(.titansWinter)
        XCTAssertEqual(map.about.fileName, "Titans Winter.h3m")
        XCTAssertEqual(map.about.fileSize, 30374)
    }

    func test_assert_maps_are_lazy_loaded_and_cached() throws {
        let mapID: Map.ID = .titansWinter

        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: mapID)

        XCTAssertNil(Map.loader.cache.load(id: mapID))
        
        var start: DispatchTime
        var end: DispatchTime
        
        start = .now()
        let _ = try Map.load(mapID)
        end = .now()
        let timeNonCached = end.uptimeNanoseconds - start.uptimeNanoseconds
        
        start = .now()
        let _ = try Map.load(mapID) // Should find map in cache
        end = .now()
        let timeCached = end.uptimeNanoseconds - start.uptimeNanoseconds
        
        // Should be faster to load cached map.
        XCTAssertLessThan(timeCached, timeNonCached)
        
    }
}
