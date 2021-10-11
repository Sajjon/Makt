//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import ArgumentParser
import Guld
import Malm
import Util

extension Laka {
    
    /// A command to extract all images used to render UI of original game,
    /// which includes game menus, and all in game menus, except for in town
    /// UI.
    struct UI: ParsableCommand, TextureGenerating {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract images used to render UI of original game."
        )
        
        @OptionGroup var parentOptions: Options
    }
}

// MARK: Computed props
extension Laka.UI {
    
    var verbose: Bool { parentOptions.printDebugInformation }

    
    var inDataURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath).appendingPathComponent("Raw")
    }
    
    var outImagesURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath)
            .appendingPathComponent("Converted")
            .appendingPathComponent("UI")
    }
}



// MARK: Run
extension Laka.UI {
    
    mutating func run() throws {
        print(
            """
            
            🔮
            About to extract all images used to render UI of original game, from entries exported by the `Laka LOD` command.
            Located at: \(inDataURL.path)
            To folder: \(outImagesURL.path)
            This will take about XYZ seconds on a fast machine (Macbook Pro 2019 - Intel CPU)
            ☕️
            
            """
        )
        
        try exportArmyIcons()
        try exportArmyIconsSmall()
    }
}
