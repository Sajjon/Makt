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


extension Array {
    
    @discardableResult
    func when<Member>(
        keyPath: KeyPath<Element, Member>,
        is expectedMemberValue: Member,
        closure: (Element) throws -> Void
    ) rethrows -> Index? where Member: RawRepresentable, Member: Equatable {
        guard let elementIndex = firstIndex(where: {
            let member = $0[keyPath: keyPath]
            return member == expectedMemberValue
        }) else { return nil }
        let element = self[elementIndex]
        try closure(element)
        return elementIndex
    }
}

final class MapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func test_assert_can_load_map_by_id__unholy_quest() throws {
        // Delete any earlier cached maps.
        let mapID: Map.ID = .unholyQuest
        Map.loader.cache.__deleteMap(by: mapID)
        
 
        let basicInfoInspector = Map.Loader.Parser.Inspector.BasicInfoInspector(
            onParseFormat: { format in
                XCTAssertEqual(format, .restorationOfErathia)
            }, onParseName: { name in
                XCTAssertEqual(name, "Unholy Quest")
            }, onParseDescription: { description in
                XCTAssertEqual(description, "Deep below the surface lurk monsters the likes of which no one has ever seen. Word is that the monsters are preparing to rise from the depths and lay claim to the surface world. Go forth and slay their evil armies before they grow too large. You may be the world's only hope!")
            }, onParseDifficulty: { difficulty in
                XCTAssertEqual(difficulty, .hard)
            }, onParseSize: { size in
                XCTAssertEqual(size, .extraLarge)
            }, onFinishedParsingBasicInfo: { basicInfo in
                XCTAssertEqual(basicInfo.fileName, "Unholy Quest.h3m")
                XCTAssertEqual(basicInfo.fileSizeCompressed, 53_956 )
                XCTAssertEqual(basicInfo.fileSize, 349_615)
                XCTAssertEqual(basicInfo.hasTwoLevels, true)
            }
        )
        
        let playersInfoInspector = Map.Loader.Parser.Inspector.PlayersInfoInspector(onParseROEBasic: { basic, color in
            switch color {
            case .red:
                XCTAssertTrue(basic.isPlayableOnlyByAI)
                XCTAssertEqual(basic.playableFactions, [.inferno])
            case .blue:
                XCTAssertTrue(basic.isPlayableBothByHumanAndAI)
                XCTAssertEqual(basic.playableFactions, [.castle])
            default: XCTFail("Expected only players Red and Blue, but got: \(color)")
            }
            
        })
        
        let victoryLossInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector.VictoryLossInspector(
            onParseVictoryConditions: { victoryConditions in
                XCTAssertEqual(victoryConditions.map { $0.kind.stripped }, [.defeatSpecificHero])
            },
            onParseLossConditions: { lossConditions in
                XCTAssertEqual(lossConditions.map { $0.kind.stripped }, [.loseSpecificHero, .standard])
            }
        )
        
        let additionalInfoInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector(
            victoryLossInspector: victoryLossInspector,
            onParseAvailableHeroes: nil,
            onParseTeamInfo: { teamInfo in
                XCTAssertNil(teamInfo.teams)
            },
            onParseCustomHeroes: nil,
            onParseAvailableArtifacts: nil,
            onParseAvailableSpells: nil,
            onParseAvailableSecondarySkills: nil,
            onParseRumors: nil,
            onParseHeroSettings: nil
        )
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: basicInfoInspector,
            playersInfoInspector: playersInfoInspector,
            additionalInformationInspector: additionalInfoInspector
        )
        
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
    }
    
    
//    func test_assert_can_load_map_by_id__taleOfTwoLands_allies() throws {
//        // Delete any earlier cached maps.
//        Map.loader.cache.__deleteMap(by: .taleOfTwoLandsAllies)
//        let map = try Map.load(.taleOfTwoLandsAllies)
//        XCTAssertEqual(basicInfo.fileName, "Tale of two lands (Allies).h3m")
//        XCTAssertEqual(basicInfo.format, .armageddonsBlade)
//        XCTAssertEqual(basicInfo.name, "Tale of Two Lands (Allies)")
//        XCTAssertEqual(basicInfo.description, "The continents of East and West Varesburg have decided to wage war one last time.  Securing the resources of your continent (with help from your ally) and then moving onto the other as quickly as possible is the best stategy for the battle of the Varesburgs.")
//        XCTAssertEqual(basicInfo.fileSizeCompressed, 73_233)
//        XCTAssertEqual(basicInfo.fileSize, 400_340)
//        XCTAssertTrue(basicInfo.hasTwoLevels)
//        XCTAssertEqual(basicInfo.format, .armageddonsBlade)
//        XCTAssertEqual(basicInfo.difficulty, .normal)
//        XCTAssertEqual(basicInfo.size, .extraLarge)
//        XCTAssertEqual(map.playersInfo.players.count, 4)
//
//        XCTAssertTrue(map.playersInfo.players.allSatisfy({ $0.isPlayableBothByHumanAndAI }))
//
//        XCTAssertTrue(map.playersInfo.players.allSatisfy({ $0.playableFactions == Faction.playable(in: .restorationOfErathia) }))
//
//        XCTAssertEqual(map.additionalInformation.victoryLossConditions.victoryConditions.map { $0.kind.stripped }, [.standard])
//        XCTAssertEqual(map.additionalInformation.victoryLossConditions.lossConditions.map { $0.kind.stripped }, [.standard])
//
//        XCTAssertEqual(map.additionalInformation.teamInfo.teams?.count, 2)
//        XCTAssertEqual(map.additionalInformation.teamInfo, [[.red, .blue], [.tan, .green]])
//    }
}
