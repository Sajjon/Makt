//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-12.
//

import XCTest
import Foundation
import Malm
@testable import H3M

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/seers-hut.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/seers-hut.h3m

final class SeersHutOnMapTests: BaseMapTest {
    
    func testSeersHut() throws {
        let heroSorshaQuestID: UInt32 = 372973065
        let creaturePeasantsQuestID: UInt32 = 372973066
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
                
                func assertSeersHut(expected: Map.Seershut, line: UInt = #line) {
                    assertObjectSeersHut(expected: expected, actual: object, line: line)
                }
                
                switch object.position {
                case at(2, y: 10):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .archieveExperienceLevel(5),
                                messages: .init(
                                    proposalMessage: "I am old and wise, and I do not admit just anyone into my home.  You may enter when you have reached experience level 5.",
                                    progressMessage: "Faugh.  You again.  Come back when you are level 5, as I told you.",
                                    completionMessage: "I thought you had promise.  You have indeed reached level 5. Come in, come in.  Here, I have something to reward you for your efforts.  Do you accept?"
                                ),
                                deadline: .of(month: 3, week: 2, day: 1)
                            ),
                            bounty: .experience(1000)
                        )
                    )
                    
                case at(5, y: 10):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .archievePrimarySkillLevels(.init(attack: 1, defense: 2, power: 3, knowledge: 4)),
                                messages: .init(
                                    proposalMessage: "I am a biographer of great heroes.  I'd really like to meet a hero who has mastered Attack Skill 1, Defense Skill 2, Spell Power 3 and Knowledge 4.  I'd pay well for his story.",
                                    progressMessage: "Have you found a great hero for me to interview?  He must have reached Attack Skill 1, Defense Skill 2, Spell Power 3 and Knowledge 4.",
                                    completionMessage: "I've always wanted to meet someone as famous as you.  Will you let me write down your life story?"
                                )
                            ),
                            bounty: .spellPoints(10)
                        )
                    )
                    
                case at(8, y: 10):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .defeatHero(.init(id: heroSorshaQuestID)),
                                messages: .init(
                                    proposalMessage: "I was once rich and famous, but Sorsha the terrible was my downfall.  I lost my lands, I lost my title, and I lost my family.  Please, bring the villain to justice.",
                                    progressMessage: "Oh, I wish you brought better news.  It aches my heart that Sorsha still roams free.",
                                    completionMessage: "I thought the day would never come!  Sorsha is no more.  Please, will you accept this reward?"
                                )
                            ),
                            bounty: .moraleBonus(3)
                        )
                    )
                case at(11, y: 10):
                    assertObjectHero(
                        class: .knight,
                        expected: .init(
                            identifierKind: .specificHeroWithID(.sorsha),
                            questIdentifier: heroSorshaQuestID,
                            owner: .red
                        ), actual: object)
                case at(13, y: 10):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .defeatCreature(.init(id: creaturePeasantsQuestID)),
                                messages: .init(
                                    proposalMessage: "Peasants are menacing the northern region of this land.  If you could be so bold as to defeat them, I would reward you richly.",
                                    progressMessage: "Don't lose heart.  Defeating the Peasants is a difficult task, but you will surely succeed.",
                                    completionMessage: "At last, you defeated the Peasants, and the countryside is safe again!  Are you ready to accept the reward?"
                                )
                            ),
                            bounty: .luckBonus(2)
                        )
                    )
                case at(15, y: 10):
                    assertObjectMonster(
                        expected: .init(
                            .specific(creatureID: .peasant),
                            quantity: .random,
                            missionIdentifier: creaturePeasantsQuestID), actual: object)
                    
                case at(2, y: 12):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .returnWithArtifacts([.angelWings, .armsOfLegion]),
                                messages: .init(
                                    proposalMessage: "Long ago, powerful wizards were able to create magical artifacts, but time has caused us to forget how to make new items.  I would like to learn these techniques myself, but I need one of these artifacts first to see how it was done.  If you could bring me, the Angel Wings and Arms of Legion, you would be well rewarded.",
                                    progressMessage: "Nothing, eh?  I'm sure you will find the Angel Wings and Arms of Legion soon.  Please keep looking.",
                                    completionMessage: "Ah, exactly what I needed!  Here is the reward I promised.  You still wish to trade the Angel Wings and Arms of Legion, yes?"
                                )
                            ),
                            bounty: .resource(.init(kind: .sulfur, quantity: 10))
                        )
                    )
                case at(5, y: 12):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .returnWithCreatures([CreatureStack(kind: .specific(creatureID: .archer), quantity: 1), CreatureStack(kind: .specific(creatureID: .monk), quantity: 10)]),
                                messages: .init(
                                    proposalMessage: "I am an agent for an emperor of a distant land.  Recently, his armies have fallen on hard times.  If you could bring 1 Archer and 10 Monks to me, I could pay you handsomely.",
                                    progressMessage: "No luck in finding the 1 Archer and 10 Monks?  Please hurry, the empire depends on you.",
                                    completionMessage: "At last, the 1 Archer and 10 Monks that will save our empire!  Here is your payment. Are they ready to depart?"
                                )
                            ),
                            bounty: .primarySkill(.defense(2))
                        )
                    )
                case at(8, y: 12):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .returnWithResources([.wood(1), .mercury(2), .ore(3), .sulfur(4), .crystal(5), .gems(6), .gold(7)]),
                                messages: .init(
                                    proposalMessage: "I am researching a way to turn base metals into gold, but I am short of materials for my workshop.  If you could bring me 1 Wood, 2 Mercury, 3 Ore, 4 Sulfur, 5 Crystal, 6 Gems and 7 Gold, I would be most grateful.",
                                    progressMessage: "Oh my, that's simply not enough.  I need 1 Wood, 2 Mercury, 3 Ore, 4 Sulfur, 5 Crystal, 6 Gems and 7 Gold.  I'll never complete it with what you have.",
                                    completionMessage: "Finally!  Here, give the 1 Wood, 2 Mercury, 3 Ore, 4 Sulfur, 5 Crystal, 6 Gems and 7 Gold to me, and I'll give you this in return."
                                )
                            ),
                            bounty: .secondarySkill(.init(kind: .navigation, level: .advanced))
                        )
                    )
                    
                case at(13, y: 12):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .beHero(.malcom),
                                messages: .init(
                                    proposalMessage: "What I have is for Malcom alone.  I shall give it to none other.",
                                    progressMessage: "You are not Malcom.  Begone!",
                                    completionMessage: "Finally!  It is you, Malcom.  Here is what I have for you.  Do you accept?"
                                )
                            ),
                            bounty: .artifact(.angelicAlliance)
                        )
                    )
                    
                case at(2, y: 14):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .belongToPlayer(.tan),
                                messages: .init(
                                    proposalMessage: "I have a prize for those who fly the tan flag.",
                                    progressMessage: "Your flag is not tan.  I have nothing for you.  Begone!",
                                    completionMessage: "Ah, one who bears the tan flag.  Here is a prize for you.  Do you accept?"
                                )
                            ),
                            bounty: .spell(.magicMirror)
                        )
                    )
                case at(2, y: 16):
                    assertSeersHut(
                        expected: .init(
                            quest: .init(
                                kind: .belongToPlayer(.red)
                            ),
                            bounty: .creature(.init(kind: .specific(creatureID: .crusader), quantity: 2))
                        )
                    )
                case at(3, y: 20):
                    XCTAssertEqual(object.attributes.sprite, .seersHut_AVXseeb0) // Seers hut TREE
                    assertSeersHut(expected: .empty)
                case at(6, y: 20):
                    XCTAssertEqual(object.attributes.sprite, .seersHut_AVXseey0) // Seers hut mushroom
                    assertSeersHut(expected: .empty)
                default: break
                }
            }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension SeersHutOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "seers-hut", inspector: inspector)
    }
}
