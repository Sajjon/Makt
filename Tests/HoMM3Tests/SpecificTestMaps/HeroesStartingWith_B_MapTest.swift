//
//  HeroesStartingWith_B_MapTest.swift
//  HeroesStartingWith_B_MapTest
//
//  Created by Alexander Cyon on 2021-09-05.
//

import Foundation
import XCTest
@testable import HoMM3SwiftUI

final class HeroesStartingWith_B_Tests: AdditionalInfoBaseTests {
    
    override var mapFileName: String { "cyon_sod_additional_info_heroes_starting_with_letter_B" }
    override var mapName: String { "additional_info_heroes_on_B" }
    
    func testHeroesStartingWithLetter_A() throws {
        let expectationHeroes = expectation(description: "Heroes")
        try doTestAdidtionalInformation(
            onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
            onParseName: { XCTAssertEqual($0, self.mapName) },
            onParseAvailableHeroes: { availableHeroes in
                defer { expectationHeroes.fulfill() }
                /// Sorting is the one of Map Editor: According to faction.
                let expected = Set<Hero.ID>([.boragus, .bron, .broghild, .brissa])
                XCTAssertEqual(Set(availableHeroes.heroIDs), expected)
            }
        )
    }
}
