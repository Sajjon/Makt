//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-14.
//

import Foundation

// MARK: Factory

public extension CreatureStack {
 
    static func pikeman(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .pikeman), quantity: quantity)
    }

    static func halberdier(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .halberdier), quantity: quantity)
    }

    static func archer(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .archer), quantity: quantity)
    }

    static func marksman(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .marksman), quantity: quantity)
    }

    static func griffin(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .griffin), quantity: quantity)
    }

    static func royalGriffin(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .royalGriffin), quantity: quantity)
    }

    static func swordsman(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .swordsman), quantity: quantity)
    }

    static func crusader(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .crusader), quantity: quantity)
    }

    static func monk(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .monk), quantity: quantity)
    }

    static func zealot(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .zealot), quantity: quantity)
    }

    static func cavalier(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .cavalier), quantity: quantity)
    }

    static func champion(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .champion), quantity: quantity)
    }

    static func angel(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .angel), quantity: quantity)
    }

    static func archangel(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .archangel), quantity: quantity)
    }

    static func centaur(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .centaur), quantity: quantity)
    }

    static func centaurCaptain(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .centaurCaptain), quantity: quantity)
    }

    static func dwarf(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .dwarf), quantity: quantity)
    }

    static func battleDwarf(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .battleDwarf), quantity: quantity)
    }

    static func woodElf(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .woodElf), quantity: quantity)
    }

    static func grandElf(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .grandElf), quantity: quantity)
    }

    static func pegasus(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .pegasus), quantity: quantity)
    }

    static func silverPegasus(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .silverPegasus), quantity: quantity)
    }

    static func dendroidGuard(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .dendroidGuard), quantity: quantity)
    }

    static func dendroidSoldier(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .dendroidSoldier), quantity: quantity)
    }

    static func unicorn(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .unicorn), quantity: quantity)
    }

    static func warUnicorn(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .warUnicorn), quantity: quantity)
    }

    static func greenDragon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .greenDragon), quantity: quantity)
    }

    static func goldDragon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .goldDragon), quantity: quantity)
    }

    static func gremlin(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .gremlin), quantity: quantity)
    }

    static func masterGremlin(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .masterGremlin), quantity: quantity)
    }

    static func stoneGargoyle(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .stoneGargoyle), quantity: quantity)
    }

    static func obsidianGargoyle(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .obsidianGargoyle), quantity: quantity)
    }

    static func stoneGolem(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .stoneGolem), quantity: quantity)
    }

    static func ironGolem(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .ironGolem), quantity: quantity)
    }

    static func mage(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .mage), quantity: quantity)
    }

    static func archMage(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .archMage), quantity: quantity)
    }

    static func genie(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .genie), quantity: quantity)
    }

    static func masterGenie(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .masterGenie), quantity: quantity)
    }

    static func naga(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .naga), quantity: quantity)
    }

    static func nagaQueen(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .nagaQueen), quantity: quantity)
    }

    static func giant(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .giant), quantity: quantity)
    }

    static func titan(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .titan), quantity: quantity)
    }

    static func imp(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .imp), quantity: quantity)
    }

    static func familiar(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .familiar), quantity: quantity)
    }

    static func gog(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .gog), quantity: quantity)
    }

    static func magog(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .magog), quantity: quantity)
    }

    static func hellHound(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .hellHound), quantity: quantity)
    }

    static func cerberus(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .cerberus), quantity: quantity)
    }

    static func demon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .demon), quantity: quantity)
    }

    static func hornedDemon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .hornedDemon), quantity: quantity)
    }

    static func pitFiend(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .pitFiend), quantity: quantity)
    }

    static func pitLord(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .pitLord), quantity: quantity)
    }

    static func efreeti(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .efreeti), quantity: quantity)
    }

    static func efreetSultan(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .efreetSultan), quantity: quantity)
    }

    static func devil(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .devil), quantity: quantity)
    }

    static func archDevil(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .archDevil), quantity: quantity)
    }

    static func skeleton(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .skeleton), quantity: quantity)
    }

    static func skeletonWarrior(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .skeletonWarrior), quantity: quantity)
    }

    static func walkingDead(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .walkingDead), quantity: quantity)
    }

    static func zombie(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .zombie), quantity: quantity)
    }

    static func wight(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .wight), quantity: quantity)
    }

    static func wraith(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .wraith), quantity: quantity)
    }

    static func vampire(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .vampire), quantity: quantity)
    }

    static func vampireLord(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .vampireLord), quantity: quantity)
    }

    static func lich(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .lich), quantity: quantity)
    }

    static func powerLich(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .powerLich), quantity: quantity)
    }

    static func blackKnight(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .blackKnight), quantity: quantity)
    }

    static func dreadKnight(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .dreadKnight), quantity: quantity)
    }

    static func boneDragon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .boneDragon), quantity: quantity)
    }

    static func ghostDragon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .ghostDragon), quantity: quantity)
    }

    static func troglodyte(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .troglodyte), quantity: quantity)
    }

    static func infernalTroglodyte(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .infernalTroglodyte), quantity: quantity)
    }

    static func harpy(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .harpy), quantity: quantity)
    }

    static func harpyHag(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .harpyHag), quantity: quantity)
    }

    static func beholder(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .beholder), quantity: quantity)
    }

    static func evilEye(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .evilEye), quantity: quantity)
    }

    static func medusa(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .medusa), quantity: quantity)
    }

    static func medusaQueen(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .medusaQueen), quantity: quantity)
    }

    static func minotaur(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .minotaur), quantity: quantity)
    }

    static func minotaurKing(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .minotaurKing), quantity: quantity)
    }

    static func manticore(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .manticore), quantity: quantity)
    }

    static func scorpicore(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .scorpicore), quantity: quantity)
    }

    static func redDragon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .redDragon), quantity: quantity)
    }

    static func blackDragon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .blackDragon), quantity: quantity)
    }

    static func goblin(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .goblin), quantity: quantity)
    }

    static func hobgoblin(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .hobgoblin), quantity: quantity)
    }

    static func wolfRider(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .wolfRider), quantity: quantity)
    }

    static func wolfRaider(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .wolfRaider), quantity: quantity)
    }

    static func orc(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .orc), quantity: quantity)
    }

    static func orcChieftain(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .orcChieftain), quantity: quantity)
    }

    static func ogre(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .ogre), quantity: quantity)
    }

    static func ogreMage(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .ogreMage), quantity: quantity)
    }

    static func roc(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .roc), quantity: quantity)
    }

    static func thunderbird(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .thunderbird), quantity: quantity)
    }

    static func cyclops(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .cyclops), quantity: quantity)
    }

    static func cyclopsKing(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .cyclopsKing), quantity: quantity)
    }

    static func behemoth(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .behemoth), quantity: quantity)
    }

    static func ancientBehemoth(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .ancientBehemoth), quantity: quantity)
    }

    static func gnoll(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .gnoll), quantity: quantity)
    }

    static func gnollMarauder(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .gnollMarauder), quantity: quantity)
    }

    static func lizardman(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .lizardman), quantity: quantity)
    }

    static func lizardWarrior(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .lizardWarrior), quantity: quantity)
    }

    static func gorgon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .gorgon), quantity: quantity)
    }

    static func mightyGorgon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .mightyGorgon), quantity: quantity)
    }

    static func serpentFly(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .serpentFly), quantity: quantity)
    }

    static func dragonFly(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .dragonFly), quantity: quantity)
    }

    static func basilisk(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .basilisk), quantity: quantity)
    }

    static func greaterBasilisk(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .greaterBasilisk), quantity: quantity)
    }

    static func wyvern(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .wyvern), quantity: quantity)
    }

    static func wyvernMonarch(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .wyvernMonarch), quantity: quantity)
    }

    static func hydra(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .hydra), quantity: quantity)
    }

    static func chaosHydra(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .chaosHydra), quantity: quantity)
    }

    static func airElemental(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .airElemental), quantity: quantity)
    }

    static func earthElemental(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .earthElemental), quantity: quantity)
    }

    static func fireElemental(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .fireElemental), quantity: quantity)
    }

    static func waterElemental(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .waterElemental), quantity: quantity)
    }

    static func goldGolem(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .goldGolem), quantity: quantity)
    }

    static func diamondGolem(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .diamondGolem), quantity: quantity)
    }

    static func pixie(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .pixie), quantity: quantity)
    }

    static func sprite(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .sprite), quantity: quantity)
    }

    static func psychicElemental(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .psychicElemental), quantity: quantity)
    }

    static func magicElemental(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .magicElemental), quantity: quantity)
    }

    static func iceElemental(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .iceElemental), quantity: quantity)
    }

    static func magmaElemental(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .magmaElemental), quantity: quantity)
    }

    static func stormElemental(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .stormElemental), quantity: quantity)
    }

    static func energyElemental(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .energyElemental), quantity: quantity)
    }

    static func firebird(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .firebird), quantity: quantity)
    }

    static func phoenix(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .phoenix), quantity: quantity)
    }

    static func azureDragon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .azureDragon), quantity: quantity)
    }

    static func crystalDragon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .crystalDragon), quantity: quantity)
    }

    static func faerieDragon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .faerieDragon), quantity: quantity)
    }

    static func rustDragon(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .rustDragon), quantity: quantity)
    }

    static func enchanter(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .enchanter), quantity: quantity)
    }

    static func sharpshooter(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .sharpshooter), quantity: quantity)
    }

    static func halfling(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .halfling), quantity: quantity)
    }

    static func peasant(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .peasant), quantity: quantity)
    }

    static func boar(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .boar), quantity: quantity)
    }

    static func mummy(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .mummy), quantity: quantity)
    }

    static func nomad(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .nomad), quantity: quantity)
    }

    static func rogue(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .rogue), quantity: quantity)
    }

    static func troll(_ quantity: CreatureStack.Quantity) -> Self {
        .init(kind: .specific(creatureID: .troll), quantity: quantity)
    }
}
