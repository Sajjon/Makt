//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation
import Common
import Malm

extension Laka.UI {
    
    func exportArmyIcons() throws {
        try exportArmyIcons(
            atlasName: "army_icons",
            keyPrefix: "army_icon",
            defFileName: "twcrport.def"
        )
    }
    
    func exportArmyIconsSmall() throws {
        try exportArmyIcons(
            atlasName: "army_icons_small",
            keyPrefix: "army_icon_small",
            defFileName: "cprsmall.def"
        )
    }
}


private extension Laka.UI {
    
    func exportArmyIcons(
        atlasName: String,
        keyPrefix: String,
        defFileName: String
    ) throws {
        try generateTexture(
            atlasName: atlasName,
            defFileName: defFileName
        ) { frame, frameIndex in
            
            let namePrefix = keyPrefix
            let creatureIDIndex = frameIndex - 2 // need to offset by 2 since two first are special case, "blank" and "focused".
            
            guard creatureIDIndex >= 0 else {
                return [namePrefix, frame.fileName.lowercased()].joined(separator: "_")
            }
            
            if let creatureID = try? Creature.ID(integer: creatureIDIndex) {
                
                return [namePrefix, String(describing: creatureID)].joined(separator: "_")
            } else {
                logger.trace("⚠️ Ignoring image for frame with index: \(frameIndex), since no creature with that ID exists. Probably some empty placeholder value.")
                return nil
            }
        }
    }
}
