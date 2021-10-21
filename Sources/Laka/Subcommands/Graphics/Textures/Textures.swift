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
        
        static var configuration = CommandConfiguration(
            abstract: "Extract texture images such as terrain, artifacts, monsters etc. But not game menu UI."
        )
        
        @OptionGroup var options: Options
        
        static let executionOneLinerDescription = "👘 Extracting textues (sprites)"
        static let optimisticEstimatedRunTime: TimeInterval = 15
        
     
    }
}

extension TaskExecuting where Self: CMD {
    
    func runAllTasks() throws {
        switch progressMode {
        case .aggregated:
            report(numberOfEntriesToExtract:  Self.tasks.map { $0.entryCount }.reduce(0, +))
        case .task: break
        }
        try Self.tasks.forEach { task in
            
            switch progressMode {
            case .task:
                report(numberOfEntriesToExtract: task.entryCount)
                let subtaskLogLevel: Logger.Level = .info
                assert(self.options.logLevel >= subtaskLogLevel)
                log(level: subtaskLogLevel, "Task: export '\(task.taskName)'")
            case .aggregated: break
            }
            
            try run(task: task)
        }
    }
}

extension CMD where Self: TaskExecuting {
    func extract() throws {
        try runAllTasks()
    }
}

extension TaskExecuting where Self: CMD, Self: TextureGenerating, Task == GenerateAtlasTask {
    
    func run(task: Task) throws {
        try generateTexture(
            name: task.atlasName,
            list: task.filelist,
            maxImageCountPerDefFile: task.maxImageCountPerDefFile,
            finishedExportingOneEntry: finishedExtractingEntry
        )
    }
}

extension Laka.Textures {
    
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
}

public protocol TaskExecuting {
    associatedtype Task: SubTask
    static var tasks: [Task] { get }
    func run(task: Task) throws
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

public protocol SubTask {
    var taskName: String { get }
    var entryCount: Int { get }
}


// MARK: Task
struct GenerateAtlasTask: SubTask {
   
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

extension GenerateAtlasTask {
    
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
