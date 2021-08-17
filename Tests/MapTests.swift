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
  
    func test_assert_can_load_map_by_id__titans_winter() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .titansWinter)
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
        
        XCTAssertEqual(map.victoryLossConditions.victoryConditions, [.standard])
        XCTAssertEqual(map.victoryLossConditions.lossConditions, [.standard])
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
    
    func test_assert_can_load_map_by_id__vikingWeShallGo() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .vikingWeShallGo)
        let map = try Map.load(.vikingWeShallGo)
        XCTAssertEqual(map.about.fileName, "A Viking We Shall Go.h3m")
        XCTAssertEqual(map.about.name, "Viking We Shall Go!")
        XCTAssertEqual(map.about.description,
            """
            The Place: Europe
            The Time: The Dark Ages
            Vikings have begun their raids while the kings of Europe take the opportunity to grab land from their neighbors.
            """)
        XCTAssertEqual(map.about.fileSizeCompressed, 47_404 )
        XCTAssertEqual(map.about.fileSize, 226_324)
        XCTAssertFalse(map.about.hasTwoLevels)
        XCTAssertEqual(map.about.format, .shadowOfDeath)
        XCTAssertEqual(map.about.difficulty, .normal)
        XCTAssertEqual(map.about.size, .extraLarge)
        XCTAssertEqual(map.playersInfo.players.count, 6)
     
        XCTAssertTrue(map.playersInfo.players.prefix(5).allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        XCTAssertTrue(map.playersInfo.players[5].isPlayableOnlyByAI)
        
        XCTAssertEqual(
            map.playersInfo.players.flatMap({ $0.allowedFactionsForThisPlayer }),
            [.stronghold, .necropolis, .castle, .rampart, .castle, .inferno]
        )
        
        XCTAssertEqual(map.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.standard])
        XCTAssertEqual(map.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }
    
    func test_assert_can_load_map_by_id__unholy_quest() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .unholyQuest)
        let map = try Map.load(.unholyQuest)
        XCTAssertEqual(map.about.fileName, "Unholy Quest.h3m")
        XCTAssertEqual(map.about.name, "Unholy Quest")
        XCTAssertEqual(map.about.description, "Deep below the surface lurk monsters the likes of which no one has ever seen. Word is that the monsters are preparing to rise from the depths and lay claim to the surface world. Go forth and slay their evil armies before they grow too large. You may be the world's only hope!")
        XCTAssertEqual(map.about.fileSizeCompressed, 53_956 )
        XCTAssertEqual(map.about.fileSize, 349_615)
        XCTAssertEqual(map.about.hasTwoLevels, true)
        XCTAssertEqual(map.about.format, .restorationOfErathia)
        XCTAssertEqual(map.about.difficulty, .hard)
        XCTAssertEqual(map.about.size, .extraLarge)
        XCTAssertEqual(map.playersInfo.players.count, 2)
        XCTAssertEqual(map.playersInfo.players.map { $0.color }, [.red, .blue])
        XCTAssertEqual(map.playersInfo.players[0].isPlayableOnlyByAI, true)
        XCTAssertEqual(map.playersInfo.players[1].isPlayableBothByHumanAndAI, true)
        
        XCTAssertEqual(map.playersInfo.players[0].allowedFactionsForThisPlayer, [.inferno])
        XCTAssertEqual(map.playersInfo.players[1].allowedFactionsForThisPlayer, [.castle])
   
        
        XCTAssertEqual(map.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.defeatSpecificHero])
        XCTAssertEqual(map.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.loseSpecificHero])
    }
}
