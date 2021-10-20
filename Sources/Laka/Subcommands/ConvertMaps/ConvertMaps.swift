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
        
        /// Requires `Laka lod` to have been run first.
        mutating func run() throws {
            logger.debug("🗺 Converting all maps to JSON format, run time: ~4 minutes")
            try convertAllMapsToJSON()
        }
    }
}


// MARK: Private
private extension Laka.ConvertMaps {
    func convertAllMapsToJSON() throws {
        let verbose = options.printDebugInformation
        
        let mapConverter = MapConverter()
        
        try fileManager.export(
            target: .allFilesMatchingAnyOfExtensions(in: ["h3m", "tut"]),
            at: inDataURL,
            to: outEntryURL,
            nameOfWorkflow: "converting maps to JSON format",
            verbose: verbose,
            calculateWorkload: { mapFilesFound in mapFilesFound.count * 2 /* 2x since we export a summar JSON map for each map. */ },
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
