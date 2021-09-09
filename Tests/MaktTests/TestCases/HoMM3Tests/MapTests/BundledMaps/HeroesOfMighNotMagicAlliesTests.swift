//
//  HeroesOfMighNotMagicAlliesTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-08.
//

import Foundation
import XCTest
@testable import Makt

final class HeroesOfMighNotMagicAlliesTests: BaseMapTest {
    func test_heroesOfMightNotMagic_allies() throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: .heroesOfMightNotMagicAllies)
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: {
                    XCTAssertEqual($0, .shadowOfDeath)
                },
                onParseName: { XCTAssertEqual($0, "Heroes of Might, Not Magic (A)") },
                onParseDescription: { XCTAssertEqual($0, "An evil sorcerer has siphoned all the magic from this land into his Vial of Dragon Blood.  The only way to get the magic back is to unite all the towns in battle against him.  However, each town thinks they can rule this land better than the other.") },
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .medium) }
            ),
            playersInfoInspector: .init(
                onFinishParsingInformationAboutPlayers: { info in
                    let players = info.players

                    let red = players[0]
                    XCTAssertNil(red.mainTown)
                    XCTAssertTrue(red.isPlayableBothByHumanAndAI)
                    XCTAssertEqual(red.behaviour, .random)
                    
                    players.all(member: \.player, but: [Player.playerTwo]).forEach({ XCTArraysEqual($0.townTypes, Faction.all(but: [.tower, .neutral, .random])) })
                    
                    let blue = players[1]
                    XCTArraysEqual(blue.townTypes, Faction.all(but: [.neutral, .random]))
                }
            ),
            additionalInformationInspector: .init(
                onParseTeamInfo: {
                    XCTAssertEqual($0, [[1, 5], [2, 4], [6, 7]])
                }
            ),
            onParseObject: { [self] object in
                switch object.position {
                case at(12, y: 67):
                    assertObjectRandomTown(
                        expected: .init(
                            id: .fromMapFile(731346733),
                            owner: .red,
                            buildings: .custom(.init(built: [.fort, .tavern, .mageGuildLevel1, .mageGuildLevel2, .mageGuildLevel3, .mageGuildLevel4, .mageGuildLevel5], forbidden: [])),
                            spells: .init(possible: [.titansLightningBolt], obligatory: []),
                            alignment: .sameAsOwnerOrRandom
                        ),
                        actual: object
                    )
                case at(11, y: 68):
                    assertObjectRandomHero(
                        expected: .init(
                            identifierKind: .randomHero,
                            questIdentifier: 731346754,
                            owner: .red,
                            formation: .spread,
                            gender: .defaultGender
                        ), actual: object)
                default: break
                }
            }
        )
            
        try loadMap(id: .heroesOfMightNotMagicAllies, inspector: inspector)
        waitForExpectations(timeout: 1)
        
    }
}
