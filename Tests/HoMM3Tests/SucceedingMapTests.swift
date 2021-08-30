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
        
        let expectationOnParseFormatCalled = expectation(description: "onParseFormat")
        let expectationOnParseName = expectation(description: "onParseName")
        let expectationOnParseDescription = expectation(description: "onParseDescription")
        let expectationOnParseDifficulty = expectation(description: "onParseDifficuly")
        let expectationOnParseSize = expectation(description: "onParseSize")
        let expectationOnFinishedParsingBasicInfo = expectation(description: "onFinishedParsingBasicInfo")
        let expectationPlayerBasicRed = expectation(description: "PlayerBasicRed")
        let expectationPlayerBasicBlue = expectation(description: "PlayerBasicBlue")
        let expectationPlayerExtraRed = expectation(description: "PlayerExtraRed")
        let expectationPlayerExtraBlue = expectation(description: "PlayerExtraBlue")
        let expectationVictoryConditions = expectation(description: "VictoryConditions")
        let expectationLossConditions = expectation(description: "LossConditions")
        //       let expectation = expectation(description: "")
        
        let basicInfoInspector = Map.Loader.Parser.Inspector.BasicInfoInspector(
            onParseFormat: { format in
                XCTAssertEqual(format, .restorationOfErathia)
                expectationOnParseFormatCalled.fulfill()
            }, onParseName: { name in
                XCTAssertEqual(name, "Unholy Quest")
                expectationOnParseName.fulfill()
            }, onParseDescription: { description in
                XCTAssertEqual(description, "Deep below the surface lurk monsters the likes of which no one has ever seen. Word is that the monsters are preparing to rise from the depths and lay claim to the surface world. Go forth and slay their evil armies before they grow too large. You may be the world's only hope!")
                expectationOnParseDescription.fulfill()
            }, onParseDifficulty: { difficulty in
                XCTAssertEqual(difficulty, .hard)
                expectationOnParseDifficulty.fulfill()
            }, onParseSize: { size in
                XCTAssertEqual(size, .extraLarge)
                expectationOnParseSize.fulfill()
            }, onFinishedParsingBasicInfo: { basicInfo in
                XCTAssertEqual(basicInfo.fileName, "Unholy Quest.h3m")
                XCTAssertEqual(basicInfo.fileSizeCompressed, 53_956 )
                XCTAssertEqual(basicInfo.fileSize, 349_615)
                XCTAssertTrue(basicInfo.hasTwoLevels)
                expectationOnFinishedParsingBasicInfo.fulfill()
            }
        )
        
        let playersInfoInspector = Map.Loader.Parser.Inspector.PlayersInfoInspector(onParseROEBasic: { basic, color in
            switch color {
            case .red:
                expectationPlayerBasicRed.fulfill()
                XCTAssertTrue(basic.isPlayableOnlyByAI)
                XCTAssertEqual(basic.playableFactions, [.inferno])
            case .blue:
                expectationPlayerBasicBlue.fulfill()
                XCTAssertTrue(basic.isPlayableBothByHumanAndAI)
                XCTAssertEqual(basic.playableFactions, [.castle])
            default: XCTFail("Expected only players Red and Blue, but got: \(color)")
            }
        },
        onParseROEExtra: { extra, color in
            switch color {
            case .red:
                expectationPlayerExtraRed.fulfill()
                break
            case .blue:
                expectationPlayerExtraBlue.fulfill()
                break
            default: XCTFail("Expected only players Red and Blue, but got: \(color)")
            }
        }
        )
        
        let victoryLossInspector = Map.Loader.Parser.Inspector.AdditionalInfoInspector.VictoryLossInspector(
            onParseVictoryConditions: { victoryConditions in
                XCTAssertEqual(victoryConditions.map { $0.kind.stripped }, [.defeatSpecificHero])
                expectationVictoryConditions.fulfill()
            },
            onParseLossConditions: { lossConditions in
                XCTAssertEqual(lossConditions.map { $0.kind.stripped }, [.loseSpecificHero, .standard])
                expectationLossConditions.fulfill()
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
        
        waitForExpectations(timeout: 1)
    }
    
    
    func test_assert_can_load_map_by_id__taleOfTwoLands_allies() throws {
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
        
        let playersInfoInspector = Map.Loader.Parser.Inspector.PlayersInfoInspector(onParseROEBasic: { basic, color in
            switch color {
            case .red, .blue, .tan, .green:
                XCTAssertTrue(basic.isPlayableBothByHumanAndAI)
                XCTAssertEqual(basic.playableFactions, Faction.playable(in: .restorationOfErathia))
            default: XCTFail("Expected only players Red, Blue, Tan, Green, but got: \(color)")
            }
            
        })
        
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
            onParseAvailableHeroes: nil,
            onParseTeamInfo: { teamInfo in
                XCTAssertEqual(teamInfo, [[.red, .blue], [.tan, .green]])
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
}
