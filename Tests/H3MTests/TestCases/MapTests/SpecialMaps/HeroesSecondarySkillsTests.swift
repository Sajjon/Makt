import XCTest
import Foundation
import Malm
@testable import H3M

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/secondary-skills.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/secondary-skills.h3m

final class HeroesSecondarySkillsTests: BaseMapTest {
    
    func testSecondarySkills() throws {
        
        let customized: [Player: [Hero.ID]] =
        [
            Player.red: [.valeska, .sylvia, .christian, .orrin, .tyris, .sorsha, .sirMullich, .edric],
            Player.blue: [.rion, .sanya, .cuthbert, .adela, .ingham, .caitlin, .adelaide, .loynis],
            Player.tan: [.thorgrim, .ryland, .jenova, .clancy, .mephala, .kyrre, .ivor, .ufretin],
            Player.green: [.coronius, .gem, .melodia, .alagar]
        ]
        
        var next = 0
        let questIDBase: UInt32 = 372973080
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, "") },
                onParseDescription: { XCTAssertEqual($0, "") },
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .small) },
                onFinishedParsingBasicInfo: { XCTAssertFalse($0.hasTwoLevels) }
            ),
            additionalInformationInspector: .init(
                onParseAvailableHeroes: {
                    let expected = Hero.ID.playable(in: .restorationOfErathia).all(but: customized.values.flatMap({ $0 }) + [.lordHaart]) + Hero.ID.conflux
                    XCTArraysEqual($0.values, expected)
                },
                onParseCustomHeroes: { XCTAssertNil($0) },
                onParseHeroSettings:  { XCTAssertNil($0) }
            ),
            onParseObject: { [self] object in
                
                func assertHero(
                    skills: Hero.SecondarySkills,
                    name maybeName: String? = nil,
                    questID maybeQuestID: UInt32? = nil,
                    line: UInt = #line
                ) {
                    defer { next += 1 }
                    let row = next.quotientAndRemainder(dividingBy: 8).quotient
                    let idx = next.quotientAndRemainder(dividingBy: 8).remainder
                    
                    let player = row == 0 ? Player.red : (row == 1 ? Player.blue : (row == 2 ? Player.tan : .green))
                    let heroID = customized[player]![idx]
                    
                    var name: String! = maybeName
                    if name == nil {
                        guard skills.count == 1 else {
                            XCTFail("Failed to automatically get name because skills contain multiple elements. We expected a single Secondary Skills and use that as name...", line: line)
                            return
                        }
                        name = String(describing: skills[0].kind)
                    }
                    
                    let questID = maybeQuestID ?? questIDBase + UInt32(next)
                    
                    assertObjectHero(
                        class: heroID.class,
                        expected: Hero(
                            identifierKind: .specificHeroWithID(heroID),
                            questIdentifier: questID,
                            portraitID: nil,
                            name: name,
                            owner: player,
                            startingSecondarySkills: skills
                        ),
                        actual: object,
                        line: line
                    )
                }
                
                func assertHero(
                    skill skillKind: Hero.SecondarySkill.Kind,
                    name: String? = nil,
                    questID: UInt32? = nil,
                    line: UInt = #line
                ) {
                    assertHero(
                        skills: [.init(kind: skillKind, level: .basic)],
                        name: name,
                        questID: questID,
                        line: line
                    )
                }
                
                
                switch object.position {
                case at(2, y: 1):
                    assertHero(skill: .pathfinding)
                case at(5, y: 1):
                    assertHero(skill: .archery)
                case at(8, y: 1):
                    assertHero(skill: .logistics)
                case at(11, y: 1):
                    assertHero(skill: .scouting)
                case at(14, y: 1):
                    assertHero(skill: .diplomacy)
                case at(17, y: 1):
                    assertHero(skill: .navigation)
                case at(20, y: 1):
                    assertHero(skill: .leadership)
                case at(23, y: 1):
                    assertHero(skill: .wisdom)
                case at(2, y: 3):
                    assertHero(skill: .mysticism)
                case at(5, y: 3):
                    assertHero(skill: .luck)
                case at(8, y: 3):
                    assertHero(skill: .ballistics, name: "balistics")
                case at(11, y: 3):
                    assertHero(skill: .eagleEye, name: "eagle eye")
                case at(14, y: 3):
                    assertHero(skill: .necromancy, name: "necromacy")
                case at(17, y: 3):
                    assertHero(skill: .estates)
                case at(20, y: 3):
                    assertHero(skill: .fireMagic, name: "fire magic")
                case at(23, y: 3):
                    assertHero(skill: .airMagic, name: "air magic")
                case at(2, y: 5):
                    assertHero(skill: .waterMagic, name: "water magic")
                case at(5, y: 5):
                    assertHero(skill: .earthMagic, name: "earch magic")
                case at(8, y: 5):
                    assertHero(skill: .scholar)
                case at(11, y: 5):
                    assertHero(skill: .tactics)
                case at(14, y: 5):
                    assertHero(skill: .artillery, name: "artilery")
                case at(17, y: 5):
                    assertHero(skill: .learning)
                case at(20, y: 5):
                    assertHero(skill: .offense, name: "offence")
                case at(23, y: 5):
                    assertHero(skill: .armorer, name: "armorrer")
                case at(2, y: 7):
                    assertHero(skill: .intelligence, name: "inteligence")
                case at(5, y: 7):
                    assertHero(skill: .sorcery)
                case at(8, y: 7):
                    assertHero(skill: .resistance)
                case at(11, y: 7):
                    assertHero(skill: .firstAid, name: "first aid")
                default:
                    XCTFail("Unexpected object found at: \(object.objectID), object: \(object)")
                }
            }
        )
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension HeroesSecondarySkillsTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "secondary-skills", inspector: inspector)
    }
}
