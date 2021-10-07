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

extension Laka {
    
    /// A command to extract in combat sprites of creatures, but not on map monster icons.
    struct Creatures: ParsableCommand {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract in combat sprites of creatures, but not on map monster icons."
        )
        
        @OptionGroup var options: Options
    }
}

// MARK: Run
extension Laka.Creatures {
    
    mutating func run() throws {
        print("☑️ TODO implement subcommand: <\(Self.configuration.abstract)>")
    }
}
