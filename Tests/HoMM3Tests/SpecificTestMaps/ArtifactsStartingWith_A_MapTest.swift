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
        let expArtifacts = expectation(description: "artifacts")
        try doTestAdidtionalInformation(
            onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
            onParseName: { XCTAssertEqual($0, self.mapName) },
            onParseAvailableArtifacts: { availableArtifacts in
                defer { expArtifacts.fulfill() }
                guard let actual = availableArtifacts?.artifacts else {
                    XCTFail("Expected available artifacts")
                    return
                }
                XCTAssertEqual(Set(actual), Set([.admiralHat, .ambassadorsSash, .amuletOfTheUndertaker, .angelFeatherArrows, .angelWings, .angelicAlliance, .armageddonsBlade, .armorOfTheDamned, .armorOfWonder, .armsOfLegion]))
            }
        )
    }
}
