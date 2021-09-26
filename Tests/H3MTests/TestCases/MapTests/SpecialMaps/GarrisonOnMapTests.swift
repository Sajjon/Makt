//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-14.
//

import XCTest
import Foundation
import Malm
@testable import H3M

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/garrison.h3m

/// MIT License
///
/// Copyright (c) 2018 Sergey Kostyrko
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/garrison.h3m

final class GarrisonOnMapTests: BaseMapTest {
        
    func testGarrison() throws {
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, "") },
                onParseDescription: { XCTAssertEqual($0, "") },
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .small) },
                onFinishedParsingBasicInfo: { XCTAssertFalse($0.hasTwoLevels) }
            ),
            onParseObject: { [unowned self] object in
                
                func assertGarrison(
                    expected: Map.Garrison,
                    line: UInt = #line
                ) {
                    assertObjectGarrison(expected: expected, actual: object)
                }
                
                switch object.position {
                case at(2, y: 1):
                    assertGarrison(expected: .init(creatures: [
                        .pikeman(1),
                        .halberdier(1),
                        .archer(1),
                        .marksman(1),
                        .griffin(1),
                        .royalGriffin(1),
                        .swordsman(1)
                    ]))
                case at(5, y: 1):
                    assertGarrison(expected: .init(creatures: [
                        .crusader(1),
                        .monk(1),
                        .zealot(1),
                        .cavalier(1),
                        .champion(1),
                        .angel(1),
                        .archangel(1)
                    ]))
                case at(8, y: 1):
                    assertGarrison(expected: .init(creatures: [
                        .centaur(1),
                        .centaurCaptain(1),
                        .dwarf(1),
                        .battleDwarf(1),
                        .woodElf(1),
                        .grandElf(1),
                        .pegasus(1)
                    ]))
                case at(11, y: 1):
                    assertGarrison(expected: .init(creatures: [
                        .silverPegasus(1),
                        .dendroidGuard(1),
                        .dendroidSoldier(1),
                        .unicorn(1),
                        .warUnicorn(1),
                        .greenDragon(1),
                        .goldDragon(1)
                    ]))
                case at(14, y: 1):
                    assertGarrison(expected: .init(creatures: [
                        .gremlin(1),
                        .masterGremlin(1),
                        .stoneGargoyle(1),
                        .obsidianGargoyle(1),
                        .stoneGolem(1),
                        .ironGolem(1),
                        .mage(1)
                    ]))
                case at(17, y: 1):
                    assertGarrison(expected: .init(creatures: [
                        .archMage(1),
                        .genie(1),
                        .masterGenie(1),
                        .naga(1),
                        .nagaQueen(1),
                        .giant(1),
                        .titan(1)
                    ]))
                case at(20, y: 1):
                    assertGarrison(expected: .init(creatures: [
                        .imp(1),
                        .familiar(1),
                        .gog(1),
                        .magog(1),
                        .hellHound(1),
                        .cerberus(1),
                        .demon(1)
                    ]))
                case at(23, y: 1):
                    assertGarrison(expected: .init(creatures: [
                        .hornedDemon(1),
                        .pitFiend(1),
                        .pitLord(1),
                        .efreeti(1),
                        .efreetSultan(1),
                        .devil(1),
                        .archDevil(1)
                    ]))
                case at(26, y: 1):
                    assertGarrison(expected: .init(creatures: [
                        .skeleton(1),
                        .skeletonWarrior(1),
                        .walkingDead(1),
                        .zombie(1),
                        .wight(1),
                        .wraith(1),
                        .vampire(1)
                    ]))
                case at(29, y: 1):
                    assertGarrison(expected: .init(creatures: [
                        .vampireLord(1),
                        .lich(1),
                        .powerLich(1),
                        .blackKnight(1),
                        .dreadKnight(1),
                        .boneDragon(1),
                        .ghostDragon(1)
                    ]))
                case at(2, y: 3):
                    assertGarrison(expected: .init(creatures: [
                        .troglodyte(1),
                        .infernalTroglodyte(1),
                        .harpy(1),
                        .harpyHag(1),
                        .beholder(1),
                        .evilEye(1),
                        .medusa(1)
                    ]))
                case at(5, y: 3):
                    assertGarrison(expected: .init(creatures: [
                        .medusaQueen(1),
                        .minotaur(1),
                        .minotaurKing(1),
                        .manticore(1),
                        .scorpicore(1),
                        .redDragon(1),
                        .blackDragon(1)
                    ]))
                case at(8, y: 3):
                    assertGarrison(expected: .init(creatures: [
                        .goblin(1),
                        .hobgoblin(1),
                        .wolfRider(1),
                        .wolfRaider(1),
                        .orc(1),
                        .orcChieftain(1),
                        .ogre(1)
                    ]))
                case at(11, y: 3):
                    assertGarrison(expected: .init(creatures: [
                        .ogreMage(1),
                        .roc(1),
                        .thunderbird(1),
                        .cyclops(1),
                        .cyclopsKing(1),
                        .behemoth(1),
                        .ancientBehemoth(1)
                    ]))
                case at(14, y: 3):
                    assertGarrison(expected: .init(creatures: [
                        .gnoll(1),
                        .gnollMarauder(1),
                        .lizardman(1),
                        .lizardWarrior(1),
                        .serpentFly(1),
                        .dragonFly(1),
                        .basilisk(1)
                    ]))
                case at(17, y: 3):
                    assertGarrison(expected: .init(creatures: [
                        .greaterBasilisk(1),
                        .gorgon(1),
                        .mightyGorgon(1),
                        .wyvern(1),
                        .wyvernMonarch(1),
                        .hydra(1),
                        .chaosHydra(1)
                    ]))
                case at(20, y: 3):
                    assertGarrison(expected: .init(creatures: [
                        .pixie(1),
                        .sprite(1),
                        .airElemental(1),
                        .stormElemental(1),
                        .waterElemental(1),
                        .magmaElemental(1),
                        .fireElemental(1)
                    ]))
                case at(23, y: 3):
                    assertGarrison(expected: .init(creatures: [
                        .iceElemental(1),
                        .earthElemental(1),
                        .energyElemental(1),
                        .psychicElemental(1),
                        .magicElemental(1),
                        .firebird(1),
                        .phoenix(1)
                    ]))
                case at(26, y: 3):
                    assertGarrison(expected: .init(creatures: [
                        .halfling(1),
                        .peasant(1),
                        .boar(1),
                        .rogue(1),
                        .mummy(1),
                        .nomad(1),
                        .sharpshooter(1)
                    ]))
                case at(29, y: 3):
                    assertGarrison(expected: .init(creatures: [
                        .goldGolem(1),
                        .troll(1),
                        .diamondGolem(1),
                        .enchanter(1),
                        .azureDragon(1),
                        .crystalDragon(1),
                        .faerieDragon(1)
                    ]))
                case at(2, y: 5):
                    assertGarrison(expected: .init(creatures: [
                        .rustDragon(1)
                    ]))
                default:
                    XCTFail("Unexpected object found at: \(object.objectID), object: \(object)")
                }
            }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension GarrisonOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "garrison", inspector: inspector)
    }
}
