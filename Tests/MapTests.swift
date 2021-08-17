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
        XCTAssertEqual(map.about.fileSizeCompressed, 6_152)
        XCTAssertEqual(map.about.fileSize, 27_972)
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
    
    
    func test_assert_can_load_map_by_id__mandateOfHeaven() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .theMandateOfHeaven)
        let map = try Map.load(.theMandateOfHeaven)
        XCTAssertEqual(map.about.fileName, "The Mandate of Heaven.h3m")
        XCTAssertEqual(map.about.name, "The Mandate of Heaven")
        XCTAssertEqual(map.about.description, "Devils have invaded and it is up to you to win back the Mandate of Heaven for the faltering Ironfist Dynasty")
        XCTAssertEqual(map.about.fileSizeCompressed, 70_517 )
        XCTAssertEqual(map.about.fileSize, 399_506)
        XCTAssertTrue(map.about.hasTwoLevels)
        XCTAssertEqual(map.about.format, .restorationOfErathia)
        XCTAssertEqual(map.about.difficulty, .expert)
        XCTAssertEqual(map.about.size, .extraLarge)
        XCTAssertEqual(map.playersInfo.players.count, 5)
       
        XCTAssertTrue(map.playersInfo.players[0].isPlayableBothByHumanAndAI)
        XCTAssertTrue(map.playersInfo.players.suffix(4).allSatisfy({ $0.isPlayableOnlyByAI }))
        
        XCTAssertEqual(map.playersInfo.players[0].allowedFactionsForThisPlayer, [.castle])
        XCTAssertEqual(map.playersInfo.players[1].allowedFactionsForThisPlayer, [.necropolis])
        XCTAssertEqual(map.playersInfo.players[2].allowedFactionsForThisPlayer, [.inferno])
        XCTAssertEqual(map.playersInfo.players[3].allowedFactionsForThisPlayer, [.dungeon])
        XCTAssertEqual(map.playersInfo.players[4].allowedFactionsForThisPlayer, [.dungeon])
        
        XCTAssertFalse(map.playersInfo.players[2].hasRandomHero)
        XCTAssertEqual(map.playersInfo.players[2].customMainHero?.name, "The Queen")
        XCTAssertEqual(map.playersInfo.players[2].customMainHero?.portraitId, .calid)
        
        XCTAssertEqual(map.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.captureSpecificTown])
        XCTAssertEqual(map.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }
    
    func test_assert_can_load_map_by_id__rebellion() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .rebellion)
        let map = try Map.load(.rebellion)
        XCTAssertEqual(map.about.fileName, "Rebellion.h3m")
        XCTAssertEqual(map.about.name, "Rebellion")
        XCTAssertEqual(map.about.description, "The peasants are revolting, just when you need them to fight a war.  The only hope for peace lies in finding the Grail.")
        XCTAssertEqual(map.about.fileSizeCompressed, 18_107)
        XCTAssertEqual(map.about.fileSize, 81_093)
        XCTAssertFalse(map.about.hasTwoLevels)
        XCTAssertEqual(map.about.format, .restorationOfErathia)
        XCTAssertEqual(map.about.difficulty, .normal)
        XCTAssertEqual(map.about.size, .medium)
        XCTAssertEqual(map.playersInfo.players.count, 3)
       
        XCTAssertTrue(map.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        
        XCTAssertEqual(map.playersInfo.players[0].allowedFactionsForThisPlayer, Faction.playable(in: .restorationOfErathia))
        XCTAssertEqual(map.playersInfo.players[1].allowedFactionsForThisPlayer, [.inferno])
        XCTAssertEqual(map.playersInfo.players[2].allowedFactionsForThisPlayer, [.stronghold])
        
        XCTAssertEqual(map.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.buildGrailBuilding, .standard])
        XCTAssertEqual(map.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }
    
    func test_assert_can_load_map_by_id__noahsArk() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .noahsArk)
        let map = try Map.load(.noahsArk)
        XCTAssertEqual(map.about.fileName, "Noahs Ark.h3m")
        XCTAssertEqual(map.about.name, "Noah's Ark")
        XCTAssertEqual(map.about.description, "The great flood is coming, and only by controlling two of every creature dwelling can you hope to survive.")
        XCTAssertEqual(map.about.fileSizeCompressed, 38_907)
        XCTAssertEqual(map.about.fileSize, 222_532)
        XCTAssertTrue(map.about.hasTwoLevels)
        XCTAssertEqual(map.about.format, .restorationOfErathia)
        XCTAssertEqual(map.about.difficulty, .normal)
        XCTAssertEqual(map.about.size, .large)
        XCTAssertEqual(map.playersInfo.players.count, 3)
       
        XCTAssertTrue(map.playersInfo.players.prefix(2).allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        XCTAssertTrue(map.playersInfo.players[2].isPlayableOnlyByAI)
        
        XCTAssertEqual(map.playersInfo.players[0].allowedFactionsForThisPlayer, Faction.playable(in: .restorationOfErathia))
        XCTAssertEqual(map.playersInfo.players[1].allowedFactionsForThisPlayer, Faction.playable(in: .restorationOfErathia))
        XCTAssertEqual(map.playersInfo.players[2].allowedFactionsForThisPlayer, Faction.playable(in: .restorationOfErathia))
        
        XCTAssertEqual(map.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.flagAllCreatureDwellings, .standard])
        XCTAssertEqual(map.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }
    
    func test_assert_can_load_map_by_id__overthrowThyNeighbour() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .overthrowThyNeighbour)
        let map = try Map.load(.overthrowThyNeighbour)
        XCTAssertEqual(map.about.fileName, "Overthrow Thy Neighbors.h3m")
        XCTAssertEqual(map.about.name, "Overthrow Thy Neighbors")
        XCTAssertEqual(map.about.description, "The good, the bad, and the over crowded.")
        XCTAssertEqual(map.about.fileSizeCompressed, 27_119)
        XCTAssertEqual(map.about.fileSize, 132_820)
        XCTAssertTrue(map.about.hasTwoLevels)
        XCTAssertEqual(map.about.format, .restorationOfErathia)
        XCTAssertEqual(map.about.difficulty, .normal)
        XCTAssertEqual(map.about.size, .medium)
        XCTAssertEqual(map.playersInfo.players.count, 3)
       
        XCTAssertTrue(map.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        
        XCTAssertEqual(map.playersInfo.players[0].allowedFactionsForThisPlayer, [.inferno])
        XCTAssertEqual(map.playersInfo.players[1].allowedFactionsForThisPlayer, [.stronghold])
        XCTAssertEqual(map.playersInfo.players[2].allowedFactionsForThisPlayer, [.castle])
        
        XCTAssertEqual(map.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.flagAllMines, .standard])
        XCTAssertEqual(map.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }
    
    func test_assert_can_load_map_by_id__mythAndLegend() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .mythAndLegend)
        let map = try Map.load(.mythAndLegend)
        XCTAssertEqual(map.about.fileName, "Myth and Legend.h3m")
        XCTAssertEqual(map.about.name, "Myth and Legend")
        XCTAssertEqual(map.about.description, "You are a God.  Scaring mortals, granting wishes and generally mucking about Greece has been great fun, but with all fun it eventually turns to boredom.  Fortunately Autolycus has provided you and the other gods with some amusement.  He has stolen the Titan's Cuirass and you must find it first.")
        XCTAssertEqual(map.about.fileSizeCompressed, 123_343)
        XCTAssertEqual(map.about.fileSize, 520_208)
        XCTAssertTrue(map.about.hasTwoLevels)
        XCTAssertEqual(map.about.format, .restorationOfErathia)
        XCTAssertEqual(map.about.difficulty, .normal)
        XCTAssertEqual(map.about.size, .extraLarge)
        XCTAssertEqual(map.playersInfo.players.count, 8)
       
        XCTAssertTrue(map.playersInfo.players.prefix(3).allSatisfy({ $0.isPlayableOnlyByAI }))
        XCTAssertTrue(map.playersInfo.players.suffix(5).allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        
        XCTAssertEqual(map.playersInfo.players[0].allowedFactionsForThisPlayer, [.castle])
        XCTAssertEqual(map.playersInfo.players[1].allowedFactionsForThisPlayer, [.dungeon])
        XCTAssertEqual(map.playersInfo.players[2].allowedFactionsForThisPlayer, [.inferno])
        XCTAssertEqual(map.playersInfo.players[3].allowedFactionsForThisPlayer, [.castle])
        XCTAssertEqual(map.playersInfo.players[4].allowedFactionsForThisPlayer, [.rampart])
        XCTAssertEqual(map.playersInfo.players[5].allowedFactionsForThisPlayer, [.dungeon])
        XCTAssertEqual(map.playersInfo.players[6].allowedFactionsForThisPlayer, [.tower])
        XCTAssertEqual(map.playersInfo.players[7].allowedFactionsForThisPlayer, [.rampart])
        
        XCTAssertEqual(map.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.acquireSpecificArtifact, .standard])
        XCTAssertEqual(map.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
    }
    
    func test_assert_can_load_map_by_id__raceForArdintinny() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .raceforArdintinny)
        let map = try Map.load(.raceforArdintinny)
        XCTAssertEqual(map.about.fileName, "Race for Ardintinny.h3m")
        XCTAssertEqual(map.about.name, "Race for Ardintinny")
        XCTAssertEqual(map.about.description, "You and four other lords covet Medallion Bay, a profitable trade route.  Before your opponents or before six months is up you must take control of Ardintinny, the town controlling Medallion Bay.")
        XCTAssertEqual(map.about.fileSizeCompressed, 65_306 )
        XCTAssertEqual(map.about.fileSize, 387_938)
        XCTAssertTrue(map.about.hasTwoLevels)
        XCTAssertEqual(map.about.format, .restorationOfErathia)
        XCTAssertEqual(map.about.difficulty, .normal)
        XCTAssertEqual(map.about.size, .extraLarge)
        XCTAssertEqual(map.playersInfo.players.count, 5)
       
        XCTAssertTrue(map.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        
        XCTAssertEqual(map.playersInfo.players[0].allowedFactionsForThisPlayer, [.castle])
        XCTAssertEqual(map.playersInfo.players[1].allowedFactionsForThisPlayer, [.tower])
        XCTAssertEqual(map.playersInfo.players[2].allowedFactionsForThisPlayer, [.inferno])
        XCTAssertEqual(map.playersInfo.players[3].allowedFactionsForThisPlayer, [.fortress])
        XCTAssertEqual(map.playersInfo.players[4].allowedFactionsForThisPlayer, [.stronghold])
        
        XCTAssertEqual(map.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.captureSpecificTown])
        XCTAssertEqual(map.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.timeLimit, .standard])
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
        XCTAssertEqual(map.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.loseSpecificHero, .standard])
    }
    
    func test_assert_can_load_map_by_id__taleOfTwoLands_allies() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .taleOfTwoLandsAllies)
        let map = try Map.load(.taleOfTwoLandsAllies)
        XCTAssertEqual(map.about.fileName, "Tale of two lands (Allies).h3m")
        XCTAssertEqual(map.about.name, "Tale of Two Lands (Allies)")
        XCTAssertEqual(map.about.description, "The continents of East and West Varesburg have decided to wage war one last time.  Securing the resources of your continent (with help from your ally) and then moving onto the other as quickly as possible is the best stategy for the battle of the Varesburgs.")
        XCTAssertEqual(map.about.fileSizeCompressed, 73_233)
        XCTAssertEqual(map.about.fileSize, 400_340)
        XCTAssertTrue(map.about.hasTwoLevels)
        XCTAssertEqual(map.about.format, .armageddonsBlade)
        XCTAssertEqual(map.about.difficulty, .normal)
        XCTAssertEqual(map.about.size, .extraLarge)
        XCTAssertEqual(map.playersInfo.players.count, 4)
       
        XCTAssertTrue(map.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        
        XCTAssertTrue(map.playersInfo.players.allSatisfy({ $0.allowedFactionsForThisPlayer == Faction.playable(in: .restorationOfErathia) }))

        XCTAssertEqual(map.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.standard])
        XCTAssertEqual(map.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
        
        XCTAssertEqual(map.teamInfo.teams?.count, 2)
        XCTAssertEqual(map.teamInfo, [[PlayerColor.red, .blue], [.tan, .green]])
    }
}
