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

struct Options: ParsableArguments {
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

