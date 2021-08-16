//
//  Tests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-13.
//

import XCTest
@testable import HoMM3SwiftUI

extension Map.PlayersInfo.PlayerInfo {
    var isPlayableBothByHumanAndAI: Bool { isPlayableByHuman && isPlayableByAI }
    var isPlayableOnlyByAI: Bool { !isPlayableByHuman && isPlayableByAI }
}

final class LoadMapTests: XCTestCase {
    

    func test_assert_can_load_map_by_id__tutorial_map() throws {
        let map = try Map.load(.tutorial)
        XCTAssertEqual(map.about.fileName, "Tutorial.tut")
        XCTAssertEqual(map.about.fileSizeCompressed, 6152)
        XCTAssertEqual(map.about.fileSize, 27972)
    }
  
    func test_assert_can_load_map_by_id__titans_winter_map() throws {
        let map = try Map.load(.titansWinter)
        XCTAssertEqual(map.about.fileName, "Titans Winter.h3m")
        XCTAssertEqual(map.about.name, "Titan's Winter")
        XCTAssertEqual(map.about.description, "A terrible earthquake has torn apart the land.  Many different factions have arisen.  Now is the time for you to reunite the Kingdom, but this time under YOUR banner! ")
        XCTAssertEqual(map.about.fileSizeCompressed, 30374)
        XCTAssertEqual(map.about.fileSize, 149258)
        XCTAssertEqual(map.about.hasTwoLevels, false)
        XCTAssertEqual(map.about.format, .restorationOfErathia)
        XCTAssertEqual(map.about.difficulty, .hard)
        XCTAssertEqual(map.about.size, .large)
        XCTAssertEqual(map.playersInfo.players.count, 6)
        XCTAssertEqual(map.playersInfo.players.map { $0.color }, [.red, .blue, .tan, .green, .orange, .purple])
        XCTAssertEqual(map.playersInfo.players[0].isPlayableBothByHumanAndAI, true)
        XCTAssertEqual(map.playersInfo.players[1].isPlayableBothByHumanAndAI, true)
        XCTAssertEqual(map.playersInfo.players[2].isPlayableBothByHumanAndAI, true)
        
        
        XCTAssertEqual(map.playersInfo.players[0].allowedFactionsForThisPlayer, [.tower])
        XCTAssertEqual(map.playersInfo.players[1].allowedFactionsForThisPlayer, [.tower])
        XCTAssertEqual(map.playersInfo.players[2].allowedFactionsForThisPlayer, [.tower])
        XCTAssertEqual(map.playersInfo.players[3].allowedFactionsForThisPlayer, [.stronghold])
        XCTAssertEqual(map.playersInfo.players[4].allowedFactionsForThisPlayer, [.dungeon])
        XCTAssertEqual(map.playersInfo.players[5].allowedFactionsForThisPlayer, [.castle])
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
