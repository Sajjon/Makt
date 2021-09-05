//
//  HeroesStartingWith_A_MapTest.swift
//  HeroesStartingWith_A_MapTest
//
//  Created by Alexander Cyon on 2021-09-05.
//

import Foundation
import XCTest
@testable import HoMM3SwiftUI

final class HeroesStartingWith_A_Tests: AdditionalInfoBaseTests {
    
    override var mapFileName: String { "cyon_sod_additional_info_heroes_starting_with_letter_A" }
    override var mapName: String { "additional_info_heroes_on_A" }
    
    func test() throws {
        let expectationHeroes = expectation(description: "Heroes")
        try doTestAdidtionalInformation(
            onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
            onParseName: { XCTAssertEqual($0, self.mapName) },
            onParseAvailableHeroes: { availableHeroes in
                defer { expectationHeroes.fulfill() }
                /// Sorting is the one of Map Editor: According to faction.
                let expected = Set<Hero.ID>([.adela, .adelaide, .alagar, .aeris, .astral, .aine, .ayden, .axsis, .ash, .aislinn, .arlach,. ajit, .alamar, .alkin, .andra, .adrienne, .aenain])
                XCTAssertEqual(Set(availableHeroes.heroIDs), expected)
            }
        )
    }
}
