//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation

// MARK: - TOWNS
// MARK: -
extension Laka.Textures {
    
    // MARK: Town + Files
    private var townDefFiles: [String] {
        [
            "avccasx0.def",
            "avccast0.def",
            "avccasz0.def",
            "avchforx.def",
            "avchfor0.def",
            "avchforz.def",
            "avcdunx0.def",
            "avcdung0.def",
            "avcdunz0.def",
            "avcftrx0.def",
            "avcftrt0.def",
            "avcforz0.def",
            "avcinfx0.def",
            "avcinft0.def",
            "avcinfz0.def",
            "avcnecx0.def",
            "avcnecr0.def",
            "avcnecz0.def",
            "avcramx0.def",
            "avcramp0.def",
            "avcramz0.def",
            "avcranx0.def",
            "avcrand0.def",
            "avcranz0.def",
            "avcstrx0.def",
            "avcstro0.def",
            "avcstrz0.def",
            "avctowx0.def",
            "avctowr0.def",
            "avctowz0.def"
        ]
    }
    
    var townsDefsCount: Int {
        townDefFiles.count
    }
    
    func exportTowns() throws {
        defer { finishedExtractingEntries(count: townsDefsCount) }
        
        let townFiles: [DefImageExport] = townDefFiles.map { defFileName in
            DefImageExport(defFileName: defFileName, nameFromFrameAtIndexIndex: { _, _ in defFileName })
        }
        try generateTexture(
            name: "towns",
            list: townFiles.map { .def($0) }
        )
    }
}
