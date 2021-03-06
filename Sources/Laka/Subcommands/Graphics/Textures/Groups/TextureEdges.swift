//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation

extension Laka.Textures {

    static let edgesTask = GenerateAtlasTask(
        atlasName: "edges",
        defFileList: [.init(
            defFileName: "edg.def",
            nameFromFrameAtIndexIndex: { _, frameIndex in "edge_\(frameIndex).png" })
        ]
    )
}
