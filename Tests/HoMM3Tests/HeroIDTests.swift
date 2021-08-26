//
//  HeroIDTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation
import XCTest
import HoMM3SwiftUI

final class HeroIDTest: XCTestCase {
    
    private func doTest(heroId: Hero.ID, is rawValue: Hero.ID.RawValue) {
        XCTAssertEqual(heroId.rawValue, rawValue)
    }
    
    func testOrrin() {
        doTest(heroId: .orrin, is: 0)
    }
    
    func testValeska() {
        doTest(heroId: .valeska, is: 1)
    }
    
    func testLordHaart() {
        doTest(heroId: .lordHaart, is: 4)
    }
    
    func testCalid() {
        doTest(heroId: .calid, is: 60)
    }
    
    func testGelu() {
        doTest(heroId: .gelu, is: 148)
    }
    
    func testCragHack() {
        doTest(heroId: .cragHack, is: 102)
    }
    
    func testYog() {
        doTest(heroId: .yog, is: 96)
    }
    
    func testOrisYog() {
        doTest(heroId: .oris, is: 110)
    }
    
    func testKorbac() {
        doTest(heroId: .korbac, is: 117)
    }
    
    func testVerdish() {
        doTest(heroId: .verdish, is: 123)
    }
    
    func testTiva() {
        doTest(heroId: .tiva, is: 127)
    }
    
    func testLordHaartTheDeathKnight() {
        doTest(heroId: .lordHaartTheDeathKnight, is: 150)
    }
    
    func testXeron() {
        doTest(heroId: .xeron, is: 155)
    }
    
    #if HOTA
    func testCorkes() {
        doTest(heroId: .corkes, is: 156)
    }
    
    func testRanloo() {
        doTest(heroId: .ranloo, is: 177)
    }
    
    func testGiselle() {
        doTest(heroId: .giselle, is: 178)
    }
    #endif // HOTA
    
    
}
