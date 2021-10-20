//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-05.
//

import ArgumentParser
import Foundation

protocol CMD: ParsableCommand {
    init(options: OptionGroup<Options>)
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
