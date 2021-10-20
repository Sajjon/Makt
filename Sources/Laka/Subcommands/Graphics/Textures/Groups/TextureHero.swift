//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation

extension Laka.Textures {
    
    private var heroes: [String] {
        [
            "ah00_e.def",
            "ah01_e.def",
            "ah02_e.def",
            "ah03_e.def",
            "ah04_e.def",
            "ah05_e.def",
            "ah06_e.def",
            "ah07_e.def",
            "ah08_e.def",
            "ah09_e.def",
            "ah10_e.def",
            "ah11_e.def",
            "ah12_e.def",
            "ah13_e.def",
            "ah14_e.def",
            "ah15_e.def",
            "ah16_e.def",
            "ah17_e.def",
            "ahplace.def",
            "ahrandom.def"
          ]
    }
    
    var heroesDefsCount: Int {
        heroes.count
    }
    
    func exportHero() throws {
        defer { finishedExtractingEntries(count: heroesDefsCount) }
        let heroFileList = heroes.map { defFileName in
            DefImageExport(defFileName: defFileName, nameFromFrameAtIndexIndex: { _, _ in defFileName })
        }
        
        try generateTexture(
            name: "hero",
            list: heroFileList.map { .def($0) },
            maxImageCountPerDefFile: 1
        )
    }
}
