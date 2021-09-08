//
//  TaleOfTwoLandsTest.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-08.
//

import Foundation
import XCTest
@testable import HoMM3SwiftUI

final class TaleOfTwoLandsTest: BaseMapTest {
    
    func test_taleOfTwoLands_allies() throws {
        // Delete any earlier cached maps.
        let mapID: Map.ID = .taleOfTwoLandsAllies
        Map.loader.cache.__deleteMap(by: mapID)
 
        let basicInfoInspector = Map.Loader.Parser.Inspector.BasicInfoInspector(
            onParseFormat: { format in
                XCTAssertEqual(format, .armageddonsBlade)
            }, onParseName: { name in
                XCTAssertEqual(name, "Tale of Two Lands (Allies)")
            }, onParseDescription: { description in
                XCTAssertEqual(description, "The continents of East and West Varesburg have decided to wage war one last time.  Securing the resources of your continent (with help from your ally) and then moving onto the other as quickly as possible is the best stategy for the battle of the Varesburgs.")
            }, onParseDifficulty: { difficulty in
                XCTAssertEqual(difficulty, .normal)
            }, onParseSize: { size in
                XCTAssertEqual(size, .extraLarge)
            }, onFinishedParsingBasicInfo: { basicInfo in
                XCTAssertEqual(basicInfo.fileName, "Tale of two lands (Allies).h3m")
                XCTAssertEqual(basicInfo.fileSizeCompressed, 73_233)
                XCTAssertEqual(basicInfo.fileSize, 400_340)
                XCTAssertTrue(basicInfo.hasTwoLevels)
            }
        )
        
        let playersInfoInspector = Map.Loader.Parser.Inspector.PlayersInfoInspector(
            onParseIsPlayableByHuman: nil,
            onParseIsPlayableByAI: nil,
            onParseBehaviour: nil,
            onParseTownTypes: nil,
            onParseHasMainTown: nil,
            onParseMainTown: nil
        )
        
        let victoryLossInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector.VictoryLossInspector(
            onParseVictoryConditions: { victoryConditions in
                XCTAssertEqual(victoryConditions.map { $0.kind.stripped }, [.standard])
            },
            onParseLossConditions: { lossConditions in
                XCTAssertEqual(lossConditions.map { $0.kind.stripped }, [.standard])
            }
        )
        
        let additionalInfoInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector(
            victoryLossInspector: victoryLossInspector,
            onParseTeamInfo: { teamInfo in
                XCTAssertEqual(teamInfo, [[.playerOne, .playerTwo], [.playerThree, .playerFour]])
            },
            onParseAvailableHeroes: { availableHeroes in
                XCTArraysEqual(availableHeroes.heroIDs, Hero.ID.restorationOfErathiaPlusConflux)
            },
            onParseCustomHeroes: {
                XCTAssertNil($0)
            },
            onParseAvailableArtifacts: { availableArtifacts in
                guard let actualArtifacts = availableArtifacts?.artifactIDs.values else {
                    XCTFail("Expected artifacts")
                    return
                }
                var allButTwo = Artifact.ID.available(in: .armageddonsBlade)
                allButTwo.removeAll(where: { $0 == .vialOfDragonBlood })
                allButTwo.removeAll(where: { $0 == .armageddonsBlade })
                XCTArraysEqual(allButTwo, actualArtifacts)
            },
            onParseAvailableSpells: { XCTAssertNil($0) },
            onParseAvailableSecondarySkills: { XCTAssertNil($0) },
            onParseRumors: {  XCTAssertTrue($0.rumors.isEmpty) },
            onParseHeroSettings: { XCTAssertTrue($0.settingsForHeroes.isEmpty) }
        )
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: basicInfoInspector,
            playersInfoInspector: playersInfoInspector,
            additionalInformationInspector: additionalInfoInspector
        )
        
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
    }
    
}
