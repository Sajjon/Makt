//
//  Spell+ID+Level.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-09-07.
//

import Foundation

public extension Spell.ID {
    
    static let level1: [Self] = [
        .bless,
        .bloodlust,
        .cure,
        .curse,
        .dispel,
        .haste,
        .magicArrow,
        .protectionFromWater,
        .protectionFromFire,
        .shield,
        .slow,
        .stoneSkin,
        .summonBoat,
        .viewAir,
        .viewEarth
    ]
    
    static let level2: [Self] = [
        .blind,
        .deathRipple,
        .disguise,
        .fireWall,
        .fortune,
        .iceBolt,
        .lightningBolt,
        .precision,
        .protectionFromAir,
        .quicksand,
        .removeObstacle,
        .scuttleBoat,
        .visions,
        .weakness
    ]
    
    static let level3: [Self] = [
        .airShield,
        .animateDead,
        .antiMagic,
        .destroyUndead,
        .earthquake,
        .fireball,
        .forceField,
        .forgetfulness,
        .frostRing,
        .hypnotize,
        .landMine,
        .mirth,
        .misfortune,
        .protectionFromEarth,
        .teleport
    ]
    
    static let level4: [Self] = [
        .armageddon,
        .berserk,
        .chainLightning,
        .clone,
        .counterstrike,
        .fireShield,
        .frenzy,
        .inferno,
        .meteorShower,
        .prayer,
        .resurrection,
        .slayer,
        .sorrow,
        .townPortal,
        .waterWalk
    ]
    
    static let level5: [Self] = [
        .airElemental,
        .dimensionDoor,
        .earthElemental,
        .fireElemental,
        .fly,
        .implosion,
        .magicMirror,
        .sacrifice,
        .waterElemental
    ]
}
