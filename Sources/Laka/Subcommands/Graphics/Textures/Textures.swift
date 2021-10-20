//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import ArgumentParser

import Util
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
        
        /// Requires `Laka lod` to have been run first.
        mutating func run() throws {
            print("👘 Extracting sprites (terrain, monsters, artifacts), run time: ~15s")
            try extractAllTextures()
        }
    }
}

// MARK: Computed props
extension Laka.Textures {
    
    var verbose: Bool { options.printDebugInformation }
    
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


// MARK: Private
private extension Laka.Textures {
    func extractAllTextures() throws {
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
