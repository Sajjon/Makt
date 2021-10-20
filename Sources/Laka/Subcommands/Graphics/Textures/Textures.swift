//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import ArgumentParser

import Common
import Malm
import Guld

// MARK: Textures
extension Laka {
    
    /// A command to extract all textures, such as terrain, monsters, artifacts,
    /// heroes and towns on the map etc. But not game menu UI, neither
    /// in combat/battle creature sprites nor in town UI.
    struct Textures: CMD, TextureGenerating {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract texture images such as terrain, artifacts, monsters etc. But not game menu UI."
        )
        
        @OptionGroup var options: Options
        
        static let executionOneLinerDescription = "👘 Extracting sprites (terrain, monsters, artifacts)"
        static let optimisticEstimatedRunTime: TimeInterval = 15
        
        /// Requires `Laka lod` to have been run first.
        func extract() throws {
            try extractAllTextures()
        }
    }
}

extension Laka.Textures {
    
    var numberOfEntriesToExtract: Int {
        [
            townsDefsCount,
            terrainDefsCount,
            monstersDefsCount,
            impassableTerrainDefsCount,
            passableTerrainDefsCount,
            visitableDefsCount,
            dwellingDefsCount,
            artifactsDefsCount,
            heroesDefsCount,
            resourcesDefsCount,
            edgesDefsCount
        ].reduce(0, +)
    }
    
    func extractAllTextures() throws {
        report(numberOfEntriesToExtract: numberOfEntriesToExtract)
        
        try exportTerrain()
        try exportTowns()
        try exportMonsters()
        try exportImpassableTerrain()
        try exportPassableTerrain()
        try exportVisitable()
        try exportDwelling()
        try exportArtifact()
        try exportHero()
        try exportResource()
        try exportEdges()
    }
}

// MARK: Computed props
extension Laka.Textures {
    
    var inDataURL: URL {
        .init(fileURLWithPath: options.outputPath).appendingPathComponent("Raw")
    }
    
    var outImagesURL: URL {
        .init(fileURLWithPath: options.outputPath)
            .appendingPathComponent("Converted")
            .appendingPathComponent("Graphics")
            .appendingPathComponent("Texture")
    }
}
