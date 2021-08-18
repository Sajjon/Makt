//
//  ArtifactIDTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation
import XCTest
import HoMM3SwiftUI

final class ArtifactIDTest: XCTestCase {
    
    private func doTest(artifactId: Artifact.ID, is rawValue: Artifact.ID.RawValue) {
        XCTAssertEqual(artifactId.rawValue, rawValue)
    }
    
    func testCentaurAxe() {
        doTest(artifactId: .centaurAxe, is: 7)
    }
    
    func testTitansThunder() {
        // https://github.com/vcmi/vcmi/blob/b1db6e2/lib/GameConstants.h#L1066
        doTest(artifactId: .titansThunder, is: 135)
    }
    
    func testCornucopia() {
        doTest(artifactId: .cornucopia, is: 140)
    }
    
    #if WOG
    func testArtifactSelection() {
        // https://github.com/vcmi/vcmi/blob/b1db6e2/lib/GameConstants.h#L1069
        doTest(heroId: .artifactSelection, is: 144)
    }
    func testArtifactLock() {
        // https://github.com/vcmi/vcmi/blob/b1db6e2/lib/GameConstants.h#L1070
        doTest(heroId: .artifactLock, is: 145)
    }
    func testMithrilMail() {
        // https://github.com/vcmi/vcmi/blob/b1db6e2/lib/GameConstants.h#L1072
        doTest(heroId: .mithrilMail, is: 147)
    }
    func testSlavasRingOfPower() {
        // https://github.com/vcmi/vcmi/blob/b1db6e2/lib/GameConstants.h#L1080
        doTest(heroId: .slavasRingOfPower, is: 155)
    }
    #endif // WOG
    
    
}
