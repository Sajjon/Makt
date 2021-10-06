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
    
    /// A command to convert `.h3m` map files to `.json` format.
    struct ConvertMaps: ParsableCommand {
        
        static var configuration = CommandConfiguration(
            abstract: "Convert `.h3m` map files to `.json` format."
        )
        
        @OptionGroup var options: Options
    }
}

// MARK: Run
extension Laka.ConvertMaps {
    
    mutating func run() throws {
        print("☑️ TODO implement subcommand: <\(Self.configuration.abstract)>")
    }
}
