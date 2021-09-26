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

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/town-spells-1-3.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/town-spells-1-3.h3m

final class TownWithSpellsLevelOneToThreeTests: BaseMapTest {
    
    override func setUp() {
        super.setUp()
    }
    
    func doGeneratePos() {
        
        func gen(size sizeClass: Size) {
            let size = sizeClass.height
            
            var cases = [String]()
            var positionFromCases = [String]()
            var selfFromPositionCases = [String]()
            for x in 0..<size {
                for y in 0..<size {
                    let caseName = "x\(x)y\(y)"
                    cases.append("case \(caseName) = \"\(caseName)\"")
                    positionFromCases.append("case .\(caseName): return .init(x: \(x)y\(y))")
                    selfFromPositionCases.append("case (\(x), \(y)): self = .\(caseName)")
                }
            }
            
            let casesString = cases.joined(separator: "\n\t")
            let positionFromCasesString = positionFromCases.joined(separator: "\n\t\t\t")
            let selfFromPositionCasesString = selfFromPositionCases.joined(separator: "\n\t\t\t")
            
            
            let enumName = "Size\(sizeClass.debugDescription.capitalized)"
            
            let variableStartSlash = "\\"
            let variableStartParenthesis = "("
            
            print(
                """
                public enum \(enumName): String, Hashable, CaseIterable {
                    \(casesString)
                }
                
                public extension \(enumName) {
                    init(position: Position) {
                        switch (position.x, position.y) {
                            \(selfFromPositionCasesString)
                        default:
                            fatalError("Forgot to handle position: \(variableStartSlash)\(variableStartParenthesis)position)?")
                        }
                    }
                }
                
                public extension \(enumName) {
                    var position: Position {
                        switch self {
                            \(positionFromCasesString)
                        }
                    }
                }
                """
            )
        }
        
//        Size.allCases.forEach {
//            gen(size: $0)
//        }
        gen(size: .small)
    }
    
    func testTownWithSpellsLevelOneToThree() throws {
        
        var next: UInt32 = 0
        let townIDBase: UInt32 = 4228396600
        
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
                
                func assertTown(
                    _ spell: Spell.ID,
                    name maybeName: String? = nil,
                    line: UInt = #line
                ) {
                    defer { next += 1  }
                    let name = maybeName ?? String(describing: spell)
                    assertObjectTown(
                        expected: .init(
                            id: .fromMapFile(next + townIDBase),
                            faction: .tower,
                            name: name,
                            spells: .init(possible: .allCases, obligatory: [spell])
                        ),
                        actual: object,
                        line: line)
                }
                
                let positionEnum: SizeSmall = {
                    let positionEnum = SizeSmall(position: object.position)
                    expectObject(at: object.position)
                    return positionEnum
                }()
                
                switch positionEnum {
                case .x4y3:
                    assertTown(.bless)
                case .x9y3:
                    assertTown(.bloodlust)
                case .x14y3:
                    assertTown(.cure)
                case .x19y3:
                    assertTown(.curse)
                case .x24y3:
                    assertTown(.dispel, name: "dispell")
                case .x29y3:
                    assertTown(.haste)
                case .x34y3:
                    assertTown(.magicArrow, name: "magic arrow")
                case .x4y7:
                    assertTown(.protectionFromWater, name: "prot water")
                case .x9y7:
                    assertTown(.protectionFromFire, name: "prot fire")
                case .x14y7:
                    assertTown(.shield)
                case .x19y7:
                    assertTown(.slow)
                case .x24y7:
                    assertTown(.stoneSkin, name: "stone skin")
                case .x29y7:
                    assertTown(.summonBoat, name: "summ boat")
                case .x34y7:
                    assertTown(.viewAir, name: "view air")
                case .x4y11:
                    assertTown(.viewEarth, name: "view earch")
                case .x9y11:
                    assertTown(.blind)
                case .x14y11:
                    assertTown(.deathRipple, name: "death ripple")
                case .x19y11:
                    assertTown(.disguise)
                case .x24y11:
                    assertTown(.disruptingRay, name: "disrupting ray")
                case .x29y11:
                    assertTown(.fireWall, name: "fire wall")
                case .x34y11:
                    assertTown(.fortune)
                case .x4y15:
                    assertTown(.iceBolt, name: "ice balt")
                case .x9y15:
                    assertTown(.lightningBolt, name: "lightning bolt")
                case .x14y15:
                    assertTown(.precision)
                case .x19y15:
                    assertTown(.protectionFromAir, name: "prot air")
                case .x24y15:
                    assertTown(.quicksand)
                case .x29y15:
                    assertTown(.removeObstacle, name: "remove obstacl")
                case .x34y15:
                    assertTown(.scuttleBoat, name: "scuttle boat")
                case .x4y19:
                    assertTown(.visions)
                case .x9y19:
                    assertTown(.weakness)
                case .x14y19:
                    assertTown(.airShield, name: "air shield")
                case .x19y19:
                    assertTown(.animateDead, name: "animate dead")
                case .x24y19:
                    assertTown(.antiMagic, name: "antimagic")
                case .x29y19:
                    assertTown(.destroyUndead, name: "destroy undead")
                case .x34y19:
                    assertTown(.earthquake)
                case .x4y22:
                    assertTown(.fireball)
                case .x9y22:
                    assertTown(.forceField, name: "force shield") // SIC
                case .x14y22:
                    assertTown(.forgetfulness, name: "forgetfullness")
                case .x19y22:
                    assertTown(.frostRing, name: "frost ring")
                case .x24y22:
                    assertTown(.hypnotize)
                case .x29y22:
                    assertTown(.landMine, name: "land mine")
                case .x34y22:
                    assertTown(.mirth)
                case .x4y25:
                    assertTown(.misfortune)
                case .x9y25:
                    assertTown(.protectionFromEarth, name: "prot earth")
                case .x14y25:
                    assertTown(.teleport)
                default:
                    XCTFail("Unexpected object found at: \(object.objectID), object: \(object)")
                }
            }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension TownWithSpellsLevelOneToThreeTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "town-spells-1-3", inspector: inspector)
    }
}
