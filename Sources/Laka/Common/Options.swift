//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import ArgumentParser

public enum TritiumAssets {
    public static let path = ("~/Library/Application Support/Tritium" as NSString).expandingTildeInPath.appending("/")
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
        help: "Path to directory for saving extracted resources..")
    var outputPath: String = TritiumAssets.path.appending("Converted/")

}

