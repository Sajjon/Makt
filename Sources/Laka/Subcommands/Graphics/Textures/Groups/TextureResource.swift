//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation

extension Laka.Textures {
    
    private static let resources: [String] = [
            "avtcrys0.def",
            "avtgems0.def",
            "avtgold0.def",
            "avtmerc0.def",
            "avtore0.def",
            "avtsulf0.def",
            "avtwood0.def",
            "avtrndm0.def",
            "avxabnd0.def",
            "avmalch0.def",
            "avmcrdr0.def",
            "avmgedr0.def",
            "avmgodr0.def",
            "avmordr0.def",
            "avmsawd0.def",
            "avmsulf0.def",
            "avmabmg.def",
            "avmcrys0.def",
            "avmcrgr0.def",
            "avmgems0.def",
            "avmgogr0.def",
            "avmgold0.def",
            "avmore0.def",
            "avmsawg0.def",
            "avmcrvo0.def",
            "avmgelv0.def",
            "avmgovo0.def",
            "avmorlv0.def",
            "avmsawl0.def",
            "avmcrrf0.def",
            "avmgerf0.def",
            "avmgorf0.def",
            "avmorro0.def",
            "avmsawr0.def",
            "avmcrds0.def",
            "avmgods0.def",
            "avmords0.def",
            "avmswds0.def",
            "avmcrsw0.def",
            "avmgosw0.def",
            "avmorsw0.def",
            "avmalcs0.def",
            "avmcrsn0.def",
            "avmgesn0.def",
            "avmgosn0.def",
            "avmorsn0.def",
            "avmswsn0.def",
            "avmcrsu0.def",
            "avmgosb0.def",
            "avmorsb0.def",
            "avxamgr.def",
            "avxamlv.def",
            "avxamro.def",
            "avxamds.def",
            "avxamsw.def",
            "avxamsn.def",
            "avxamsu.def"
          ]
    
    static let resourcesTask = GenerateAtlasTask(
        atlasName: "resources",
        defList: resources
    )
}
