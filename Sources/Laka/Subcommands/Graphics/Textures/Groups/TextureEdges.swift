//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation

extension Laka.Textures {
    
    var edgesDefsCount: Int {
        1
    }
    
    func exportEdges() throws {
        try generateTexture(
            name: "edges",
            list: [.def(
                .init(
                    defFileName: "edg.def",
                    nameFromFrameAtIndexIndex: { _, frameIndex in "edge_\(frameIndex).png" })
                )
            ],
//            didCalculateWorkLoad: { self.report(numberOfEntriesToExtract: $0) },
            finishedExportingOneEntry: self.finishedExtractingEntry
        )
    }
}
