//
//  Spell+ID.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Spell {
    
    /// Source: http://heroescommunity.com/viewthread.php3?TID=46589&PID=1529922#focus
    enum ID: UInt8, Hashable, Comparable, CaseIterable {
        
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
             titanSLightningBolt,
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
