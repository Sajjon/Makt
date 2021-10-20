//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import ArgumentParser
import Guld
import Malm
import Util
import Foundation

extension Laka {
    
    /// A command to extract all `*.def`, `*.pcx`, `*.msk`, `*.txt` etc files from all `*.lod` archive files.
    /// Note that these extract files are saved as raw data, they are not yet parsed, only extracted from
    /// their source archive.
    struct LOD: CMD {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract all '*.def' files from all '*.lod' archive files."
        )
        
        @OptionGroup var options: Options
        
        mutating func run() throws {
            print("📦 Unarchiving assets from LOD archives, run time: ~10s")
            try unarchiveLODArchives()
        }
    }
}

private extension Laka.LOD {
    func unarchiveLODArchives() throws {
        let verbose = options.printDebugInformation
        let lodParser = LodParser()
        
        try fileManager.export(
            target: .allFilesMatching(extension: "lod"),
            at: inDataURL,
            to: outEntryURL,
            nameOfWorkflow: "exporting LOD archives",
            verbose: verbose,
            calculateWorkload: { lodArchives in
                try lodArchives.map { try lodParser.peekFileEntryCount(of: $0) }.reduce(0, +)
            },
            exporter: lodParser.exporter
        )
    }
}

// MARK: Computed props
extension Laka.LOD {
    
    var fileManager: FileManager { .default }
    
    var inDataURL: URL {
        .init(fileURLWithPath: options.inputPath).appendingPathComponent("Data")
    }
    
    var outEntryURL: URL {
        .init(fileURLWithPath: options.outputPath).appendingPathComponent("Raw")
    }
}

// MARK: LodParser Exporter
extension LodParser {
    var exporter: SimpleFileExporter {
        .exportingMany { [self] toExport in
            let lodFile = try parse(
                archiveFileName: toExport.name,
                archiveFileData: toExport.data
            )
            
            return lodFile.entries.map {
                SimpleFile(
                    name: $0.fileName.lowercased(),
                    data: $0.data
                )
            }
        }
    }
}
