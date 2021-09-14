//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-14.
//

import Foundation

// MARK: Class
public extension Map.Object {
    enum Class: Hashable, CaseIterable {
        
        case abandonedMine,

        // Armageddon's Blade and Shadow of Death variants.
        artifact,

        // Armageddon's Blade and Shadow of Death variants.
        dwelling,
        
        event,
        
        // Armageddon's Blade and Shadow of Death variants.
        garrison,
        
        genericBoat,
        
        // Armageddon's Blade and Shadow of Death variants.
        genericImpassableTerrain,
        
        genericPassableTerrain,
        
        // Armageddon's Blade and Shadow of Death variants.
        genericTreasure,
        
        // Armageddon's Blade and Shadow of Death variants.
        genericVisitable,
        
        grail,
       
        // Armageddon's Blade and Shadow of Death variants.
        hero,
        
        lighthouse,
        monolithTwoWay,
        
        // Armageddon's Blade and Shadow of Death variants.
        monster,
       
        oceanBottle,
        pandorasBox,
        placeholderHero,
        prison,
        questGuard,
        randomDwelling,
        randomDwellingOfFaction,
        randomDwellingAtLevel,
        randomHero,
        resource,
        resourceGenerator,
        scholar,
        seersHut,
        shipyard,
        shrine,
        sign,
        spellScroll,
        subterraneanGate,

        // Armageddon's Blade and Shadow of Death variants.
        town,
        
        witchHut

    }
}
