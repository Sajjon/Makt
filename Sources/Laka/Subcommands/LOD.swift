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

        let lodParser = LodParser()
        
        let lodExporter: Exporter = .toMany { toExport in
            let lodFile = try lodParser.parse(archiveFileName: toExport.name, archiveFileData: toExport.content)
            return lodFile.entries.map {
                SimpleFile.init(name: $0.fileName, content: $0.rawData)
            }
        }
        
        try fileManager.export(
            target: .anyFileWithExtension("lod"),
            at: inDataURL,
            to: outEntryURL,
            verbose: options.printDebugInformation,
            exporter: lodExporter
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

struct SimpleFile {
    let name: String
    let content: Data
}

enum ExportTarget {
    case anyFileWithExtension(String)
    case specificFileList([String])
}

enum Exporter {
    case toMany((SimpleFile) throws -> [SimpleFile])
    case single((SimpleFile) throws -> SimpleFile)
    
    func export(_ simpleFile: SimpleFile) throws -> [SimpleFile] {
        switch self {
        case .single(let outputtingSingleFile):
            return try [outputtingSingleFile(simpleFile)]
        case .toMany(let outputtingManyFiles):
            return try outputtingManyFiles(simpleFile)
        }
    }
}

extension FileManager {
    
    func export(
        target: ExportTarget,
        at source: URL,
        to destination: URL,
        verbose: Bool = false,
        fileWritingOptions: Data.WritingOptions = .noFileProtection,
        exporter: Exporter
    ) throws {
        
        try createOutputDirectoryIfNeeded(path: destination.path)
        
        let targetFileExtensions: [String] = {
            switch target {
            case .anyFileWithExtension(let targetFileExtension): return [targetFileExtension]
            case .specificFileList(let targetFiles): return targetFiles.compactMap { $0.fileExtension }
            }
        }()
        
        let urlsOfFoundFiles = try findFiles(
            extensions: Set(targetFileExtensions),
            at: source,
            verbose: verbose
        )
        
        let files: [URL] = {
            switch target {
            case .anyFileWithExtension: return urlsOfFoundFiles
            case .specificFileList(let targetFileList):
                let targetFiles = Set(targetFileList)
                return urlsOfFoundFiles.filter { targetFiles.contains($0.lastPathComponent) }
            }
        }()
        
        let filesToExport: [SimpleFile] = try files.map{ file in
            guard let data = contents(atPath: file.path) else {
                throw Fail(description: "failed file at path: \(file.path)")
            }
            return .init(name: file.lastPathComponent, content: data)
        }
        
        let filesToSave: [SimpleFile] = try filesToExport.flatMap { toExport in
//            try (data: exporter(toExport.content), name: toExport.name)
            try exporter.export(toExport)
        }
        
        for fileToSave in filesToSave {
            let fileURL = destination.appendingPathComponent(fileToSave.name)
            if verbose {
                print("Writing file: to '\(fileURL.path)' (#\(fileToSave.content.count) bytes)")
            }
            try fileToSave.content.write(to: fileURL, options: fileWritingOptions)
        }
      
    }
}
        
//// MARK: Methods
//extension Laka.LOD {
//
////    func findLodArchiveURLs() throws -> [URL] {
////        try fileManager.findFiles(
////            extensions: ["lod"],
////            at: inDataURL,
////            verbose: options.printDebugInformation
////        )
////    }
//
//    mutating func extractDefFilesOfArchive(
//        at archivePath: URL
//    ) throws {
//
//        let lodParser = LodParser()
////        let lodFile = try lodParser.parse(
////            archiveFileName: archivePath.lastPathComponent,
////            archiveFileData: data,
////            inspector: .init(onParseFileEntry: { [options] fileEntry in
////                if options.printDebugInformation {
////                    print("Parsed entry: '\(fileEntry.fileName)' (#\(fileEntry.byteCount) bytes)")
////                }
////            })
////        )
////
////        for entry in lodFile.entries {
////            let fileURL = outEntryURL.appendingPathComponent(entry.fileName)
////            if options.printDebugInformation {
////                print("Writing entry: to '\(fileURL.path)' (#\(entry.byteCount) bytes)")
////            }
////            try entry.rawData.write(to: fileURL, options: .noFileProtection)
////        }
//
//
//    }
//}
