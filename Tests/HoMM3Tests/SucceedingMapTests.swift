//
//  SucceedingMapTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-27.
//

import XCTest
import Foundation
@testable import HoMM3SwiftUI

final class MapTests: XCTestCase {
    
    func test_assert_can_load_map_by_id__unholy_quest() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .unholyQuest)
        let map = try Map.load(.unholyQuest)
        XCTAssertEqual(map.about.summary.fileName, "Unholy Quest.h3m")
        XCTAssertEqual(map.about.summary.name, "Unholy Quest")
        XCTAssertEqual(map.about.summary.description, "Deep below the surface lurk monsters the likes of which no one has ever seen. Word is that the monsters are preparing to rise from the depths and lay claim to the surface world. Go forth and slay their evil armies before they grow too large. You may be the world's only hope!")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 53_956 )
        XCTAssertEqual(map.about.summary.fileSize, 349_615)
        XCTAssertEqual(map.about.summary.hasTwoLevels, true)
        XCTAssertEqual(map.about.summary.format, .restorationOfErathia)
        XCTAssertEqual(map.about.summary.difficulty, .hard)
        XCTAssertEqual(map.about.summary.size, .extraLarge)
        XCTAssertEqual(map.about.playersInfo.players.count, 2)
        XCTAssertEqual(map.about.playersInfo.players.map { $0.color }, [.red, .blue])
        XCTAssertEqual(map.about.playersInfo.players[0].isPlayableOnlyByAI, true)
        XCTAssertEqual(map.about.playersInfo.players[1].isPlayableBothByHumanAndAI, true)
        
        XCTAssertEqual(map.about.playersInfo.players[0].allowedFactionsForThisPlayer, [.inferno])
        XCTAssertEqual(map.about.playersInfo.players[1].allowedFactionsForThisPlayer, [.castle])
        
        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.defeatSpecificHero])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.loseSpecificHero, .standard])
        
    }
    
    
    func test_assert_can_load_map_by_id__taleOfTwoLands_allies() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .taleOfTwoLandsAllies)
        let map = try Map.load(.taleOfTwoLandsAllies)
        XCTAssertEqual(map.about.summary.fileName, "Tale of two lands (Allies).h3m")
        XCTAssertEqual(map.about.summary.name, "Tale of Two Lands (Allies)")
        XCTAssertEqual(map.about.summary.description, "The continents of East and West Varesburg have decided to wage war one last time.  Securing the resources of your continent (with help from your ally) and then moving onto the other as quickly as possible is the best stategy for the battle of the Varesburgs.")
        XCTAssertEqual(map.about.summary.fileSizeCompressed, 73_233)
        XCTAssertEqual(map.about.summary.fileSize, 400_340)
        XCTAssertTrue(map.about.summary.hasTwoLevels)
        XCTAssertEqual(map.about.summary.format, .armageddonsBlade)
        XCTAssertEqual(map.about.summary.difficulty, .normal)
        XCTAssertEqual(map.about.summary.size, .extraLarge)
        XCTAssertEqual(map.about.playersInfo.players.count, 4)
       
        XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        
        XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.allowedFactionsForThisPlayer == Faction.playable(in: .restorationOfErathia) }))

        XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.standard])
        XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
        
        XCTAssertEqual(map.about.teamInfo.teams?.count, 2)
        XCTAssertEqual(map.about.teamInfo, [[.red, .blue], [.tan, .green]])
    }
}
