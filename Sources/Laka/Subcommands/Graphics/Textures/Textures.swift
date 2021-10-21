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
        
        static let executionOneLinerDescription = "👘 Extracting textues (sprites)"
        static let optimisticEstimatedRunTime: TimeInterval = 15
        
        /// Requires `Laka lod` to have been run first.
        func extract() throws {
            try extractAllTextures()
        }
    }
}

extension Laka.Textures {
    
    static let tasks: [Task] = [
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
    
    var numberOfEntriesToExtract: Int {
        Self.tasks.map { $0.entryCount }.reduce(0, +)
    }
    
    func extractAllTextures() throws {
        
        report(numberOfEntriesToExtract: numberOfEntriesToExtract)
        try Self.tasks.forEach {
            try run(task: $0)
        }
    }
    
    private func run(task: Task) throws {
        log(level: .info, "Task: export '\(task.taskName)'")
        try generateTexture(
            name: task.atlasName,
            list: task.filelist,
            maxImageCountPerDefFile: task.maxImageCountPerDefFile,
            finishedExportingOneEntry: finishedExtractingEntry
        )
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

// MARK: Task
extension Laka.Textures {
    struct Task {
       
        let taskName: String
        let filelist: [ImageExport]
        let atlasName: String
        let maxImageCountPerDefFile: Int?
        
        init(
            name: String? = nil,
            atlasName: String,
            filelist: [ImageExport],
            maxImageCountPerDefFile: Int? = nil
        ) {
            self.taskName = name ?? atlasName
            self.atlasName = atlasName
            self.filelist = filelist
            self.maxImageCountPerDefFile = maxImageCountPerDefFile
        }
    }
    
}

extension Laka.Textures.Task {
    
    var entryCount: Int { filelist.count }
    
    init(
        name: String? = nil,
        atlasName: String,
        defFileList: [DefImageExport],
        maxImageCountPerDefFile: Int? = nil
    ) {
        self.init(
            name: name,
            atlasName: atlasName,
            filelist: defFileList.map { .def($0) },
            maxImageCountPerDefFile: maxImageCountPerDefFile
        )
    }
    
    init(
        name: String? = nil,
        atlasName: String,
        defList: [String],
        maxImageCountPerDefFile: Int? = nil
    ) {
        self.init(
            name: name,
            atlasName: atlasName,
            defFileList: defList.map { defFileName in .init(defFileName: defFileName, nameFromFrameAtIndexIndex: { _, _ in defFileName }) },
            maxImageCountPerDefFile: maxImageCountPerDefFile
        )
    }
}
