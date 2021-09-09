//
//  ReclamationAlliesTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
@testable import HoMM3SwiftUI

final class ReclamationAlliesTests: BaseMapTest {
    func test_reclamationAllies() throws {
        let mapID: Map.ID = .reclamationAllies
        Map.loader.cache.__deleteMap(by: mapID)
        let inspector = Map.Loader.Parser.Inspector()
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
//        waitForExpectations(timeout: 1)
    }
}


//func test_assert_can_load_map_by_id__reclamation_allies() throws {
//    // Delete any earlier cached maps.
//    Map.loader.cache.__deleteMap(by: .reclamationAllies)
//    let map = try Map.load(.reclamationAllies)
//    XCTAssertEqual(map.about.summary.fileName, "Reclamation Allied.h3m")
//    XCTAssertEqual(map.about.summary.name, "Reclamation (Allies)")
//    XCTAssertEqual(map.about.summary.description, "Eons ago, three nations were defeated by invaders and driven from their ancestral lands.  The victorious nation has since split into several smaller kingdoms. Now, the ancient peoples of the land are returning to seize back their homelands.  However, you refuse to let them take back what you own.")
//    XCTAssertEqual(map.about.summary.fileSizeCompressed, 53_450)
//    XCTAssertEqual(map.about.summary.fileSize, 247_360)
//    XCTAssertFalse(map.about.summary.hasTwoLevels)
//    XCTAssertEqual(map.about.summary.format, .shadowOfDeath)
//    XCTAssertEqual(map.about.summary.difficulty, .normal)
//    XCTAssertEqual(map.about.summary.size, .extraLarge)
//    XCTAssertEqual(map.about.playersInfo.players.count, 7)
//
//    XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))
//
//    XCTAssertTrue(map.about.playersInfo.players.allSatisfy({ $0.townTypes == Faction.playable(in: .shadowOfDeath) }))
//
//    XCTAssertEqual(map.about.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.standard])
//    XCTAssertEqual(map.about.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
//
//    XCTAssertEqual(map.about.teamInfo.teams?.count, 3)
//    XCTAssertEqual(map.about.teamInfo, [[.playerOne, .playerThree], [.playerTwo, .playerSeven], [.playerFour, .playerFive, .playerSix]])
//}
