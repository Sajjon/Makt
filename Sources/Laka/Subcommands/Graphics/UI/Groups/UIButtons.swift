//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-12.
//

import Foundation
import Common

extension Laka.UI {
    static let buttonsTasks: [GenerateAtlasTask] = [
        taskFormatArmageddonsBlade(),
        taskFormatRestorationOfErathia(),
        taskFormatShadowOfDeath(),
        taskHeroButton(),
        taskUndergroundButton(),
        taskCancelButton(),
        taskOKButton(),
        taskMainMenuLoadGameButton(),
        taskSizeSmallButton(),
        taskSizeMediumButton(),
        taskSizeLargeButton(),
        taskSizeExtraLargeButton()
    ]

}


private extension Laka.UI {
    
    static func taskFormatArmageddonsBlade() -> GenerateAtlasTask {
        buttonTask(
            name: "main_menu_campaign_armageddons_blade",
            defFileName: "cssarm.def"
        )
    }
    
    static func taskFormatRestorationOfErathia() -> GenerateAtlasTask {
        buttonTask(
            name: "main_menu_campaign_restoration_of_erathia",
            defFileName: "cssroe.def"
        )
    }
    
    static func taskFormatShadowOfDeath() -> GenerateAtlasTask {
        buttonTask(
            name: "main_menu_campaign_shadow_of_death",
            defFileName: "csssod.def"
        )
    }
    
    static func taskHeroButton() -> GenerateAtlasTask {
        buttonTask(
            name: "hero",
            defFileName: "iam000.def"
        )
    }
    
    static func taskUndergroundButton() -> GenerateAtlasTask {
        buttonTask(
            name: "underground",
            defFileName: "ranundr.def"
        )
    }
    
    static func taskCancelButton() -> GenerateAtlasTask {
        buttonTask(
            name: "cancel",
            defFileName: "icancel.def"
        )
    }
    
    static func taskOKButton() -> GenerateAtlasTask {
        buttonTask(
            name: "ok",
            defFileName: "iokay.def"
        )
    }
    
    static func taskMainMenuLoadGameButton() -> GenerateAtlasTask {
        buttonTask(
            name: "main_menu_load_game",
            defFileName: "mmenulg.def"
        )
    }
    
    static func taskSizeLargeButton() -> GenerateAtlasTask {
        buttonTask(
            name: "size_large",
            defFileName: "ransizl.def"
        )
    }
    
    
    static func taskSizeMediumButton() -> GenerateAtlasTask {
        buttonTask(
            name: "size_medium",
            defFileName: "ransizm.def"
        )
    }
    
    static func taskSizeSmallButton() -> GenerateAtlasTask {
        buttonTask(
            name: "size_small",
            defFileName: "ransizs.def"
        )
    }
    
    static func taskSizeExtraLargeButton() -> GenerateAtlasTask {
        buttonTask(
            name: "size_extra_large",
            defFileName: "ransizx.def"
        )
    }
    
}


private extension Laka.UI {
    
    static func buttonTask(
        name buttonName: String,
        defFileName: String
    ) -> GenerateAtlasTask {
        let button = "button"
        let atlasName = [
            buttonName,
            button
        ].joined(separator: "_")
        
        return .init(
            atlasName: atlasName,
            defFile: .init(defFileName: defFileName) { frame, frameIndex in
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
            },
            skipImagesWithSameNameAndData: true
        )
    }
    
}
