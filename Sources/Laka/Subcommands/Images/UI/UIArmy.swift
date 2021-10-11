//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation
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
    
    func exportArtifacts() throws {
        try generateTexture(
            name: "artifacts",
            list: [
                .init(
                    defFileName: "artifact.def",
                    nameFromFrameAtIndexIndex: { frame, frameIndex in
                        let namePrefix = "artifact_icon"
                        let artifactIDRaw = frameIndex
                        
                        if let artifactID = try? Artifact.ID(integer: artifactIDRaw) {
                            
                            return [namePrefix, String(describing: artifactID)].joined(separator: "_")
                        } else {
                            /// Special case
                            return [namePrefix, frame.fileName.lowercased()].joined(separator: "_")
                        }
                    })
            ]
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
            name: atlasName,
            list: [
                .init(
                    defFileName: defFileName,
                    nameFromFrameAtIndexIndex: { frame, frameIndex in
                        let namePrefix = keyPrefix
                        let creatureIDIndex = frameIndex - 2 // need to offset by 2 since two first are special case, "blank" and "focused".
                        
                        guard creatureIDIndex >= 0 else {
                            return [namePrefix, frame.fileName.lowercased()].joined(separator: "_")
                        }
                        
                        if let creatureID = try? Creature.ID(integer: creatureIDIndex) {
                            
                            return [namePrefix, String(describing: creatureID)].joined(separator: "_")
                        } else {
                            if verbose {
                                print("⚠️ Ignoring image for frame with index: \(frameIndex), since no creature with that ID exists. Probably some empty placeholder value.")
                            }
                            return nil
                        }
                    })
            ]
        )
    }
}
