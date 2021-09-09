//
//  TownEventOnMapTests.swift
//  TownEventOnMapTests
//
//  Created by Alexander Cyon on 2021-09-02.
//

import XCTest
import Foundation
@testable import Makt

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
                    owner: Player = .playerOne,
                    events expectedEvents: [Map.Town.Event],
                    _ line: UInt = #line
                ) {
                    guard case let .town(town) = object.kind else {
                        XCTFail("Expected town, but got: \(object.kind)", line: line)
                        return
                    }
                    XCTAssertEqual(town.owner, owner)
                    guard
                        let actualEvents = town.events,
                        actualEvents.count == expectedEvents.count else {
                        XCTFail("town event count mismatch", line: line)
                        return
                    }
                    XCTAssertEqual(actualEvents.map({ $0.occurrences.first }).sorted(), actualEvents.map({ $0.occurrences.first }), "Events should be sorted on first occurence day.")
                    expectedEvents.enumerated().forEach { eventIndex, expected in
                        let actual = actualEvents[eventIndex]
                        func f(_ failure: String) -> String {
                            "Mistmatch in event at index: \(eventIndex): \(failure)"
                        }
                        XCTAssertEqual(expected.name, actual.name, f("Name"), line: line)
                        XCTAssertEqual(expected.buildings, actual.buildings, f("building"), line: line)
                    }
               
                    
                    fulfill(object: object)
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
                                    affectedPlayers: [.playerOne],
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
                                    affectedPlayers: [.playerOne],
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
                    func builtInTown(_ builtBuildings: [Map.Town.Building], _ nameOfBuilding: String) -> Map.Town.Event {
                        let name = "build \(nameOfBuilding)"
                        let event: Map.Town.Event = .build(name: name, day: day, builtBuildings: builtBuildings)
                        day += 1
                        return event
                    }
                    func buildInTown(_ building: Map.Town.Building, _ nameOfBuilding: String? = nil) -> Map.Town.Event {
                        let buildingName = nameOfBuilding ?? building.debugDescription.titlecased().lowercased()
                        return builtInTown([building], buildingName)
                    }
                    assertTown(
                        events: [
                            buildInTown(.townHall),
                            builtInTown([.townHall, .cityHall], "city hall"),
                            builtInTown([.townHall, .cityHall, .capitol], "capitol"),
                            buildInTown(.fort),
                            builtInTown([.fort, .citadel], "citadel"),
                            builtInTown([.fort, .citadel, .castle], "castle"),
                            buildInTown(.tavern),
                            buildInTown(.blacksmith),
                            buildInTown(.marketplace),
                            builtInTown([.marketplace, .resourceSilo], "risource silo"), // sic
                            builtInTown([.marketplace, .artifactMerchants], "artifacts merchants"), // sic
                            buildInTown(.mageGuildLevel1, "mage guild 1"),
                            builtInTown([.mageGuildLevel1, .mageGuildLevel2], "mage guild 2"),
                            builtInTown([.mageGuildLevel1, .mageGuildLevel2, .mageGuildLevel3], "mage guild 3"),
                            builtInTown([.mageGuildLevel1, .mageGuildLevel2, .mageGuildLevel3, .mageGuildLevel4], "mage guild 4"),
                            builtInTown([.mageGuildLevel1, .mageGuildLevel2, .mageGuildLevel3, .mageGuildLevel4, .mageGuildLevel5], "mage guild 5"),
                            buildInTown(.shipyard),
                            buildInTown(.grail),
                            
                            buildInTown(.dwelling1, "creature 1"),
                            builtInTown([.dwelling1, .upgradedDwelling1], "creature 1 up"),
                            builtInTown([.dwelling1, .horde1], "creature 1 horde"),
                            
                            buildInTown(.dwelling2, "creature 2"),
                            builtInTown([.dwelling2, .upgradedDwelling2], "creature 2 up"),
                            builtInTown([.dwelling2, .horde2], "creature 2 horde"),
                            
                            buildInTown(.dwelling3, "creature 3"),
                            builtInTown([.dwelling3, .upgradedDwelling3], "creature 3 up"),
                            builtInTown([.dwelling3, .horde3], "creature 3 horde"),
                            
                            buildInTown(.dwelling4, "creature 4"),
                            builtInTown([.dwelling4, .upgradedDwelling4], "creature 4 up"),
                            builtInTown([.dwelling4, .horde4], "creature 4 horde"),
                            
                            buildInTown(.dwelling5, "creature 5"),
                            builtInTown([.dwelling5, .upgradedDwelling5], "creature 5 up"),
                            builtInTown([.dwelling5, .horde5], "creature 5 horde"),
                            
                            buildInTown(.dwelling6, "creature 6"),
                            builtInTown([.dwelling6, .upgradedDwelling6], "creature 6 up"),

                            buildInTown(.dwelling7, "creature 7"),
                            builtInTown([.dwelling7, .upgradedDwelling7], "creature 7 up"),
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
        builtBuildings: [Map.Town.Building],
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
                affectedPlayers: [.playerOne],
                appliesToHumanPlayers: appliesToHumanPlayers,
                appliesToComputerPlayers: appliesToComputerPlayers,
                resources: nil
            ),
            buildings: builtBuildings
        )
    }
}


private extension Map.Town.Building {
    
    /// WRONG, just a placeholder
    static let dwelling4Horde: Self = .grail
}
