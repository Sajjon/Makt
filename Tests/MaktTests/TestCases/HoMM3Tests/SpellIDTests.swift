//
//  SpellIDTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation
import XCTest
import Makt

final class SpellIDTest: XCTestCase {
    
    private func doTest(spellId: Spell.ID, is rawValue: Spell.ID.RawValue) {
        XCTAssertEqual(spellId.rawValue, rawValue)
    }
    
    func testSummonBoat() {
        doTest(spellId: .summonBoat, is: 0)
    }
    
    func testTownPortal() {
        doTest(spellId: .townPortal, is: 9)
    }
    
    func testQuicksand() {
        doTest(spellId: .quicksand, is: 10)
    }
    
    func testWaterElemental() {
        doTest(spellId: .waterElemental, is: 68)
    }
    
    func testAirElemental() {
        doTest(spellId: .airElemental, is: 69)
    }
}
