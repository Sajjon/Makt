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
    struct Textures: CMD, TextureGenerating, TaskExecuting {
        @OptionGroup var options: Options
    }
}


extension Laka.Textures {
    
    static var configuration = CommandConfiguration(
        abstract: "Extract texture images such as terrain, artifacts, monsters etc. But not game menu UI."
    )
    
    static let executionOneLinerDescription = "👘 Extracting textures (sprites)"
    static let optimisticEstimatedRunTime: TimeInterval = 15
    
    static let tasks: [GenerateAtlasTask] = [
        terrainTask,
        townsTask,
        monstersTask,
        impassableTerrainTask,
        passableTerrainTask,
        visitableTask,
        dwellingsTask,
        artifactsTask,
        heroesTask,
        resourcesTask,
        edgesTask
    ]

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

