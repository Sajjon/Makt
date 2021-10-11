//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation

extension Laka.Textures {
    
    var heroes: [String] {
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
    
    func exportHero() throws {
        let heroFileList = heroes.map { defFileName in
            ImageExport(defFileName: defFileName, nameFromFrameIndex: { _ in defFileName })
        }
        
        try generateTexture(
            name: "hero",
            list: heroFileList,
            maxImageCountPerDefFile: 1
        )
    }
}
