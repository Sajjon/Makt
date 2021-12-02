//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-12.
//

import Foundation
import Malm

extension Laka.UI {
    
    static let armyBackgroundImagaeTasks: [GenerateAtlasTask] = [
        armyBGImageTask(faction: .castle, pcxImageName: "tpcascas.pcx"),
        armyBGImageTask(faction: .dungeon, pcxImageName: "tpcasdun.pcx"),
        armyBGImageTask(faction: .conflux, pcxImageName: "tpcasele.pcx"),
        armyBGImageTask(faction: .fortress, pcxImageName: "tpcasfor.pcx"),
        armyBGImageTask(faction: .inferno, pcxImageName: "tpcasinf.pcx"),
        armyBGImageTask(faction: .necropolis, pcxImageName: "tpcasnec.pcx"),
        armyBGImageTask(faction: .rampart, pcxImageName: "tpcasram.pcx"),
        armyBGImageTask(faction: .stronghold, pcxImageName: "tpcasstr.pcx"),
        armyBGImageTask(faction: .tower, pcxImageName: "tpcastow.pcx"),
        armyBGImageTask(faction: .neutral, pcxImageName: "tpcasneu.pcx")
    ]
    
}

private extension Laka.UI {

    static func armyBGImageTask(
        faction: Faction,
        pcxImageName: String
    ) -> GenerateAtlasTask {
        GenerateAtlasTask(
            atlasName: "army_background_\(faction.name).png",
            pcxFileName: pcxImageName
        )
    }
}

