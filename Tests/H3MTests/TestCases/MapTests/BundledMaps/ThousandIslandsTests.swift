//
//  ThousandIslandsTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-08.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class ThousandIslandsTests: BaseMapTest {
    
    func test_thousand_islands() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .thousandIslandsAllies)
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .armageddonsBlade) },
                onParseName: { XCTAssertEqual($0, "Thousand Islands (Allies)") },
                onParseDescription: { XCTAssertEqual($0, "An evil wizard has cast a spell that has caused volcanoes to erupt on the islands of Norkko. The people are in a state of panic and no one knows who the evil wizard is. These vicious volcanoes destroy entire towns. Someone must find him and destroy him.") }
            ),
            additionalInformationInspector: .init(
                victoryLossInspector: .init(
                    onParseVictoryConditions: {
                        XCTAssertEqual($0, [
                            .init(kind: .defeatSpecificHero(locatedAt: .init(x: 59, y: 118)))
                        ]) }
                ),
                onParseTeamInfo: {
                    XCTAssertEqual($0, [[1, 2], [3, 4], [5, 7], [6]])
                }
            ),
            onParseObject: { [unowned self] object in
                switch object.position {
                case at(9, y: 7):
                    assertObjectRandomHero(
                        expected: .init(
                            identifierKind: .randomHero,
                            questIdentifier: 16656053,
                            owner: .red,
                            gender: .defaultGender,
                            spells: nil
                        ),
                        actual: object
                    )
                default: break
                }
            }
        )
        try loadMap(id: .thousandIslandsAllies, inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}
