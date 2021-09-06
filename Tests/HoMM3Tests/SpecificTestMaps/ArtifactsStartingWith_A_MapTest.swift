//
//  ArtifactsStartingWith_A_MapTest.swift
//  ArtifactsStartingWith_A_MapTest
//
//  Created by Alexander Cyon on 2021-09-04.
//

import Foundation
import XCTest
@testable import HoMM3SwiftUI

final class ArtifactsStartingWith_A_Tests: AdditionalInfoBaseTests {
    
    override var mapFileName: String { "cyon_sod_only_allows_artifacts_starting_with_letter_A" }
    override var mapName: String { "only_allows_artifacts_on_A" }
    
    func test() throws {
        let expCustomHeroes = expectation(description: "Custom Heroes")
        let expArtifacts = expectation(description: "artifacts")
        let expSpells = expectation(description: "spells")
        try doTestAdidtionalInformation(
            onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
            onParseName: { XCTAssertEqual($0, self.mapName) },
            onParseCustomHeroes: { customHeroes in
                defer { expCustomHeroes.fulfill() }
                guard let heroes = customHeroes?.customHeroes else {
                    XCTFail("Expected available artifacts")
                    return
                }
                XCTAssertEqual(heroes.count, 2)
                
                XCTAssertEqual(heroes[0].name, "MARKER START")
                XCTAssertEqual(heroes[0].heroId, .orrin)
                XCTAssertEqual(heroes[0].portraitID, .thane)
                
                XCTAssertEqual(heroes[1].name, "MARKER END")
                XCTAssertEqual(heroes[1].heroId, .grindan)
                XCTAssertEqual(heroes[1].portraitID, .dessa)
              
            },
            onParseAvailableArtifacts: { availableArtifacts in
                defer { expArtifacts.fulfill() }
                guard let actual = availableArtifacts?.artifacts else {
                    XCTFail("Expected available artifacts")
                    return
                }
                let defaultArtifacts: [Artifact.ID] = [.catapult, .spellBook, .ballista, .ammoCart, .grail, .firstAidTent, .spellScroll]
                XCTArraysEqual(actual.sorted(by: \.rawValue), Array(defaultArtifacts + [.admiralHat, .ambassadorsSash, .amuletOfTheUndertaker, .angelFeatherArrows, .angelWings, .angelicAlliance, .armageddonsBlade, .armorOfTheDamned, .armorOfWonder, .armsOfLegion]).sorted(by: \.rawValue))
            },
            onParseAvailableSpells: { availableSpells in
                defer { expSpells.fulfill() }
                guard let spells = availableSpells?.spells else {
                    XCTFail("Expected available artifacts")
                    return
                }
                XCTArraysEqual(spells, [.waterWalk, .airShield, .bless, .weakness, .titansLightningBolt, .waterElemental])
            }
        )
    }
}
