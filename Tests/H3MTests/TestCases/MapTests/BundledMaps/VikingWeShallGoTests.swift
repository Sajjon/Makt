//
//  VikingWeShallGo.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class VikingWeShallGoTests: BaseMapTest {
    
    func test_vikingWeShallGo() throws {
        let mapID: Map.ID = .vikingWeShallGo
        Map.loader.cache.__deleteMap(by: mapID)
        let expectationCustomHeroes = expectation(description: "Custom Heroes")
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, "Viking We Shall Go!") },
                onParseDescription:  {
                    XCTAssertEqual(
                        $0,
                        """
                        The Place: Europe
                        The Time: The Dark Ages
                        Vikings have begun their raids while the kings of Europe take the opportunity to grab land from their neighbors.
                        """
                    )
                }
            ),
            playersInfoInspector: .init(onFinishParsingInformationAboutPlayers: { info in
                XCTAssertEqual(info.players.flatMap { $0.townTypes }, [.stronghold, .necropolis, .castle, .rampart, .castle, .inferno])
            }),
            additionalInformationInspector: .init(
                onParseAvailableHeroes: { availableHeroes in
                    XCTArraysEqual(
                        availableHeroes.values,
                        Hero.ID
                            .playable(in: .shadowOfDeath)
                            .all(but:
                                    Hero.ID.tower(format: .shadowOfDeath) + [Hero.ID.lordHaart, Hero.ID.mutareDrake]
                            ))
                },
                onParseCustomHeroes: {
                    defer { expectationCustomHeroes.fulfill() }
                    guard let customHeroes = $0?.customHeroes else {
                        XCTFail("Expected custom heroes")
                        return
                    }
                    
                    let castleHeroes = Hero.ID
                        .castle(format: .restorationOfErathia)
                        .all(but: [.lordHaart])
                        .sorted(by: \.rawValue)
                    
                    var startIndex = 0
                    var endIndex = 0
                    endIndex += castleHeroes.count
                    customHeroes[startIndex..<endIndex].enumerated().forEach { (offset, ch) in
                        XCTAssertEqual(ch.heroId, castleHeroes[offset])
                        XCTAssertEqual(ch.allowedPlayers, [3, 5])
                    }
                    startIndex = endIndex
                    
                    let rampartHeroes = Hero.ID.rampart(format: .restorationOfErathia)
                    endIndex += rampartHeroes.count
                    customHeroes[startIndex..<endIndex].enumerated().forEach { (offset, ch) in
                        XCTAssertEqual(ch.heroId, rampartHeroes[offset])
                        XCTAssertEqual(ch.allowedPlayers, [4])
                    }
                    startIndex = endIndex
                    
                    let infernoHeroes = Hero.ID
                        .inferno(format: .restorationOfErathia)
                        .prefix(3) // yupp only 3 inferno heroes have been customized.
                    
                    endIndex += infernoHeroes.count
                    customHeroes[startIndex..<endIndex].enumerated().forEach { (offset, ch) in
                        XCTAssertEqual(ch.heroId, infernoHeroes[offset])
                        XCTAssertEqual(ch.allowedPlayers, [3, 5])
                    }
                }),
            onParseObject: { [self] object in
                switch object.position {
                case at(0, y: 0):
                    XCTAssertEqual(object.objectID.stripped, .shipwreckSurvivor)
                    XCTAssertEqual(object.kind, .generic)
                    fulfill(object: object)
                    
                case at(10, y: 6):
                    if case .town = object.kind {
                        
                        assertObjectTown(
                            expected: .init(
                                id: .fromMapFile(1813815844),
                                faction: .tower,
                                name: "Reykjavik"
                            ),
                            actual: object)
                    } else {
                        XCTAssertEqual(object.objectID.stripped, .rock)
                        fulfill(object: object)
                    }
                default: break
                }
            }
            
        )
        
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
        waitForExpectations(timeout: 1)
    }
}
