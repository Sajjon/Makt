//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation

extension Laka.Textures {
    
    func exportEdges() throws {
        
        try generateTexture(
            name: "edges",
            list: [
                .init(
                    defFileName: "edg.def",
                    nameFromFrameIndex: { frameIndex in "edge_\(frameIndex).png" })
            ]
        )
    }
}
