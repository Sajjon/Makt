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
    struct LOD: ParsableCommand {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract all '*.def' files from all '*.lod' archive files."
        )
        
        @OptionGroup var options: Options
    }
}

// MARK: Run
extension Laka.LOD {
    mutating func run() throws {
        print(
            """
            
            🔮
            About to files from all '*.lod' archives
            Located at: \(options.inputPath)
            To folder:\(inDataURL)
            This will take about 5 seconds on a fast machine (Macbook Pro 2019).
            ☕️
            
            """
        )

        let lodParser = LodParser()
        
        try fileManager.export(
            target: .anyFileWithExtension("lod"),
            at: inDataURL,
            to: outEntryURL,
            verbose: options.printDebugInformation,
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
        .init(fileURLWithPath: options.outputPath).appendingPathComponent("entries")
    }
}

// MARK: LodParser Exporter
extension LodParser {
    var exporter: Exporter {
        .toMany { [self] toExport in
            
            let lodFile = try parse(
                archiveFileName: toExport.name,
                archiveFileData: toExport.data
            )
            
            return lodFile.entries.map {
                SimpleFile(
                    name: $0.fileName,
                    data: $0.data
                )
            }
        }
    }
}
