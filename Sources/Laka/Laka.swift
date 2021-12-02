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
    
    /// Rough optimistic estimation of run time in seconds.
    static var optimisticEstimatedRunTime: TimeInterval { get }
    
    /// Entry point for this sub command
    func extract() throws
}

private var progressBar: ProgressBar? = nil

extension CMD {
    
    var terminalWidth: Int { 80 }
    
    var progressMode: ProgressMode {
        options.progressMode
    }
    
    /// Reporting number of entires to extract
    func report(numberOfEntriesToExtract: Int) {
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
    
    
    /// Log a message passing the log level as a parameter.
    ///
    /// - parameters:
    ///    - message: The message to be logged. `message` can be used with any string interpolation literal.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - source: The source this log messages originates to. Currently, it defaults to the folder containing the
    ///              file that is emitting the log message, which usually is the module.
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    func log(
        level: Logger.Level = .notice,
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        source: @autoclosure () -> String? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        progressBar?.clear()
        logger.log(
            level: level,
            message(),
            metadata: metadata(),
            source: source(),
            file: file,
            function: function,
            line: line
        )
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

/// A set of CLI tools for extracting/exporting/converting original game resources
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
        abstract: "A toolset for extracting/exporting/converting original game resources from Heroes of Might and Magic III.",
        version: "0.0.0",
        subcommands: [All.self] + Self.specificCommands,
        defaultSubcommand: All.self
    )
}
