//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import ArgumentParser
import Logging
import Common

public enum TritiumAssets {
    public static let path = ("~/Library/Application Support/Tritium" as NSString).expandingTildeInPath.appending("/")
}

extension Logger.Level: ExpressibleByArgument {
    /// Creates a new instance of this type from a command-line-specified
    /// argument.
    public init?(argument rawValue: String) {
        self.init(rawValue: rawValue)
    }

    /// An array of all possible strings to that can convert to value of this
    /// type.
    ///
    /// The default implementation of this property returns an empty array.
    public static var allValueStrings: [String] {
        allCases.map { $0.rawValue }
    }

}

enum ProgressMode: String, Decodable, Hashable, ExpressibleByArgument {
    
    /// Only display progress bar of all the aggregated work per subcommand. So
    /// when a command consists of muliple subtasks we do not show an individual
    /// progress bar for each subtask, but rather count the number of completed
    /// subtasks and update the progress bar for that.
    ///
    /// This is the least verbose and default mode.
    case aggregated
    
    /// Output name of each subtask and display a progress bar for this individual
    /// subtask.
    ///
    /// This is the most verbose mode.
    case task
    
}

struct Options: ParsableArguments {
    

    @Option(
        name: [.customShort("p"), .long],
        help: "Progress mode of commmands.")
    var progressMode: ProgressMode = .aggregated
    
    @Option(
        name: [.customShort("l"), .long],
        help: "Log level")
    var logLevel: Logger.Level = .notice
    
    @Option(
        name: [.customShort("i"), .long],
        help: "Path to original game resources to extract from.")
    var inputPath: String = TritiumAssets.path.appending("Original/")

    @Option(
        name: [.customShort("o"), .long],
        help: "Path to directory for saving extracted resources..")
    var outputPath: String = TritiumAssets.path.appending("Extracted/")

}

