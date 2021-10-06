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
import Foundation

extension Laka {
    
    /// A command to extract all textures, such as terrain, monsters, artifacts,
    /// heroes and towns on the map etc. But not game menu UI, neither
    /// in combat/battle creature sprites nor in town UI.
    struct Textures: ParsableCommand {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract texture images such as terrain, artifacts, monsters etc. But not game menu UI."
        )
        
        @OptionGroup var options: Options
    }
}

// MARK: Run
extension Laka.Textures {
    
    mutating func run() throws {
        print("🔮 Extracting texture images from entires exported by the `Laka LOD` command.")
        try exportTerrain()
    }
}

// MARK: Export
private extension Laka.Textures {
    
    var fileManager: FileManager { .default }
    
    func exportTerrain() throws {
        
    }
    

}
