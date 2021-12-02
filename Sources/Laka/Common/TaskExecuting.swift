//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-21.
//

import Foundation
import Common

public protocol TaskExecuting {
    associatedtype Task: SubTask
    static var tasks: [Task] { get }
    func run(task: Task) throws
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
            usePaletteReplacementMap: task.usePaletteReplacementMap,
            skipImagesWithSameNameAndData: task.skipImagesWithSameNameAndData,
            maxImageCountPerDefFile: task.maxImageCountPerDefFile,
            finishedExportingOneEntry: finishedExtractingEntry
        )
    }
}
