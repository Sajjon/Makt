//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-12.
//

import Foundation
import Util

extension Laka.UI {
    func exportButtons() throws {
        try exportFormatArmageddonsBlade()
        try exportFormatRestorationOfErathia()
        try exportFormatShadowOfDeath()
        try exportHeroButton()
        try exportUndergroundButton()
        try exportCancelButton()
        try exportOKButton()
        try exportMainMenuLoadGameButton()
        try exportSizeSmallButton()
        try exportSizeMediumButton()
        try exportSizeLargeButton()
        try exportSizeExtraLargeButton()
    }

}


private extension Laka.UI {
    
    func exportFormatArmageddonsBlade() throws {
        try exportButton(
            name: "main_menu_campaign_armageddons_blade",
            defFileName: "cssarm.def"
        )
    }
    
    func exportFormatRestorationOfErathia() throws {
        try exportButton(
            name: "main_menu_campaign_restoration_of_erathia",
            defFileName: "cssroe.def"
        )
    }
    
    func exportFormatShadowOfDeath() throws {
        try exportButton(
            name: "main_menu_campaign_shadow_of_death",
            defFileName: "csssod.def"
        )
    }
    
    func exportHeroButton() throws {
        try exportButton(
            name: "hero",
            defFileName: "iam000.def"
        )
    }
    
    func exportUndergroundButton() throws {
        try exportButton(
            name: "underground",
            defFileName: "ranundr.def"
        )
    }
    
    func exportCancelButton() throws {
        try exportButton(
            name: "cancel",
            defFileName: "icancel.def"
        )
    }
    
    func exportOKButton() throws {
        try exportButton(
            name: "ok",
            defFileName: "iokay.def"
        )
    }
    
    func exportMainMenuLoadGameButton() throws {
        try exportButton(
            name: "main_menu_load_game",
            defFileName: "mmenulg.def"
        )
    }
    
    func exportSizeLargeButton() throws {
        try exportButton(
            name: "size_large",
            defFileName: "ransizl.def"
        )
    }
    
    
    func exportSizeMediumButton() throws {
        try exportButton(
            name: "size_medium",
            defFileName: "ransizm.def"
        )
    }
    
    func exportSizeSmallButton() throws {
        try exportButton(
            name: "size_small",
            defFileName: "ransizs.def"
        )
    }
    
    func exportSizeExtraLargeButton() throws {
        try exportButton(
            name: "size_extra_large",
            defFileName: "ransizx.def"
        )
    }
    
}


private extension Laka.UI {
    
    
    
    func exportButton(
        name buttonName: String,
        defFileName: String,
        maxImageCountPerDefFile: Int? = nil
    ) throws {
        let button = "button"
        let atlasName = [
            buttonName,
            button
        ].joined(separator: "_")
        
        try generateTexture(
            atlasName: atlasName,
            defFileName: defFileName,
            skipImagesWithSameNameAndData: true,
            maxImageCountPerDefFile: maxImageCountPerDefFile
        ) { frame, frameIndex in
            let frameName = String(frame.fileName.lowercased().split(separator: ".").first!)
            let normal = frameName.hasSuffix("n")
            let disabled = frameName.hasSuffix("d")
            let selected = frameName.hasSuffix("s")
            let highlighted = frameName.hasSuffix("h")
            
            let buttonStateName: String
            if normal {
                buttonStateName = "normal"
            } else if disabled {
                buttonStateName = "disabled"
            } else  if selected {
                buttonStateName = "selected"
            } else  if highlighted {
                buttonStateName = "highlighted"
            } else {
                incorrectImplementation(reason: "Non supported button state, frame name: '\(frame.fileName)'")
            }
            
            return [
                buttonName,
               button,
                buttonStateName
            ].joined(separator: "_")
        }
    }
    
}
