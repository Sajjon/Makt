//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import ArgumentParser
import Guld
import Malm
import Common
import H3M

extension Laka {
    
    /// A command to convert `.h3m` map files to `.json` format.
    struct ConvertMaps: CMD {
        
        static var configuration = CommandConfiguration(
            abstract: "Convert `.h3m` map files to `.json` format."
        )
        
        @OptionGroup var options: Options
        
        static let executionOneLinerDescription = "🗺  Converting all maps to JSON format"
        static let optimisticEstimatedRunTime: TimeInterval = 250
        
        /// Requires `Laka lod` to have been run first.
        func extract() throws {
            try convertAllMapsToJSON()
        }
        
    }
}


// MARK: Private
private extension Laka.ConvertMaps {
    func convertAllMapsToJSON() throws {
        let mapConverter = MapConverter()
        
        try fileManager.export(
            target: .allFilesMatchingAnyOfExtensions(in: ["h3m", "tut"]),
            at: inDataURL,
            to: outEntryURL,
            nameOfWorkflow: "converting maps to JSON format",
            filesToExportHaveBeenRead: { mapFilesFound in
                // 2x since we export a summary JSON map for each map.
                let numberOfEntriesToExport = mapFilesFound.count * 2
                return numberOfEntriesToExport
            },
            exporter: mapConverter.exporter { [inDataURL] fileExport in
                let absolutePath = inDataURL.appendingPathComponent(fileExport.name)
                return Map.ID.init(absolutePath: absolutePath.path)
            }
        )
    }
}


// MARK: LodParser Exporter
extension MapConverter {
    func exporter(mapIDFromFile: @escaping (File) -> Map.ID) -> SimpleFileExporter {
        .exportingMany { [self] toExport in
            let mapID = mapIDFromFile(toExport)
            return try convert(mapID: mapID)
        }
    }
}

// MARK: Computed props
extension Laka.ConvertMaps {
    
    var fileManager: FileManager { .default }
    
    var inDataURL: URL {
        .init(fileURLWithPath: options.inputPath)
            .appendingPathComponent("Maps")
    }
    
    var outEntryURL: URL {
        .init(fileURLWithPath: options.outputPath)
            .appendingPathComponent("Converted")
            .appendingPathComponent("JSONMaps")
    }
}
