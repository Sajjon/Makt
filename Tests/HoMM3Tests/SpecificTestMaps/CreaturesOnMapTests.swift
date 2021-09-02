//
//  CreaturesOnMapTests.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-01.
//

import XCTest
import Foundation
@testable import HoMM3SwiftUI

/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/creatures.h3m

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
/// Map from: https://github.com/srg-kostyrko/homm3-parser/blob/master/__tests__/maps/creatures.h3m

final class CreaturesOnMapTests: BaseMapTest {
    
    func testCreaturesOnMap() throws {
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
                
                func assertMonster(
                    kind: Map.Monster.Kind,
                    quantity: Map.Monster.Quantity = .random,
                    grows: Bool = true,
                    disposition: Map.Monster.Disposition = .aggressive,
                    mayFlee: Bool = true,
                    message: String? = nil,
                    treasure: Map.Monster.Bounty? = nil,
                    _ line: UInt = #line
                ) {
                    guard case let .monster(monster) = object.kind else {
                        XCTFail("Expected monster, but got: \(object.kind)")
                        return
                    }
                    XCTAssertEqual(monster.kind, kind, line: line)
                    XCTAssertEqual(monster.quantity, quantity, line: line)
                    
                    
                    XCTAssertEqual(monster.doesNotGrowInNumbers, !grows, "Expected `doesNotGrowInNumbers` to be \(!grows).", line: line)
                    XCTAssertEqual(monster.willNeverFlee, !mayFlee, "Expected `willNeverFlee` to be \(!mayFlee).", line: line)
                    XCTAssertEqual(monster.disposition, disposition, line: line)
                    XCTAssertEqual(monster.bounty, treasure, line: line)
                    XCTAssertEqual(monster.message, message, line: line)
                    XCTAssertNotNil(monster.missionIdentifier, line: line)
                    fullfill(object: object)
                }
                
                func assertCreature(
                    _ creatureID: Creature.ID,
                    quantity: Map.Monster.Quantity = .random,
                    grows: Bool = true,
                    disposition: Map.Monster.Disposition = .aggressive,
                    mayFlee: Bool = true,
                    message: String? = nil,
                    treasure: Map.Monster.Bounty? = nil,
                    _ line: UInt = #line
                ) {
                    assertMonster(
                        kind: .specific(creatureID: creatureID),
                        quantity: quantity,
                        grows: grows,
                        disposition: disposition,
                        mayFlee: mayFlee,
                        message: message,
                        treasure: treasure, line
                    )
                }
                
                func assertRandomMonster(
                    level: Creature.Level? = .any,
                    quantity: Map.Monster.Quantity = .random,
                    grows: Bool = true,
                    disposition: Map.Monster.Disposition = .aggressive,
                    mayFlee: Bool = true,
                    message: String? = nil,
                    treasure: Map.Monster.Bounty? = nil,
                    _ line: UInt = #line
                ) {
                    assertMonster(
                        kind: .random(level: level),
                        quantity: quantity,
                        grows: grows,
                        disposition: disposition,
                        mayFlee: mayFlee,
                        message: message,
                        treasure: treasure, line
                    )
                }
                
                switch object.position {
                case at(0, y: 0):
                    assertCreature(
                        .dwarf,
                        quantity: .custom(1337),
                        grows: false,
                        disposition: .savage,
                        mayFlee: false,
                        message: "Added by Cyon: Dwarfes, 1337 of them and savage! Also never flees. Rewarded with Shackles of War artifact and 40 wood, 50 mercury, 60 ore, 70 sulfur, 80 crystal, 90 gems and 100 gold. Make sure 100 gold is not counted as just 1 gold. Parsed number should be multiplied by one hundred I think.",
                        treasure: .init(
                            artifactID: .shacklesOfWar,
                            resources: .init(
                                resources: [
                                    .init(kind: .wood, amount: 40),
                                    .init(kind: .mercury, amount: 50),
                                    .init(kind: .ore, amount: 60),
                                    .init(kind: .sulfur, amount: 70),
                                    .init(kind: .crystal, amount: 80),
                                    .init(kind: .gems, amount: 90),
                                    .init(kind: .gold, amount: 100),
                                ]
                            )
                        )
                    )
                case at(1, y: 1):
                    assertCreature(.pikeman)
                case at(3, y: 1):
                    assertCreature(.halberdier)
                case at(5, y: 1):
                    assertCreature(.archer)
                case at(7, y: 1):
                    assertCreature(.marksman)
                case at(9, y: 1):
                    assertCreature(.griffin)
                case at(11, y: 1):
                    assertCreature(.royalGriffin)
                case at(13, y: 1):
                    assertCreature(.swordsman)
                case at(15, y: 1):
                    assertCreature(.crusader)
                case at(17, y: 1):
                    assertCreature(.monk)
                case at(19, y: 1):
                    assertCreature(.zealot)
                case at(21, y: 1):
                    assertCreature(.cavalier)
                case at(23, y: 1):
                    assertCreature(.champion)
                case at(25, y: 1):
                    assertCreature(.angel)
                case at(27, y: 1):
                    assertCreature(.archangel)
                case at(1, y: 3):
                    assertCreature(.centaur)
                case at(3, y: 3):
                    assertCreature(.centaurCaptain)
                case at(5, y: 3):
                    assertCreature(.dwarf)
                case at(7, y: 3):
                    assertCreature(.battleDwarf)
                case at(9, y: 3):
                    assertCreature(.woodElf)
                case at(11, y: 3):
                    assertCreature(.grandElf)
                case at(13, y: 3):
                    assertCreature(.pegasus)
                case at(15, y: 3):
                    assertCreature(.silverPegasus)
                case at(17, y: 3):
                    assertCreature(.dendroidGuard)
                case at(19, y: 3):
                    assertCreature(.dendroidSoldier)
                case at(21, y: 3):
                    assertCreature(.unicorn)
                case at(23, y: 3):
                    assertCreature(.warUnicorn)
                case at(25, y: 3):
                    assertCreature(.greenDragon)
                case at(27, y: 3):
                    assertCreature(.goldDragon)
                    
                case at(1, y: 5):
                    assertCreature(.gremlin)
                case at(3, y: 5):
                    assertCreature(.masterGremlin)
                case at(5, y: 5):
                    assertCreature(.stoneGargoyle)
                case at(7, y: 5):
                    assertCreature(.obsidianGargoyle)
                case at(9, y: 5):
                    assertCreature(.stoneGolem)
                case at(11, y: 5):
                    assertCreature(.ironGolem)
                case at(13, y: 5):
                    assertCreature(.mage)
                case at(15, y: 5):
                    assertCreature(.archMage)
                case at(17, y: 5):
                    assertCreature(.genie)
                case at(19, y: 5):
                    assertCreature(.masterGenie)
                case at(21, y: 5):
                    assertCreature(.naga)
                case at(23, y: 5):
                    assertCreature(.nagaQueen)
                case at(25, y: 5):
                    assertCreature(.giant)
                case at(27, y: 5):
                    assertCreature(.titan)
                    
                 
                   
                case at(1, y: 7):
                    assertCreature(.imp)
                case at(3, y: 7):
                    assertCreature(.familiar)
                case at(5, y: 7):
                    assertCreature(.gog)
                case at(7, y: 7):
                    assertCreature(.magog)
                case at(9, y: 7):
                    assertCreature(.hellHound)
                case at(11, y: 7):
                    assertCreature(.cerberus)
                case at(13, y: 7):
                    assertCreature(.demon)
                case at(15, y: 7):
                    assertCreature(.hornedDemon)
                case at(17, y: 7):
                    assertCreature(.pitFiend)
                case at(19, y: 7):
                    assertCreature(.pitLord)
                case at(21, y: 7):
                    assertCreature(.efreeti)
                case at(23, y: 7):
                    assertCreature(.efreetSultan)
                case at(25, y: 7):
                    assertCreature(.devil)
                case at(27, y: 7):
                    assertCreature(.archDevil)
                    
                   
                case at(1, y: 17):
                    assertCreature(.pixie)
                case at(3, y: 17):
                    assertCreature(.sprite)
                case at(5, y: 17):
                    assertCreature(.waterElemental)
                case at(7, y: 17):
                    assertCreature(.iceElemental)
                case at(9, y: 17):
                    assertCreature(.earthElemental)
                case at(11, y: 17):
                    assertCreature(.magmaElemental)
                case at(13, y: 17):
                    assertCreature(.airElemental)
                case at(15, y: 17):
                    assertCreature(.stormElemental)
                case at(17, y: 17):
                    assertCreature(.fireElemental)
                case at(19, y: 17):
                    assertCreature(.energyElemental)
                case at(21, y: 17):
                    assertCreature(.psychicElemental)
                case at(23, y: 17):
                    assertCreature(.magicElemental)
                case at(25, y: 17):
                    assertCreature(.firebird)
                case at(27, y: 17):
                    assertCreature(.phoenix)
                  
                    
                case at(1, y: 19):
                    assertCreature(.goldGolem)
                case at(3, y: 19):
                    assertCreature(.diamondGolem)
                case at(5, y: 19):
                    assertCreature(.azureDragon)
                case at(7, y: 19):
                    assertCreature(.crystalDragon)
                case at(9, y: 19):
                    assertCreature(.faerieDragon)
                case at(11, y: 19):
                    assertCreature(.rustDragon)
                case at(13, y: 19):
                    assertCreature(.enchanter)
                case at(15, y: 19):
                    assertCreature(.sharpshooter)
                case at(17, y: 19):
                    assertCreature(.halfling)
                case at(19, y: 19):
                    assertCreature(.peasant)
                case at(21, y: 19):
                    assertCreature(.boar)
                case at(23, y: 19):
                    assertCreature(.mummy)
                case at(25, y: 19):
                    assertCreature(.nomad)
                case at(27, y: 19):
                    assertCreature(.rogue)
                case at(29, y: 19):
                    assertCreature(.troll)
               
                case at(1, y: 21):
                    assertRandomMonster(level: .any)
                case at(3, y: 21):
                    assertRandomMonster(level: .one)
                case at(5, y: 21):
                    assertRandomMonster(level: .two)
                case at(7, y: 21):
                    assertRandomMonster(level: .three)
                case at(9, y: 21):
                    assertRandomMonster(level: .four)
                case at(11, y: 21):
                    assertRandomMonster(level: .five)
                case at(13, y: 21):
                    assertRandomMonster(level: .six)
                case at(15, y: 21):
                    assertRandomMonster(level: .seven)
                    
                case at(1, y: 25):
                    assertRandomMonster(disposition: .compliant, message: "compliant")
                case at(3, y: 25):
                    assertRandomMonster(disposition: .friendly, message: "friendly")
                case at(5, y: 25):
                    assertRandomMonster(disposition: .aggressive, message: "aggressive")
                case at(7, y: 25):
                    assertRandomMonster(disposition: .hostile, message: "hostile")
                case at(9, y: 25):
                    assertRandomMonster(disposition: .savage, message: "savage")
                case at(15, y: 25):
                    assertRandomMonster(mayFlee: false, message: "never flees")
                case at(18, y: 25):
                    assertRandomMonster(quantity: .custom(10), grows: false, message: "qty")
                    
                case at(22, y: 25):
                    assertRandomMonster(
                        message: "treasure",
                        treasure: .init(
                            artifactID: .angelWings,
                            resources: .init(
                                resources: [
                                    .init(kind: .wood, amount: 1),
                                    .init(kind: .mercury, amount: 2),
                                    .init(kind: .ore, amount: 3),
                                    .init(kind: .sulfur, amount: 4),
                                    .init(kind: .crystal, amount: 5),
                                    .init(kind: .gems, amount: 6),
                                    .init(kind: .gold, amount: 10),
                                ]
                            )))
                    
                case at(35, y: 35):
                    assertCreature(
                        .battleDwarf,
                        quantity: .custom(314),
                        disposition: .compliant,
                        message: "Added by Cyon: 314 complieant battle dwarves offering the artifact Speculum and 31415 gold.",
                        treasure: .init(
                            artifactID: .speculum,
                            resources: .init(
                                resources: [
                                    .init(kind: .gold, amount: 31415),
                                ]
                            )
                        )
                    )
                default: break
                }
            },
            onParseEvents: { events in
                XCTAssertEqual(events.events.count, 2)
                let firstEvent = events.events[0]
                XCTAssertEqual(firstEvent.name, "This is the name of a \"timed event\".")
                XCTAssertEqual(firstEvent.message, "We use this timed event as a marker to verify that we have correctly parsed all creatures in this map, because events are positioned at the end of the file. This event applies to both human an computer.The first day of occurerence is 237 and it repeats every 21 days.")
                XCTAssertTrue(firstEvent.availability.appliesToComputerPlayers)
                XCTAssertTrue(firstEvent.availability.appliesToHumanPlayers)
                XCTAssertEqual(firstEvent.occurrences.first, 237-1) // apparently we need to subract one...
                XCTAssertEqual(firstEvent.occurrences.subsequent, .every21Days)
                
                let secondEvent = events.events[1]
                XCTAssertEqual(secondEvent.name, "Last event with message reaching character limit of 29861 chars.")
                XCTAssertEqual(secondEvent.message, longEventMessage)
                XCTAssertEqual(secondEvent.occurrences.first, 672-1) // apparently we need to subract one...
                XCTAssertEqual(secondEvent.occurrences.subsequent, .never)
                XCTAssertTrue(secondEvent.availability.appliesToComputerPlayers)
                XCTAssertFalse(secondEvent.availability.appliesToHumanPlayers)
            }
        )
        
        
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension CreaturesOnMapTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: "creatures-cyon-modified", inspector: inspector)
    }
}

private let longEventMessage = """
A second event, starting at day 672, which seems to be max. Only applies to computer. Seems it MUST apply to either or by the way, never repeats.

Heroes of Might & Magic III

We take a closer look at this highly anticipated strategy game from New World Computing.

February 17, 1999

02/17/99
There's no doubt that Heroes of Might and Magic II was one of the greatest strategy games ever made. Not only did it win a load of different awards from various magazines, but it did so at a time when real time strategy game developers were proclaiming the turn based adventure dead. Even so, there have been a lot of great games over the years that have been ruined by designers trying to make them bigger, better or faster. So it was not with a small amount of trepidation that I loaded up my advance copy of Heroes of Might and Magic 3, New World's latest addition to the series. I have to admit that was worried that the company might have tried to change the formula that has worked so well, or that 3DO, New World's new owners, might have tried to put a more 'marketable' spin on the game. After a week of non stop play, I realize that my fears were completely unfounded. From what we've seen so far, Heroes of Might and Magic III is destined to not just match its predecessors in quality, but to surpass them greatly.

The first thing you're likely to notice is that the game has a much more polished look and feel than the first two games in the series. Not only is the artwork itself much cleaner, but the interface screens and controls are much easier to use and reflect a great deal more insight on the part of New World. Each of the monsters in the game (and there a bunch of 'em) look great and have been represented in several different ways for each place that you see them (in towns you get little photos as opposed to the full body shots you'll see in battle).

So what about the game itself? I can't tell you how addictive it is. Fans of the original games will feel right at home with the controls and will be able to pick up and play without a moment's thought. Even so, there are several new additions to gameplay that keep the title from falling into the 'more of the same' trap. First off, you can now build up a town economically as well as defensively. Instead of just jumping from villiage to castle, you can now build up the walls of your city from town, to fortress, to castle, to citadel. Each of these offers you a bonus to your monster populations as well as making it much harder for an enemy to win a siege battle. Later levels offer you arrow towers that will automatically take potshots at your attackers each round (in a siege) which will reduce the chance of a small army winning a battle to nearly zero. Separate from all of this is your town center, where you give the orders for different buildings to be constructed. This structure can be upgraded to a city hall and then to a capital each of which will earn you more money each day. As you may remember from the first two titles, money is life, so I recommend you build up your cities' economies as quickly as possible. Other structures commonly available include marketplaces that allow you to trade resources (at an exchange rate that improves with each marketplace under your control) and resource centers that increase the amount of wood and ore you generate each round. Blacksmiths are also available and will help you construct ballista and catapults to aid you in large battles. Another important building is the tavern, where you'll be able to hire new heroes, as they become available.

Each of the different town types offers its own monsters (as in the first two titles) but also offers new types of buildings as well. In necropolis settings you'll be able to build a cloud generator that will keep the enemy from being able to view activity around your city and skeleton generators that will enable you to turn any other creature into a skeleton. In the swamp cities you'll be able to construct special glyphs that will help you defend your town in the vent of a siege. Some cities even allow you to build learning centers that will give experience to every general you have visit. If you want to make winning easier, you'll try to get as many different city types as you can in order to enjoy the special advantages of each. Better still, this tactic will also give you access to as many of the different monsters available in the game as possible.

So what about the monsters? There's an awful lot of them and they're pretty damn cool. Each city type has its own fighting forces, and at the most basic level they're all pretty even. Swamp towns turn out gnolls, necropoli turn out skeletons, castles turn out pikemen, and so on. These fodder characters aren't going to get you very far, so you'll want to start upgrading your production centers as soon as possible. As with the first two titles, a lot of the monster generation structure require other buildings as requirements, so the best idea is to try and figure out what you ultimately want your army to be made up of and then work your way towards that goal. Before you know it, you'll have access to Gold Dragons (mountain cities), Ghost Dragons (necropoli), Chaos Hydras (swamp towns), Archangels (castles), Archdevils (inferno cities), and many others. Most of these heavy hitters have special powers that make them extremely useful in certain types of combat the Chaos Hydras can attack any adjacent hex at the same time, Archdevils can teleport, and so on. These powers should be taken into account before you enter a battle if you want to make sure that your best (and most expensive) troops don't get killed on a battlefield that doesn't suit their particular type of fighting.

It's still too soon for us to begin reviewing the game (we still haven't gotten gold, only beta copies),but I have to say, unless something goes horribly wrong, this game is going to be a big winner. Keep checking back as we get closer to the game's March release date (our sources at 3DO hint that it'll probably be the second week of March) for a full review based on a production copy. In the meantime, be sure to check out the shots we've grabbed from the version we have now.

   Trent C. Ward

==============================

I'm ready for my neural implant now. Crack open my skull and stab that little microprocessor deep into my medulla oblongata. I happily embrace my cyborg future. At least as some unholy union of man and machine I'll actually be able to play Heroes of Might and Magic III every waking hour instead of just thinking about it every second that I'm away from my computer.

For those of you unfamiliar with the series, Heroes of Might and Magic III (HOMMIII) puts you in the position of commanding armies of dragons, vampires, knights, and the like in a traditional fantasy setting. The turn based gameplay is divided in thirds: An expansive adventure map, where your heroes traverse the terrain in search of resources and enemies; city maps for each town, where players build structures and purchase units; and a hex based combat map, where battles play out like elaborate, magic enhanced chess matches.

In addition to resource management, building, and combat, gamers are charged with managing heroes who lead the armies. Heroes accrue experience with every successful battle, allowing them to gain and enhance a host of abilities that affect their performance. It's a delicately balanced, thoroughly engaging formula that has made the Heroes games a truly stellar series.

Bigger Than Life
HOMMIII expands upon the insanely addictive play of the previous edition, retaining the core gameplay while enhancing almost every facet of the game. This is first apparent in the size of all the maps. The adventure maps are frequently enormous, and several of them feature a new subterranean level that effectively doubles their size. Town maps have ballooned to hold a host of new buildings, and combat maps are about twice the size of their counterparts in the last game   all the better to accommodate the new armies that can now hold up to seven different unit types.

But that's just the tip of the iceberg. There are now eight different types of towns, each generating a unique set of creatures requiring a specific combat strategy: The devastating hand to hand attacks of castle units demand a head on assault, while the ranged attacks of units from tower towns benefit from a more defensive posture. Every monster in the game has an upgrade available, whereas Heroes II allowed only some of its units to be upgraded. Most units have special attacks/attributes that impact combat strategy. For example, incredibly powerful archangels can resurrect fallen comrades, while undead ghost dragons can age opponents, thus halving their hit points. Every unit is now rendered in 3D, with a more realistic look than the cartoonish units of the previous game.

Finally, a slew of new heroes and artifacts throws more strategic factors into the mix. Every hero has an innate special ability   such as being able to gain a bonus when commanding certain troops   and there are lots of new abilities to acquire as well. One new ability, tactics, lets heroes move their forces within a limited range immediately prior to a battle   it's great for offense minded heroes, letting them move ranged units into prime positions while cutting down the distance melee units have to travel.

All this makes for a game that is mind boggling in its depth, and the designers deserve praise for adding so much while managing to dodge the paralyzing feature bloat that could have easily sunk the title. Unfortunately, they also deserve a slap on the wrist for a tutorial that requires players to either print out a huge manual or constantly toggle between the game and a text file.

Storyteller Theatre
HOMMIII breaks from its predecessors in its campaign mode. Instead of a pair of linear campaigns with a few branches, the campaign is broken up into six minicampaigns of three to four scenarios apiece. While this lets the game tell a more interesting story, fans of the series will probably miss the either/or branches of Heroes II that rewarded them for taking on more challenging scenarios. The campaign mode's greatest drawback is that gamers can't load individual scenarios from completed minicampaigns   you have to save each scenario at its start to replay it. While the campaign game is loaded with more than 20 great, challenging scenarios featuring a variety of goals   including wiping out enemies, seizing specific towns, escort missions, and more   they're unevenly paced, with one cruelly hard mission finishing up the relatively easy second campaign (see sidebar for tips on beating this scenario) before lapsing into easy mode for the next campaign.

Fortunately, the game ships with an enormous number of mostly customizable single scenarios, giving the game remarkable replayability, while the map editor that's included ensures that tons of user created maps will be available online.

HOMMIII has improved its multiplayer play, allowing for timed turns and letting strategists scan the map and their towns during an opponent's turn; while you can't issue orders during your enemy's turn, at least it's better than just staring at your monitor. A problem with DirectPlay makes Internet HOMMIII a sluggish experience, but that should be corrected in an upcoming patch.

Ultimately, the rewards of Heroes of Might and Magic III far outweigh its few drawbacks. Hopefully most of those shortcomings will be patched, but even as it stands now HOMMIII is a game that strategy fans should absolutely be playing.

By Robert Coffey

Posted 07/01/99

==============================

Heroes Of Might And Magic III: The Restoration Of Prador jumps straight into the top 10 in our Longest Game Names Of All Time list. But that's not its only charting performance it also happens to be the successor to our favourite fantasy strategy game of all time. Heroes has grown out of the Might & Magic roleplaying series, also by New World Computing, taking the fantasy world created in that title (of which there are seven versions) and turning it into a turn based strategy game that includes artefacts, inventories, quests and puzzle solving.

For those unfamiliar with it there are three main playing elements in a game of Heroes Of Might And Magic: map movement, city management and battle. The first is the main playing screen view where you start off with a hero, illustrated by a cute little character on a horse. True to its roleplaying roots your hero is from a particular character class (Wizard, Knight, Barbarian and so on) and has his own attack and defence ratings, a knowledge rating, a movement allowance and various additional abilities, all of which can be enhanced by gaining experience levels or picking up and carrying artefacts.

Each hero also has eight 'slots' on their stats screen where the fighting units under his or her command are placed. Although this limits the number of different units that can be commanded, it does not place any limitation on the quantity of any individual unit type. You can start out with just a few and end up with over a thousand! Each hero and his or her army moves around, picking up resources, capturing buildings, fighting enemies and duelling neutral characters for prizes. Monuments can also be visited which reveal a piece of a puzzle at a time, and old men in huts might give you valuable artefacts in return for doing them a favour.

The second significant part of the game is the city/base management element where you have to build and upgrade your captured towns to produce creatures, ranging from skeletons and goblins to giants and dragons. And when you have a decent army and a reasonably competent hero you can go to battle. This involves a set piece combat screen where the action (if you can call it that) takes place in a hex based environment. Your hero doesn't actually fight, instead his attributes and experience affect the abilities and hit points of the army under his command. Once your hero has learned magic, however, he can use some on the enemy at the beginning of every full turn.

To give you an idea of the scale of the game, there are 16 different hero classes with 128 heroes in total to hire, nine different types of home base, with seven individual units to produce at each base, all of which have an upgrade giving you a total of 122 units to master, and that's not including neutrals. Spells are divided into Water, Earth, Air and Fire classes and there are over 70. As for artefacts... suffice to say there is huge detail here. Previous Heroes game players will already see the increase in all of the above, and other changes include underground maps to add an extra dimension and a big, big change in graphics to a much cleaner look though the overall principles differ little.

The main control interface is easy to use once you're acclimatised and it's packed full of at a glance information. The battle interface is simple and clean, although I think there should have been a speed up button on the defensive siege screen when you know you're going to lose there's no sense in prolonging the agony. But that's about my only problem with the interface, which has more options than a top of the range Mercedes Benz and is easy to use, with a complete set of keyboard shortcuts if clicking the mouse becomes all too much for you though since this is a turn based game, time is hardly of the essence.

Indeed time better not mean much to you if you decide to play Heroes III. Once you're hooked it sucks up hours like few others games I have played as it's turn based, though, they are stress free hours. As a result you can spend 10 hours at a time playing and not really notice it all slipping by.

I can't really complain that Heroes Of Might & Magic III is too like its predecessor, because Heroes II pretty much perfected the art of applying roleplaying values to a turn based strategy game. This version is more beautiful and more complex and you'll spend the first few games dog earing the manual in an effort to get to grips with everything you can pick up and everything you can potentially fight. In many ways if this is the first Heroes game you are considering purchasing, you might think of starting with Heroes II to acclimatise yourself but you'll be back for more, don't worry.

Heroes Of Might & Magic III is a timeless and wonderful game that will keep you occupied for many months. If you like fantasy roleplaying and wargaming and you haven't tried this series yet I would advise you to do so and find out just what you're missing.

==============================

Heroes of Might and Magic III: The Restoration of Erathia (commonly referred to as Heroes of Might & Magic 3, or simply Heroes 3) is a turn based strategy game developed by Jon Van Caneghem through New World Computing originally released for Microsoft Windows by the 3DO Company in 1999. Its ports to several computer and console systems followed in 1999 to 2000. It is the third installment of the Heroes of Might and Magic series.

The game's story is first referenced throughout Might and Magic VI: The Mandate of Heaven and serves as a prequel to Might and Magic VII: For Blood and Honor. The player can choose to play through seven different campaigns telling the story, or play in a scenario against computer or human opponents.

Heroes III was released to universal acclaim and was praised by critics. The game received the expansion packs Heroes of Might and Magic III: Armageddon's Blade and Heroes of Might and Magic III: The Shadow of Death. Heroes Chronicles, a series of short introductory games based on the Heroes III engine, was also released. A special version of Heroes III titled Heroes III Complete, which included the original game and both expansion packs, was released in 2000.

The gameplay is very similar to its predecessors in that the player controls a number of heroes that command an army of creatures inspired by myth and legend. The gameplay is divided into two parts, tactical overland exploration and a turn based combat system. The player creates an army by spending resources at one of the eight town types in the game. The hero progresses in experience by engaging in combat with enemy heroes and monsters. The conditions for victory vary depending on the map, including conquest of all enemies and towns, collection of a certain amount of a resource, or finding the grail artifact.

Gameplay consists of strategic exploration on the world map and tactical turn based combat. As with the series in general, the player controls a number of "heroes" who act as generals and command troops comprising various types of creatures inspired by myth and legend. The player can complete or "win" a map by completing the objectives set out by the creator of the map. Objectives may include eliminating all the other factions in the game, gathering a set amount of resources, or piecing together a puzzle to find the Grail artifact. If a player loses all of their towns they will have seven game days to capture a new town. If they fail to do so they lose and the game ends. If a player loses all their heroes and towns, they will lose the game.

There are two "layers" to the world map: the aboveground and the underground. There are typically subterranean gateways that lead to and from the underground. Maps are filled with a huge variety of buildings, treasures, monsters, mines and so forth that reward extensive exploration. At the very least, a player must locate mines and flag them (whereupon they provide constant resources), since these resources are required to develop towns. The player must also develop their heroes' primary and secondary skills, both by battling creatures (and enemy heroes) and by acquiring artifacts or visiting special locations. Heroes are given a choice of skills to upgrade upon leveling up, as well as becoming better at combat or using magic. The skills must be chosen carefully, since they are permanent and only a limited number of skills can be learned.

The player's towns serve many functions, but most importantly they allow recruitment of creatures to form armies. Towns also provide funds, new spells and a fortified location to make a last stand against an invading enemy hero. To build new structures within a town requires gold and usually one or more type of resource. Wood and ore are needed for most structures, but more expensive buildings also require rarer resources (mercury, crystal, gems or sulfur). All factions require a disproportionate quantity of just one of these special resources, making the acquisition of a corresponding mine essential to victory. This same resource is also needed when hiring the most powerful creatures available to that faction. Each faction also has a handful of unique structures available only to them.

If a player finds the Grail artifact, they can deliver it to a town to make that town the Grail's permanent home by creating a special structure. The Grail bestows greatly increased creature growth and weekly income, in addition to a bonus unique to the town.

The eight different castles available in Heroes III are classified as good, evil, and neutral. Each town has seven basic creatures, each of which can be upgraded to a more powerful variant. Each town also features two associated hero types: one that leans more toward might (combat), and one that leans more toward magic.

Plot

The game's story unfolds primarily through a series of seven playable campaigns, all set upon the continent of Antagarich. During the campaigns, the story is told from alternating points of view, giving players the opportunity to play as each of the town alignments.

Following the disappearance of King Roland Ironfist of Enroth prior to Might and Magic VI: The Mandate of Heaven, his wife, Queen Catherine, is left to rule the realm. In the meantime, her father, King Gryphonheart of Erathia, is assassinated. Without their beloved King, the kingdom of Erathia falls to the dark forces of Nighon and Eeofol. Queen Catherine returns home to Antagarich seeking to rally the people of her homeland and lead them against the evil that has ravaged their nation.

Erathia's capital of Steadwick is sacked by the dungeon lords of Nighon and the Kreegans of Eeofol. Meanwhile, the nations of Tatalia and Krewlod skirmish at the western border, seizing the chance to expand their territory. Catherine's first task is to establish a foothold in the conquered kingdom by enlisting the aid of allies. The wizards of Bracada and the elves of AvLee answer her call, and together they push towards Steadwick and eventually retake it, quickly quelling the border war in the west. Soon after, Lucifer Kreegan, a commander in the Eeofol armies, sends an envoy to Erathia claiming that Roland Ironfist is captive within their territories. AvLee invades Eeofol, but fails to rescue Roland, who is transported to their northern holdings. Afterwards, Catherine invades Nighon, pushing the dungeon armies back to their island home.

In the meantime, the necromancers of Deyja, having been responsible for the assassination of King Gryphonheart, plot to revive his corpse as a lich. They plan to use his wisdom in leading their own armies of the undead. However, King Gryphonheart's will proves too much for the necromancers even in his corrupted state, and he becomes a rogue lich. Having little other recourse, Queen Catherine is forced to ally herself with the necromancers and together they set out to destroy the lich of King Gryphonheart before he becomes too powerful.

A final bonus campaign, accessible only after the main campaigns are complete, tells the story of separatists living in the Contested Lands, a war torn border between Erathia and AvLee. Tired of the skirmishes that bring unrest to their homelands, they join together to fight for independence from the two large kingdoms. It is later implied that this rising was orchestrated by Archibald Ironfist, the antagonist of Heroes of Might and Magic II.

The game was originally released for PC Windows on March 3, 1999. An Apple Macintosh port was released by 3DO, and a Linux port was released by Loki Software, both in late December that year. In 2000, a Game Boy Color port entitled Heroes of Might and Magic 2 was released. A straight Dreamcast port retaining the original title was also developed and completed, but it wasn't released due to technical issues that prevented the console running the game adequately.

Two official expansion packs were released for Heroes III. The first of these expansions, Armageddon's Blade, introduced a ninth town alignment, the Conflux; a random scenario generator, a variety of new creatures, heroes, and structures; and six new playable campaigns.

The second expansion, The Shadow of Death, was a standalone expansion that included Restoration of Erathia and added seven new playable campaigns and a variety of new artifacts, including Combination Artifacts. Combination Artifacts were extremely powerful items assembled by collecting a specific set of lesser artifacts.

In 2000, a bundle containing Heroes III and both expansion packs was released as Heroes of Might and Magic III: Complete. More than just bundling the original game discs, however, this release reworked the game's installation process as well as its ingame menus to reflect a unified product.

A fanmade expansion, In the Wake of Gods (also titled Heroes 3.5), was released in 2001. It adds new creatures, including eighth level creatures and "God's representatives", which give bonus to heroes' primary skills. Heroes can also destroy and rebuild towns.

Horn of the Abyss, a second free community expansion, was announced in 2008 and released on December 31, 2011. It adds a new town type, a large number of new items to put on maps, support for giant maps, a graphical random map generator template editor, among other features.

Heroes of Might and Magic III entered PC Data's weekly computer game sales charts at #3 for the February 28 March 6 period. It held the position for another two weeks, before exiting the weekly top 10 in its fourth week. It was the United States' second best selling computer game of March 1999. PC Data, which tracked sales in the United States, reported that Heroes III had sold 185,553 copies in September 2000. The combined global sales of the Heroes series had reached 1.5 million copies by December 1999.

Heroes III was praised by critics, receiving an average score of 87% in GameRankings.

Next Generation reviewed the PC version of the game, rating it four stars out of five, and stated that "While realtime strategy withers on the vine, with many recent releases lackluster at best, HoMM reminds us that turn based play is alive and well. In fact, it's hard to remember why people said turn based was dead in the first place."

Computer Gaming World's Robert Coffey said that the game "expands upon the insanely addictive play of the previous edition, retaining the core gameplay while enhancing almost every facet of the game". He continued to say that the game is "mind boggling in its depth", but criticized its uneven campaign pacing and "sluggish" connection speeds during online play. He concluded: "Ultimately, the rewards of Heroes of Might and Magic III far outweigh its few drawbacks. ... [This] is a game that strategy fans should absolutely be playing".

Heroes of Might and Magic III was a finalist for Computer Games Strategy Plus's 1999 "Strategy Game of the Year" prize, although it lost to RollerCoaster Tycoon. The editors wrote that Heroes of Might and Magic III "keeps this series running on all cylinders. There is nothing radically different here, but what would you change?

==============================

3DO Brings #1 Strategy Game to Third Platform

REDWOOD CITY, Calif., Dec. 21 PRNewswire The 3DO Company (Nasdaq: THDO) today announced that the Macintosh version of the Heroes of Might and Magic III game, the immensely popular strategy game developed by New World Computing, is now available at retail outlets nationwide and online shopping sites.

The Heroes(TM) III game has earned high praise from leading publications, including perfect score reviews from Computer Games Strategy Plus and CNET Gamecenter, among others. The game has also earned a "Top Pick" selection from Family PC, and an "Editor's Choice" award from Computer Gaming World. The series has sold 1.5 million units worldwide, and spent several months at the top of the Computer Gaming World Readers' Poll. A Heroes of Might and Magic game is also in development for Game Boy(R) Color.

The third chapter in the popular series is its best yet, featuring high resolution artwork, beautiful environments, a bestiary of fantastic foes and powerful allies, adventure filled quests, and a gripping story of treachery and vengeance. Most of all, the Heroes III game emphasizes elements of strategic conquest: the building of mighty armies, territorial expansion, siege warfare, and the clash of battle. The Heroes III game is simple to learn, yet challenging for all levels, making it a highly addictive experience for players of all ages. The turn based play is especially suited for experienced and novice gamers alike.

The Heroes III game contains all the elements of a top notch strategy game: exploration, empire building and combat. As heroes travel across the land with their armies, they can explore territories, seek artifacts, and find treasure, as well as lead their armies into battle. Missions can be self contained single scenarios, linked together into multi scenario campaigns, or played as multi player scenarios against other human players across a network.
=========================
CHAR LIMIT REACHED
"""
