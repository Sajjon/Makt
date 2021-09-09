//
//  CustomizedHeroesSODMapTest.swift
//  CustomizedHeroesSODMapTest
//
//  Created by Alexander Cyon on 2021-09-05.
//

import Foundation
import XCTest
@testable import Makt

final class CustomizedHeroesSODMapTest: AdditionalInfoBaseTests {
    
    override var mapFileName: String { "cyon_sod_only_additional_info_custom_heroes" }
    override var mapName: String { "additional_info_custom_heros" }
    
    func test() throws {
        let expectationCustomHeroes = expectation(description: "Custom Heroes")
        let expectationHeroSettings = expectation(description: "Hero settings")
        
        struct ExpectedHero {
            let id: Hero.ID
            let portrait: Hero.ID?
            let name: String
            let gender: Hero.Gender?
            let xp: UInt32
            let bio: String?
            let primarySkills: [Hero.PrimarySkill]?
            let secondarySkills: [Hero.SecondarySkill]?
            let artifacts: [Hero.ArtifactInSlot]?
            let spells: [Spell.ID]?
            
            func assert(custom: Map.AdditionalInformation.CustomHero) {
                XCTAssertEqual(custom.heroId, self.id)
                XCTAssertEqual(custom.portraitID, self.portrait)
                XCTAssertEqual(custom.name, self.name)
            }
            
            func assert(heroSettings: Map.AdditionalInformation.SettingsForHero) {
                XCTAssertEqual(heroSettings.customGender, self.gender)
                XCTAssertEqual(heroSettings.startingExperiencePoints, self.xp)
                XCTAssertEqual(heroSettings.biography, self.bio)
                XCTAssertEqual(heroSettings.customPrimarySkills, self.primarySkills)
                if let secondarySkills = self.secondarySkills {
                    if let startingSecondarySkills = heroSettings.startingSecondarySkills {
                        XCTAssertEqual(Set(startingSecondarySkills), Set(secondarySkills))
                    } else {
                        XCTFail("Expected to have some starting secondary skills.")
                    }
                }
                
                if let expectedArtifacts = self.artifacts {
                    if let actualArtifacts = heroSettings.artifacts {
                        XCTAssertEqual(Set(actualArtifacts), Set(expectedArtifacts))
                    } else {
                        XCTFail("Expected to have some artifacts.")
                    }
                }
                
                if let expectedSpells = self.spells {
                    if let actualSpells = heroSettings.customSpells {
                        XCTAssertEqual(Set(actualSpells), Set(expectedSpells))
                    } else {
                        XCTFail("Expected to have some spells.")
                    }
                }
            }
            
        }
        let nakamoto = ExpectedHero(
            id: .orrin,
            portrait: .solmyr,
            name: "S Nakamoto",
            gender: .female,
            xp: 99999999,
            bio: "Satoshi Nakamoto is the name used by the presumed pseudonymous person or persons who developed bitcoin, authored the bitcoin white paper, and created and deployed bitcoin's original reference implementation. As part of the implementation, Nakamoto also devised the first blockchain database. Nakamoto was active in the development of bitcoin up until December 2010. Many people have claimed, or have been claimed, to be Nakamoto.",
            primarySkills: [
                .init(kind: .attack, level: 1),
                .init(kind: .defense, level: 99),
                .init(kind: .power, level: 1),
                .init(kind: .knowledge, level: 99)
            ],
            secondarySkills: [
                .init(kind: .wisdom, level: .expert),
                .init(kind: .resistance, level: .expert),
                .init(kind: .leadership, level: .expert),
                .init(kind: .sorcery, level: .basic),
                .init(kind: .diplomacy, level: .advanced),
                .init(kind: .intelligence, level: .expert),
                .init(kind: .armorer, level: .expert),
                .init(kind: .estates, level: .expert)
            ],
            artifacts: [
                .init(slot: .body(.spellbook), artifactID: .spellBook),
                .init(slot: .body(.catapultSlot), artifactID: .catapult),
                .init(slot: .body(.head), artifactID: .admiralHat),
                .init(slot: .body(.misc1), artifactID: .badgeOfCourage),
                .init(slot: .body(.misc2), artifactID: .birdOfPerception),
                .init(slot: .body(.misc3), artifactID: .cardsOfProphecy),
                .init(slot: .backpack(.init(0)!), artifactID: .ladybirdOfLuck),
                .init(slot: .backpack(.init(1)!), artifactID: .ambassadorsSash)
            ],
            spells: [.dimensionDoor, .visions]
        )
        let elonMusk = ExpectedHero(
            id: .grindan,
            portrait: .cragHack,
            name: "Elon Musk",
            gender: .defaultGender,
            xp: 1337,
            bio: "Musk was born to a Canadian mother and South African father and raised in Pretoria, South Africa. He briefly attended the University of Pretoria before moving to Canada aged 17 to attend Queen's University. He transferred to the University of Pennsylvania two years later, where he received bachelor's degrees in economics and physics.",
            primarySkills: nil,
            secondarySkills: nil,
            artifacts: nil,
            spells: nil
        )
        
        let ivorIvor = ExpectedHero(
            id: .ivor,
            portrait: nil,
            name: "Ivor ivor!!",
            gender: .defaultGender,
            xp: 237,
            bio: nil,
            primarySkills: nil,
            secondarySkills: nil,
            artifacts: nil,
            spells: nil
        )
        
        let expectedHeroes = [nakamoto, ivorIvor, elonMusk]
        
        try doTestAdidtionalInformation(
            onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
            onParseName: { XCTAssertEqual($0, self.mapName) },
            onParseCustomHeroes: { customHeroes in
                defer { expectationCustomHeroes.fulfill() }
                guard let heroes = customHeroes?.customHeroes else {
                    XCTFail("Expected custom heroes")
                    return
                }
                XCTAssertEqual(heroes.count, expectedHeroes.count)
                
                heroes.enumerated().forEach {
                    expectedHeroes[$0.offset].assert(custom: $0.element)
                }

            },
            onParseHeroSettings: { heroSettings in
                defer { expectationHeroSettings.fulfill() }
                XCTAssertEqual(heroSettings.settingsForHeroes.count, expectedHeroes.count)
        
                heroSettings.settingsForHeroes.enumerated().forEach {
                    expectedHeroes[$0.offset].assert(heroSettings: $0.element)
                }
            }
        )
    }
}
