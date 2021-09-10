//
//  Spell+ID.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Spell {
    
    /// Source: http://heroescommunity.com/viewthread.php3?TID=46589&PID=1529922#focus
    enum ID: UInt8, Hashable, Comparable, CaseIterable, CustomDebugStringConvertible {
        
        public static let noneRawValue: RawValue = 0xff
        
        // MARK: Adventure Spells
        case summonBoat,
             scuttleBoat,
             visions,
             viewEarth,
             disguise,
             viewAir,
             fly,
             waterWalk,
             dimensionDoor,
             townPortal,
             
             // MARK: Combat Spells
             quicksand,
             landMine,
             forceField,
             fireWall,
             earthquake,
             magicArrow,
             iceBolt,
             lightningBolt,
             implosion,
             chainLightning,
             frostRing,
             fireball,
             inferno,
             meteorShower,
             deathRipple,
             destroyUndead,
             armageddon,
             shield,
             airShield,
             fireShield,
             protectionFromAir,
             protectionFromFire,
             protectionFromWater,
             protectionFromEarth,
             antiMagic,
             dispel,
             magicMirror,
             cure,
             resurrection,
             animateDead,
             sacrifice,
             bless,
             curse,
             bloodlust,
             precision,
             weakness,
             stoneSkin,
             disruptingRay,
             prayer,
             mirth,
             sorrow,
             fortune,
             misfortune,
             haste,
             slow,
             slayer,
             frenzy,
             titansLightningBolt,
             counterstrike,
             berserk,
             hypnotize,
             forgetfulness,
             blind,
             teleport,
             removeObstacle,
             clone,
             fireElemental,
             earthElemental,
             waterElemental,
             airElemental
    }
}

public extension Spell.ID {
    var debugDescription: String {
        switch self {
        case .summonBoat: return "summonBoat"
        case .scuttleBoat: return "scuttleBoat"
        case .visions: return "visions"
        case .viewEarth: return "viewEarth"
        case .disguise: return "disguise"
        case .viewAir: return "viewAir"
        case .fly: return "fly"
        case .waterWalk: return "waterWalk"
        case .dimensionDoor: return "dimensionDoor"
        case .townPortal: return "townPortal"
        case .quicksand: return "quicksand"
        case .landMine: return "landMine"
        case .forceField: return "forceField"
        case .fireWall: return "fireWall"
        case .earthquake: return "earthquake"
        case .magicArrow: return "magicArrow"
        case .iceBolt: return "iceBolt"
        case .lightningBolt: return "lightningBolt"
        case .implosion: return "implosion"
        case .chainLightning: return "chainLightning"
        case .frostRing: return "frostRing"
        case .fireball: return "fireball"
        case .inferno: return "inferno"
        case .meteorShower: return "meteorShower"
        case .deathRipple: return "deathRipple"
        case .destroyUndead: return "destroyUndead"
        case .armageddon: return "armageddon"
        case .shield: return "shield"
        case .airShield: return "airShield"
        case .fireShield: return "fireShield"
        case .protectionFromAir: return "protectionFromAir"
        case .protectionFromFire: return "protectionFromFire"
        case .protectionFromWater: return "protectionFromWater"
        case .protectionFromEarth: return "protectionFromEarth"
        case .antiMagic: return "antiMagic"
        case .dispel: return "dispel"
        case .magicMirror: return "magicMirror"
        case .cure: return "cure"
        case .resurrection: return "resurrection"
        case .animateDead: return "animateDead"
        case .sacrifice: return "sacrifice"
        case .bless: return "bless"
        case .curse: return "curse"
        case .bloodlust: return "bloodlust"
        case .precision: return "precision"
        case .weakness: return "weakness"
        case .stoneSkin: return "stoneSkin"
        case .disruptingRay: return "disruptingRay"
        case .prayer: return "prayer"
        case .mirth: return "mirth"
        case .sorrow: return "sorrow"
        case .fortune: return "fortune"
        case .misfortune: return "misfortune"
        case .haste: return "haste"
        case .slow: return "slow"
        case .slayer: return "slayer"
        case .frenzy: return "frenzy"
        case .titansLightningBolt: return "titansLightningBolt"
        case .counterstrike: return "counterstrike"
        case .berserk: return "berserk"
        case .hypnotize: return "hypnotize"
        case .forgetfulness: return "forgetfulness"
        case .blind: return "blind"
        case .teleport: return "teleport"
        case .removeObstacle: return "removeObstacle"
        case .clone: return "clone"
        case .fireElemental: return "fireElemental"
        case .earthElemental: return "earthElemental"
        case .waterElemental: return "waterElemental"
        case .airElemental: return "airElemental"
        }
    }
}
