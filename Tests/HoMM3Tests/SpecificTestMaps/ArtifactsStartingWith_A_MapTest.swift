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
    
    func testnEabledArtifacts() throws {
//        try doTestEnabledArtifacts(expected: [.admiralHat, .ambassadorsSash, .amuletOfTheUndertaker, .angelFeatherArrows, .angelWings, .angelicAlliance, .armageddonsBlade, .armorOfTheDamned, .armorOfWonder, .armsOfLegion])
    }
}
