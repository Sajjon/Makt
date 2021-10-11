//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import ArgumentParser

// MARK: All
extension Laka {
    
    /// A command to extract/export/convert ALL original resources from HoMM3 needed to play the rewrite of the game named 'Tritium'.
    struct All: ParsableCommand {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract/export/convert ALL original resources from HoMM3 needed to play the rewrite of the game named 'Tritium'."
        )
        
        // The `@OptionGroup` attribute includes the flags, options, and
        // arguments defined by another `ParsableArguments` type.
        @OptionGroup var options: Options
        
        mutating func run() {
            print("About to extract/export/convert ALL original game resources. This will take a couple of minutes. ☕️")
        }
    }
}
