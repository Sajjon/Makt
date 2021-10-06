//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-05.
//

import ArgumentParser
import Foundation

public enum TritiumAssets {}
public extension TritiumAssets {
    
    static let path = ("~/Library/Application Support/Tritium" as NSString).expandingTildeInPath.appending("/")
}

@main
struct Laka: ParsableCommand {
    // Customize your command's help and subcommands by implementing the
    // `configuration` property.
    static var configuration = CommandConfiguration(
        // Optional abstracts and discussions are used for help output.
        abstract: "A utility for extracting the orignal game resources from Heroes of Might and Magic III which is needed to play Tritium.",

        // Commands can define a version for automatic '--version' support.
        version: "0.0.0",

        // Pass an array to `subcommands` to set up a nested tree of subcommands.
        // With language support for type-level introspection, this could be
        // provided by automatically finding nested `ParsableCommand` types.
        subcommands: [All.self, LOD.self],

        // A default subcommand, when provided, is automatically selected if a
        // subcommand is not given on the command line.
        defaultSubcommand: LOD.self)

}

struct Options: ParsableArguments {
    @Flag(name: [.customLong("progress"), .customShort("p")],
          help: "Print debug information about the extraction process progress.")
    var printDebugInformation = false

    @Option(
        name: [.customShort("i"), .long],
        help: "Path to orignal game resources to extract from.")
    var inputPath: String = TritiumAssets.path.appending("Original/")

    @Option(
        name: [.customShort("o"), .long],
        help: "Path to orignal game resources to extract from.")
    var outputPath: String = TritiumAssets.path.appending("Converted/")

}

struct Fail: Swift.Error, CustomStringConvertible, Equatable {
    let description: String
}


import Guld
import Malm
import Util
extension Laka {
    
    /// A command to extract all `*.def`, `*.pcx`, `*.msk`, `*.txt` etc files from all `*.lod` archive files.
    /// Note that these extract files are saved as raw data, they are not yet parsed, only extracted from
    /// their source archive.
    struct LOD: ParsableCommand {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract all '*.def' files from all '*.lod' archive files."
        )
        
        // The `@OptionGroup` attribute includes the flags, options, and
        // arguments defined by another `ParsableArguments` type.
        @OptionGroup var options: Options
        
        lazy var inDataURL: URL = {
            URL(fileURLWithPath: options.inputPath).appendingPathComponent("Data")
        }()
        
        lazy var outEntryURL: URL = {
            URL(fileURLWithPath: options.outputPath).appendingPathComponent("entries")
        }()
        
        mutating func run() throws {
            print("About to extract '*.def' files from '*.lod' archives located at: \(options.inputPath) to folder: \(inDataURL), verbose? \(options.printDebugInformation)")
            try createOutputDirectoryIfNeeded()
            let lodArchiveURLs = try findLodArchiveURLs()
            try lodArchiveURLs.forEach {
                try extractDefFilesOfArchive(at: $0)
            }
        }
        
        mutating func createOutputDirectoryIfNeeded() throws {
            let outputPath = outEntryURL.path
            do {
                try FileManager.default.createDirectory(atPath: outputPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                let createOutputPathError = Fail(description: "Failed to create output directory at: '\(outputPath)'")
                print("❌ Error: \(String(describing: createOutputPathError))")
                throw createOutputPathError
            }
        }
        
        mutating func findLodArchiveURLs() throws -> [URL] {
            let fileManager: FileManager = .default
            let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
            guard let enumerator = fileManager.enumerator(at: inDataURL, includingPropertiesForKeys: Array(resourceKeys), options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles], errorHandler: { url, error in
                print("❌ Error: \(String(describing: error)) while reading file at path: \(url.path)")
                return false // do NOT continue with next file if we had an error
            }) else {
                throw Fail(description: "Failed to read contents of directory: '\(options.inputPath))'")
            }
            
            var fileURLs: [URL] = []
            for case let fileURL as URL in enumerator {
                
                guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                    let isDirectory = resourceValues.isDirectory,
                    let name = resourceValues.name
                    else {
                        print("⚠️ Skipped: '\(fileURL.path)' since failed to retrieve info about it.")
                        continue
                }
                
                guard !isDirectory else {
                    print("💡 Skipped: '\(fileURL.path)' since it is a directory.")
                    continue
                }
                guard name.hasSuffix(".lod") else {
                    print("💡 Skipped: '\(fileURL.path)' since it is not a `.lod` archive.")
                    continue
                }
                
                if options.printDebugInformation {
                    print("Found LOD archive at: \(fileURL.path)")
                }
                fileURLs.append(fileURL)
             
            }
            
            guard !fileURLs.isEmpty else {
                throw Fail(description: "Failed to find any lod archives at: '\(options.inputPath))'")
            }
            
            return fileURLs
        }
        
        mutating func extractDefFilesOfArchive(
            at archivePath: URL,
            fileManager: FileManager = .default
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
    
    struct All: ParsableCommand {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract all original resources from HoMM3 needed to play the rewrite of the game named 'Tritium'."
        )
        
        // The `@OptionGroup` attribute includes the flags, options, and
        // arguments defined by another `ParsableArguments` type.
        @OptionGroup var options: Options
        
        mutating func run() {
            print("About to extract ALL game resources. This will take a couple of minutes. ☕️")
        }
    }
}
