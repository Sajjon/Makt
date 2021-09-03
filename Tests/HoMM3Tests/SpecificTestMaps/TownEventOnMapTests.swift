//
//  TownEventOnMapTests.swift
//  TownEventOnMapTests
//
//  Created by Alexander Cyon on 2021-09-02.
//

import XCTest
import Foundation
@testable import HoMM3SwiftUI

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/town-events.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/town-events.h3m

final class TownEventsOnMapTests: BaseMapTest {
    
    func testTownEventsOnMap() throws {
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, "") },
                onParseDescription: { XCTAssertEqual($0, "") },
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .small) },
                onFinishedParsingBasicInfo: { XCTAssertFalse($0.hasTwoLevels) }
            ),
            onParseObject: { [self] object in
                
                func assertTown(
                    owner: PlayerColor = .red,
                    events: [Map.Town.Event],
                    _ line: UInt = #line
                ) {
                    guard case let .town(town) = object.kind else {
                        XCTFail("Expected town, but got: \(object.kind)", line: line)
                        return
                    }
                    XCTAssertEqual(town.owner, owner)
//                    XCTAssertEqual(town.events, events)
                    guard town.events.count == events.count else {
                        XCTFail("town event count mismatch", line: line)
                        return
                    }
                    XCTAssertEqual(town.events.map({ $0.occurrences.first }).sorted(), town.events.map({ $0.occurrences.first }), "Events should be sorted on first occurence day.")
                    events.enumerated().forEach { eventIndex, expected in
                        let actual = town.events[eventIndex]
                        func f(_ failure: String) -> String {
                            "Mistmatch in event at index: \(eventIndex): \(failure)"
                        }
                        XCTAssertEqual(actual.name, expected.name, f("Name"), line: line)
                        XCTAssertEqual(actual.buildings, expected.buildings, f("building"), line: line)
                    }
               
                    
                    fullfill(object: object)
                }
                
                switch object.position {
                case at(5, y: 5):
                    assertTown(
                        events: [
                            Map.Town.Event(
                                townID: Map.Town.ID.fromMapFile(372973072),
                                timedEvent: .init(
                                    name: "give",
                                    firstOccurence: 10-1,
                                    subsequentOccurence: .every14Days,
                                    affectedPlayers: [.red],
                                    appliesToHumanPlayers: true,
                                    appliesToComputerPlayers: true,
                                    resources: .init(
                                        resources: [
                                            .init(kind: .wood, amount: 1),
                                            .init(kind: .mercury, amount: 2),
                                            .init(kind: .ore, amount: 3),
                                            .init(kind: .sulfur, amount: 4),
                                            .init(kind: .crystal, amount: 5),
                                            .init(kind: .gems, amount: 6),
                                            .init(kind: .gold, amount: 7),
                                        ]
                                    )
                                ),
                                creaturesToBeGained: [1, 2, 3, 4, 5, 6, 7]
                            ),
                            Map.Town.Event(
                                townID: Map.Town.ID.fromMapFile(1234),
                                timedEvent: .init(
                                    name: "take",
                                    firstOccurence: 15-1,
                                    subsequentOccurence: .everySevenDays,
                                    affectedPlayers: [.red],
                                    appliesToHumanPlayers: true,
                                    appliesToComputerPlayers: true,
                                    resources: .init(
                                        resources: [
                                            .init(kind: .wood, amount: -7),
                                            .init(kind: .mercury, amount: -6),
                                            .init(kind: .ore, amount: -5),
                                            .init(kind: .sulfur, amount: -4),
                                            .init(kind: .crystal, amount: -3),
                                            .init(kind: .gems, amount: -2),
                                            .init(kind: .gold, amount: -1)
                                        ]
                                    )
                                )
                            )
                        ]
                    )
                case at(12, y: 5):
                    var day: UInt16 = 1
                    func buildInTown(_ building: Map.Town.Buildings.Building, _ nameOfBuilding: String? = nil) -> Map.Town.Event {
                        let buildingName = nameOfBuilding ?? building.debugDescription.titlecased().lowercased()
                        let name = "build \(buildingName)"
                        let event: Map.Town.Event = .build(name: name, day: day, building: building)
                        day += 1
                        return event
                    }
                    assertTown(
                        events: [
                            buildInTown(.townHall),
                            buildInTown(.cityHall),
                            buildInTown(.capitol),
                            buildInTown(.fort),
                            buildInTown(.citadel),
                            buildInTown(.castle),
                            buildInTown(.tavern),
                            buildInTown(.blacksmith),
                            buildInTown(.marketplace),
                            buildInTown(.resourceSilo, "risource silo"), // sic
                            buildInTown(.artifactMerchants, "artifacts merchants"), // sic
                            buildInTown(.mageguildLevel1, "mage guild 1"),
                            buildInTown(.mageguildLevel2, "mage guild 2"),
                            buildInTown(.mageguildLevel3, "mage guild 3"),
                            buildInTown(.mageguildLevel4, "mage guild 4"),
                            buildInTown(.mageguildLevel5, "mage guild 5"),
                            buildInTown(.shipyard),
                            buildInTown(.grail),
                            
                            buildInTown(.dwelling1, "creature 1"),
                            buildInTown(.upgradedDwelling1, "creature 1 up"),
                            buildInTown(.dwelling1Horde, "creature 1 horde"),
                            
                            buildInTown(.dwelling2, "creature 2"),
                            buildInTown(.upgradedDwelling2, "creature 2 up"),
                            buildInTown(.dwelling2UpgradeHorde, "creature 2 horde"),
                            
                            buildInTown(.dwelling3, "creature 3"),
                            buildInTown(.upgradedDwelling3, "creature 3 up"),
                            buildInTown(.dwelling3Horde, "creature 3 horde"),
                            
                            buildInTown(.dwelling4, "creature 4"),
                            buildInTown(.upgradedDwelling4, "creature 4 up"),
                            buildInTown(.dwelling4Horde, "creature 4 horde"),
                            
                            buildInTown(.dwelling5, "creature 5"),
                            buildInTown(.upgradedDwelling5, "creature 5 up"),
                            buildInTown(.dwelling5Horde, "creature 5 horde"),
                            
                            buildInTown(.dwelling6, "creature 6"),
                            buildInTown(.upgradedDwelling6, "creature 6 up"),

                            buildInTown(.dwelling7, "creature 7"),
                            buildInTown(.upgradedDwelling7, "creature 7 up"),
                        ]
                    )
                default:
                    XCTFail("Did not expect to find any object besides two towns specified above.")
                }
            }
        )
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

extension String {
    func titlecased() -> String {
          return self
              .replacingOccurrences(of: "([a-z])([A-Z](?=[A-Z])[a-z]*)", with: "$1 $2", options: .regularExpression)
              .replacingOccurrences(of: "([A-Z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
              .replacingOccurrences(of: "([a-z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
              .replacingOccurrences(of: "([a-z])([A-Z][a-z])", with: "$1 $2", options: .regularExpression)
      }
}

private extension TownEventsOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "town-events", inspector: inspector)
    }
}

private extension Map.Town.Event {
    static func build(
        name: String,
        day: UInt16,
        building: Map.Town.Buildings.Building,
        appliesToHumanPlayers: Bool = true,
        appliesToComputerPlayers: Bool = false
    ) -> Self {
        .init(
            townID: Map.Town.ID.fromMapFile(123),
            timedEvent: Map.TimedEvent(
                name: name,
                message: nil,
                firstOccurence: day - 1,
                subsequentOccurence: nil,
                affectedPlayers: [.red],
                appliesToHumanPlayers: appliesToHumanPlayers,
                appliesToComputerPlayers: appliesToComputerPlayers,
                resources: nil
            ),
            buildings: [building]
        )
    }
}


private extension Map.Town.Buildings.Building {
    
    /// WRONG, just a placeholder
    static let dwelling4Horde: Self = .grail
}
