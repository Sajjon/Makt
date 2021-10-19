//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public extension Map {
    struct DecorativeTown: Model {
        public let faction: Faction
    }
}

public extension Scenario.Map.Object {

    /// Non-interactive object, but potentially effectful, e.g. `magic plains`
    /// or `cursed ground` or entirely effectless and purely ornamental like
    /// a `tree`
    enum NonInteractive: Model {
        
        /// `magic plains` or `cursed ground
        case effectful(Effectful)
        
        /// Effectless, purely ornamental, e.g. trees
        case effectless(Effectless)
    }
}

public extension Scenario.Map.Object.NonInteractive {
    enum Effectful: Model {
        case magicalTerrain(MagicalTerrain)
    }
    
    enum Effectless: Model {
        case decorativeTown(Map.DecorativeTown)
        case hole
        case kelp
        case generic
    }
}

public extension Scenario.Map.Object.NonInteractive.Effectful {
    enum MagicalTerrain: Model {
        
        /// Cause all spells to be cast at expert level, regardless of the heroes' skills. This includes both adventure spells and combat spells as well as spells cast by creatures and some of magic creature abilities.
        case magicPlains
        
        /// Prevents hero or creatures from casting of spells above level 1, includes both adventure and combat spells.
        /// In Restoration of Erathia level 1 spells are banned on Cursed Ground as well. Restoration of Erathia
       ///  Disables all native terrain bonuses, positive or negative morale and luck effects.
        case cursedGround
        
        /// Causes all Earth Magic spells to be cast at expert level, regardless of the heroes' skills. This includes both adventure spells and combat spells, but does not affect spells cast by creatures.
        case rockland
        
        /// Cause all Fire Magic spells to be cast at expert level, regardless of the heroes' skills. This includes both adventure spells and combat spells, but does not affect spells cast by creatures.
        case fieryFields
        
        /// Cause all Water Magic spells to be cast at expert level, regardless of the heroes' skills. This includes both adventure spells and combat spells, but does not affect spells cast by creatures.
        case lucidPools
        
        /// Cause all Air Magic spells to be cast at expert level, regardless of the heroes' skills. This includes both adventure spells and combat spells, but does not affect spells cast by creatures.
        case magicClouds
        
        /// Gives all good-aligned creatures +1 Morale, and all Evil-aligned creatures -1 Morale.
        case holyGround
        
        /// Gives all evil-aligned creatures +1 Morale, and all Good-aligned creatures -1 Morale.
        case evilFog
        
        /// Gives all neutrally aligned creatures +2 Luck. Neutral creatures are not affected.
        case cloverField
        
        /// Favorable Winds (h).gif    Reducing amount of consumed movement points by 1/3 (rounded up) for boats.
        /// Unlike other magical terrains, Favorable Winds do not affect combat in any way.
        /// In Horn of the Abyss Favorable Winds cannot be placed under another magical terrain, so they cancel effect of any magical terrain at the same tile.Horn of the Abyss
        case favourableWinds
        
    }
}
