//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-05.
//

import Foundation
import ArgumentParser
import Foundation
import Common

protocol CMD: ParsableCommand {
    
    init(options: OptionGroup<Options>)
    
    var options: Options { get }
    
    /// Short description printed once this command starts executing.
    static var executionOneLinerDescription: String { get  }
    
    /// Rought optimistic estimation of rune time in seconds.
    static var optimisticEstimatedRunTime: TimeInterval { get }
    
    /// Entry point for this sub command
    func extract() throws
}

private var progressBar: ProgressBar? = nil

extension CMD {
    
    var terminalWidth: Int { 60 }
    
    var progressMode: ProgressMode {
        options.progressMode
    }
    
    /// Reporting number of entires to extract
    func report(numberOfEntriesToExtract: Int) {
//        switch progressMode {
//        case .aggregated:
//        case .task:
//        }
        progressBar = .init(
            output: FileHandle.standardOutput,
            totalWork: numberOfEntriesToExtract,
            clearOnCompletion: true,
            width: terminalWidth
        )
    }
    
    func finishedExtractingEntry() {
        progressBar?.progress()
    }
    
    func finishedExtractingEntries(count: Int) {
        count.nTimes {
            finishedExtractingEntry()
        }
    }
    
    
    var executionTimeFormatted: String {
        let durationInSeconds = Int(Self.optimisticEstimatedRunTime)
        let (minutes, seconds) = durationInSeconds.quotientAndRemainder(dividingBy: 60)
        guard minutes > 0 else {
            return "\(seconds)s"
        }
        return "\(minutes)min \(seconds)s"
    }

    mutating func run() throws {
        progressBar = nil
        setLogLevel(options.logLevel)

        logger.notice(
            "\(Self.executionOneLinerDescription) ⏳ ~ \(executionTimeFormatted)"
        )
        
        try extract()
    }
}

/// A set of CLI tools for extracting/exporting/converting orignal game resources
/// from Heroes of Might and Magic III Complete - "HoMM3 -  needed to play the
/// Swift rewrite of the game named [Tritium](https://github.com/Sajjon/Tritium)
@main
struct Laka: ParsableCommand {
    
    static var specificCommands: [CMD.Type] = [
        LOD.self,
        Textures.self,
        UI.self,
        Creatures.self,
        Towns.self,
        ConvertMaps.self
    ]
    
    static var configuration = CommandConfiguration(
        abstract: "A toolset for extracting/exporting/converting orignal game resources from Heroes of Might and Magic III.",
        version: "0.0.0",
        subcommands: [All.self] + Self.specificCommands,
        defaultSubcommand: All.self
    )
}
