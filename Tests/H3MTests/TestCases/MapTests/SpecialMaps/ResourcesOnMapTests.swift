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

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/resources.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/resources.h3m

final class ResourcesOnMapTests: BaseMapTest {
    
    func testResources() throws {
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
                
                func assertResource(
                    _ resource: Map.GuardedResource,
                    line: UInt = #line
                ) {
                    assertObjectResource(expected: resource, actual: object, line: line)
                }
                
                func assertAbandonedMine(
                    _ mine: Map.AbandonedMine,
                    line: UInt = #line
                ) {
                    assertObjectAbandonedMine(expected: mine, actual: object, line: line)
                }
                
                func assertResourceGenerator(
                    _ resourceGenerator: Map.ResourceGenerator,
                    line: UInt = #line
                ) {
                    assertObjectResourceGenerator(expected: resourceGenerator, actual: object, line: line)
                }
                
                let positionEnum: SizeSmall = {
                    let positionEnum = SizeSmall(position: object.position)
                    expectObject(at: object.position)
                    return positionEnum
                }()
                
                switch positionEnum {
                case .x1y1:
                    XCTAssertEqual(object.objectID.stripped, .treasureChest)
                    fulfill(object: object)
                case .x3y1:
                    assertResource(.init(resourceKind: .crystal, quantity: .random, message: "crystal"))
                case .x5y1:
                    assertResource(.init(resourceKind: .gems, quantity: .random, message: "Gems"))
                case .x7y1:
                    assertResource(.init(resourceKind: .gold, quantity: .random, message: "gold"))
                case .x9y1:
                    assertResource(.init(resourceKind: .mercury, quantity: .random, message: "mercury"))
                case .x11y1:
                    assertResource(.init(resourceKind: .ore, quantity: .random, message: "ore"))
                case .x13y1:
                    assertResource(.init(resourceKind: .sulfur, quantity: .random, message: "sulfur"))
                case .x1y3:
                    assertResource(.init(resourceKind: .wood, quantity: .random, message: "wood"))
                case .x3y3:
                    assertResource(.init(kind: .random, quantity: .random))
                case .x1y6:
                    assertResource(
                        .init(
                            kind: .random,
                            quantity: .specified(10),
                            message: "with guardians",
                            guardians: .init(creatureStackAtSlot: [.one: .pikeman(1), .seven: .griffin(2)])
                        )
                    )
                case .x3y14:
                    assertAbandonedMine(.init(potentialResources: [.mercury]))
                case .x7y14:
                    assertAbandonedMine(.init(potentialResources: [.ore]))
                case .x11y14:
                    assertAbandonedMine(.init(potentialResources: [.sulfur, .gold]))
                case .x15y14:
                    assertAbandonedMine(.init(potentialResources: [.crystal]))
                case .x19y14:
                    assertAbandonedMine(.init(potentialResources: [.gems]))
                case .x23y14:
                    assertAbandonedMine(.init(potentialResources: [.gold]))
                case .x27y14:
                    assertAbandonedMine(.init(potentialResources: .allCases.all(but: [.wood])))
                case .x3y17:
                    assertResourceGenerator(.init(kind: .alchemistsLab, owner: .red))
                case .x6y17:
                    assertResourceGenerator(.init(kind: .crystalCavern, owner: .blue))
                case .x9y17:
                    assertResourceGenerator(.init(kind: .gemPond, owner: .tan))
                case .x12y17:
                    assertResourceGenerator(.init(kind: .goldMine, owner: .green))
                case .x15y17:
                    assertResourceGenerator(.init(kind: .orePit, owner: .orange))
                case .x19y17:
                    assertResourceGenerator(.init(kind: .sawmill, owner: .purple))
                case .x22y17:
                    assertResourceGenerator(.init(kind: .sulfurDune, owner: .teal))
                default:
                    XCTFail("Unexpected object found at: \(object.objectID), object: \(object)")
                }
            }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension ResourcesOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "resources", inspector: inspector)
    }
}
