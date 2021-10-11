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
    
    /// A command to extract in town game menu such as background and buildings.
    struct Towns: ParsableCommand {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract in town game menu such as background and buildings."
        )
        
        @OptionGroup var options: Options
    }
}

// MARK: Run
extension Laka.Towns {
    
    mutating func run() throws {
        print("☑️ TODO implement subcommand: <\(Self.configuration.abstract)>")
    }
}
