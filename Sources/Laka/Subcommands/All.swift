//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import ArgumentParser
import Common

// MARK: All
extension Laka {
    
    /// A command to extract/export/convert ALL original resources from HoMM3 needed to play the rewrite of the game named 'Tritium'.
    struct All: CMD {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract/export/convert ALL original resources from HoMM3 needed to play the rewrite of the game named 'Tritium'."
        )
        
        // The `@OptionGroup` attribute includes the flags, options, and
        // arguments defined by another `ParsableArguments` type.
        @OptionGroup var options: Options
        
        /// Short description printed once this command starts executing.
        static let executionOneLinerDescription = "🔮 Extracting ALL game assets"
        
        /// Rought optimistic estimation of rune time in seconds.
        static let optimisticEstimatedRunTime = Laka.specificCommands.map({ $0.optimisticEstimatedRunTime }).reduce(0, +)
        
        /// Entry point for this sub command
        func extract() throws {
            
            func logDivisor(character: String = "=") {
                let divisor = Logger.Message(stringLiteral: .init(repeating: character, count: Int(Double(terminalWidth) * 0.6)))
                logger.notice(divisor)
            }
            
            logDivisor()
            
            try Laka.specificCommands.forEach { commandType in
                var command = commandType.init(options: _options)
                try command.run()
            }
            
            logDivisor()
            logger.notice("✅ Finished extracting all game assets. Enjoy the game ♘♕♖")
            logDivisor()
        }
    }
}
