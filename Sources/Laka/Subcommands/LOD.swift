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
        print("About to extract '*.def' files from '*.lod' archives located at: \(options.inputPath) to folder: \(inDataURL), verbose? \(options.printDebugInformation)")
        try fileManager.createOutputDirectoryIfNeeded(path: outEntryURL.path)
        let lodArchiveURLs = try findLodArchiveURLs()
        try lodArchiveURLs.forEach {
            try extractDefFilesOfArchive(at: $0)
        }
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
        
// MARK: Methods
extension Laka.LOD {
 
    func findLodArchiveURLs() throws -> [URL] {
        try fileManager.findFiles(
            extensions: ["lod"],
            at: inDataURL,
            verbose: options.printDebugInformation
        )
    }

    mutating func extractDefFilesOfArchive(
        at archivePath: URL
    ) throws {
        guard let data = fileManager.contents(atPath: archivePath.path) else {
            throw Fail(description: "failed open archive at path: \(archivePath.path)")
        }
        let lodParser = LodParser()
        let lodFile = try lodParser.parse(
            archiveFileName: archivePath.lastPathComponent,
            archiveFileData: data,
            inspector: .init(onParseFileEntry: { [options] fileEntry in
                if options.printDebugInformation {
                    print("Parsed entry: '\(fileEntry.fileName)' (#\(fileEntry.byteCount) bytes)")
                }
            })
        )
        
        for entry in lodFile.entries {
            let fileURL = outEntryURL.appendingPathComponent(entry.fileName)
            if options.printDebugInformation {
                print("Writing entry: to '\(fileURL.path)' (#\(entry.byteCount) bytes)")
            }
            try entry.rawData.write(to: fileURL, options: .noFileProtection)
        }
        
    }
}
