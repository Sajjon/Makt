//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-12.
//

import Foundation
import Malm

extension Laka.UI {
    func exportArmyBackgrounds() throws {
        try exportCastleArmyBackground()
        try exportDungeonArmyBackground()
        try exportConfluxArmyBackground()
        try exportFortressArmyBackground()
        try exportInfernoArmyBackground()
        try exportNecropolisArmyBackground()
        try exportRampartArmyBackground()
        try exportStrongholdArmyBackground()
        try exportTowerArmyBackground()
        try exportNeutralArmyBackground()
    }
}

private extension Laka.UI {
    func exportCastleArmyBackground() throws {
        try exportArmyBackground(faction: .castle, pcxImageName: "tpcascas.pcx")
    }
    
    func exportDungeonArmyBackground() throws {
        try exportArmyBackground(faction: .dungeon, pcxImageName: "tpcasdun.pcx")
    }
    
    func exportConfluxArmyBackground() throws {
        try exportArmyBackground(faction: .conflux, pcxImageName: "tpcasele.pcx")
    }
    
    func exportFortressArmyBackground() throws {
        try exportArmyBackground(faction: .fortress, pcxImageName: "tpcasfor.pcx")
    }
    
    func exportInfernoArmyBackground() throws {
        try exportArmyBackground(faction: .inferno, pcxImageName: "tpcasinf.pcx")
    }

    func exportNecropolisArmyBackground() throws {
        try exportArmyBackground(faction: .necropolis, pcxImageName: "tpcasnec.pcx")
    }

    func exportRampartArmyBackground() throws {
        try exportArmyBackground(faction: .rampart, pcxImageName: "tpcasram.pcx")
    }
    
    func exportStrongholdArmyBackground() throws {
        try exportArmyBackground(faction: .stronghold, pcxImageName: "tpcasstr.pcx")
    }
    
    func exportTowerArmyBackground() throws {
        try exportArmyBackground(faction: .tower, pcxImageName: "tpcastow.pcx")
    }
    
    func exportNeutralArmyBackground() throws {
        try exportArmyBackground(faction: .neutral, pcxImageName: "tpcasneu.pcx")
    }
    
    func exportArmyBackground(
        faction: Faction,
        pcxImageName: String
    ) throws {
        try generateTexture(
            imageName: "army_background_\(faction.name).png",
            pcxImageName: pcxImageName
        )
    }
}

