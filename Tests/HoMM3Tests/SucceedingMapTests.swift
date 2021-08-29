//
//  SucceedingMapTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-27.
//

import XCTest
import Foundation
@testable import HoMM3SwiftUI

extension Map.BasicInformation {
    var fileName: String { id.fileName }
}

extension Map.InformationAboutPlayers.PlayerInfo {
    
    var isPlayableByHuman: Bool { basic.isPlayableByHuman }
    var isPlayableByAI: Bool { basic.isPlayableByAI }
    
    var isPlayableBothByHumanAndAI: Bool { isPlayableByHuman && isPlayableByAI }
    var isPlayableOnlyByAI: Bool { !isPlayableByHuman && isPlayableByAI }
}


final class MapTests: XCTestCase {
    
    func test_assert_can_load_map_by_id__unholy_quest() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .unholyQuest)
        let map = try Map.load(.unholyQuest)
        XCTAssertEqual(map.basicInformation.fileName, "Unholy Quest.h3m")
        XCTAssertEqual(map.basicInformation.name, "Unholy Quest")
        XCTAssertEqual(map.basicInformation.description, "Deep below the surface lurk monsters the likes of which no one has ever seen. Word is that the monsters are preparing to rise from the depths and lay claim to the surface world. Go forth and slay their evil armies before they grow too large. You may be the world's only hope!")
        XCTAssertEqual(map.basicInformation.fileSizeCompressed, 53_956 )
        XCTAssertEqual(map.basicInformation.fileSize, 349_615)
        XCTAssertEqual(map.basicInformation.hasTwoLevels, true)
        XCTAssertEqual(map.basicInformation.format, .restorationOfErathia)
        XCTAssertEqual(map.basicInformation.difficulty, .hard)
        XCTAssertEqual(map.basicInformation.size, .extraLarge)
        XCTAssertEqual(map.playersInfo.players.count, 2)
        XCTAssertEqual(map.playersInfo.players.map { $0.color }, [.red, .blue])
        XCTAssertEqual(map.playersInfo.players[0].isPlayableOnlyByAI, true)
        XCTAssertEqual(map.playersInfo.players[1].isPlayableBothByHumanAndAI, true)
        
        XCTAssertEqual(map.playersInfo.players[0].basic.playableFactions, [.inferno])
        XCTAssertEqual(map.playersInfo.players[1].basic.playableFactions, [.castle])
        
        XCTAssertEqual(map.additionalInformation.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.defeatSpecificHero])
        XCTAssertEqual(map.additionalInformation.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.loseSpecificHero, .standard])
        
    }
    
    
    func test_assert_can_load_map_by_id__taleOfTwoLands_allies() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .taleOfTwoLandsAllies)
        let map = try Map.load(.taleOfTwoLandsAllies)
        XCTAssertEqual(map.basicInformation.fileName, "Tale of two lands (Allies).h3m")
        XCTAssertEqual(map.basicInformation.name, "Tale of Two Lands (Allies)")
        XCTAssertEqual(map.basicInformation.description, "The continents of East and West Varesburg have decided to wage war one last time.  Securing the resources of your continent (with help from your ally) and then moving onto the other as quickly as possible is the best stategy for the battle of the Varesburgs.")
        XCTAssertEqual(map.basicInformation.fileSizeCompressed, 73_233)
        XCTAssertEqual(map.basicInformation.fileSize, 400_340)
        XCTAssertTrue(map.basicInformation.hasTwoLevels)
        XCTAssertEqual(map.basicInformation.format, .armageddonsBlade)
        XCTAssertEqual(map.basicInformation.difficulty, .normal)
        XCTAssertEqual(map.basicInformation.size, .extraLarge)
        XCTAssertEqual(map.playersInfo.players.count, 4)
       
        XCTAssertTrue(map.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))
        
        XCTAssertTrue(map.playersInfo.players.allSatisfy({ $0.basic.playableFactions == Faction.playable(in: .restorationOfErathia) }))

        XCTAssertEqual(map.additionalInformation.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.standard])
        XCTAssertEqual(map.additionalInformation.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
        
        XCTAssertEqual(map.additionalInformation.teamInfo.teams?.count, 2)
        XCTAssertEqual(map.additionalInformation.teamInfo, [[.red, .blue], [.tan, .green]])
    }
}
