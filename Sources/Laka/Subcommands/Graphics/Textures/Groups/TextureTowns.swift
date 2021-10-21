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
    private static let townDefFiles: [String] =
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

    static let townsTask = Task(
        atlasName: "towns",
        defList: townDefFiles
    )
}
