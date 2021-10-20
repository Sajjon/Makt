//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-20.
//

import Foundation
import Malm

struct TownTemplate<BuildingKind: BuildingIDForFaction>: Codable {
    
    struct Location: Codable {
        let x: Int
        let y: Int
        let z: Int
        
        init(x: Int, y: Int, z: Int = 1) {
            self.x = x
            self.y = y
            self.z = z
        }
    }
    
    struct Graphics: Codable {
        let animation: String
        let border: String
        let area: String
        let animated: Bool
        
        init(
            animation: String,
            border: String,
            area: String,
            animated: Bool = true
        ) {
            self.animation = animation
            self.border = border
            self.area = area
            self.animated = animated
        }
    }
    
    
    struct BuildingDetails: Codable {
        
        typealias Production = Dictionary<Resource.Kind, Int>
        let location: Location
        let gfx: Graphics
        let upgrades: BuildingKind?
        let requires: [BuildingKind]?
        let produce: Production? // Resources?
        
        init(
            location: Location,
            gfx: Graphics,
            upgrades: BuildingKind? = nil,
            requires: [BuildingKind]? = nil,
            produce: Production? = nil
        ) {
            self.location = location
            self.gfx = gfx
            self.produce = produce
            self.upgrades = upgrades
            
            if var requires = requires, let upgrades = upgrades, !requires.contains(upgrades) {
                requires.append(upgrades) // kind of self explainatory that BuildingB upgrading BuildingA requires BuildingA.
                self.requires = requires
            } else {
                self.requires = requires
            }
        }
    }
    
    struct Animation: Codable {
        let location: Location
        let gfx: String
    }
    
    let buildings: [BuildingKind: BuildingDetails]
    let animations: [Animation]
    
    struct Extra: Codable {
        let location: Location
        let gfx: String
    }
    
    struct Upgrade: Codable {
        let location: Location
        let graphics: Graphics
        let requires: [BuildingKind]?
    }
    
    let extras: [BuildingKind: Extra]
    //    let upgrades: [BuildingKind: Upgrade]
    
    let musicTheme: String
    let townBackground: String
    let guildBackground: String
    let guildWindow: String
    let buildingsIcons: String
    let hallBackground: String
    let hallSlots: Array<Array<Array<BuildingKind>>>
    
    struct CreatureUpgradePair: Codable {
        let nonUpgraded: Creature.ID
        let upgraded: Creature.ID
    }
    
    let creatures: [CreatureUpgradePair]
    let warMachine: Artifact.ID
    let primaryResource: Resource.Kind?
    let creatureBackground: String
}


extension TownTemplate {
    var faction: Faction {
        BuildingKind.faction
    }
}
