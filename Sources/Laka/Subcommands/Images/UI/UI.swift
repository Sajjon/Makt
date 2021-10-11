//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import ArgumentParser
import Guld
import Malm
import Util

extension Laka {
    
    /// A command to extract all images used to render UI of original game,
    /// which includes game menus, and all in game menus, except for in town
    /// UI.
    struct UI: ParsableCommand, TextureGenerating {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract images used to render UI of original game."
        )
        
        @OptionGroup var parentOptions: Options
    }
}

// MARK: Computed props
extension Laka.UI {
    
    var verbose: Bool { parentOptions.printDebugInformation }

    
    var inDataURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath).appendingPathComponent("Raw")
    }
    
    var outImagesURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath)
            .appendingPathComponent("Converted")
            .appendingPathComponent("UI")
    }
}



// MARK: Run
extension Laka.UI {
    
    mutating func run() throws {
        print(
            """
            
            🔮
            About to extract all images used to render UI of original game, from entries exported by the `Laka LOD` command.
            Located at: \(inDataURL.path)
            To folder: \(outImagesURL.path)
            This will take about XYZ seconds on a fast machine (Macbook Pro 2019 - Intel CPU)
            ☕️
            
            """
        )
        
        try exportArmyIcons()
        try exportArmyIconsSmall()
        try exportArtifacts()
        try exportFlags()
        try exportHallBuildings()
        try exportPrimarySkill()
        try exportSecondarySkill()
        try exportSpells()
    }
    
    func exportArtifacts() throws {
        try generateTexture(
            atlasName: "artifacts",
            defFileName: "artifact.def"
        ) { frame, frameIndex in
            let namePrefix = "artifact_icon"
            if let artifactID = try? Artifact.ID(integer: frameIndex) {
                return [namePrefix, String(describing: artifactID)].joined(separator: "_")
            } else {
                /// Special case artifacts
                return [namePrefix, frame.fileName.lowercased()].joined(separator: "_")
            }
        }
    }
    
    func exportFlags() throws {
        try generateTexture(
            atlasName: "flags",
            defFileName: "crest58.def"
        )
    }
    
    func exportPrimarySkill() throws {
        try generateTexture(
            atlasName: "primary_skill",
            defFileName: "pskill.def"
        )
    }
    
    func exportSecondarySkill() throws {
        try generateTexture(
            atlasName: "secondary_skill",
            defFileName: "secskill.def"
        ) { frame, frameIndex in
            let namePrefix = "secondary_skill"
            let offset = 1
            let iconsPerSkill = Hero.SecondarySkill.Level.allCases.count
            guard frameIndex >= offset*iconsPerSkill else { return nil } // ignore empty
            let value = frameIndex - offset*iconsPerSkill
            let valueQaR = value.quotientAndRemainder(dividingBy: iconsPerSkill)
            let skillKindRaw = valueQaR.quotient
            let skillLeveKindRaw = valueQaR.remainder
            let skillKind = try Hero.SecondarySkill.Kind(integer: skillKindRaw)
            let skillLevel = try Hero.SecondarySkill.Level(integer: skillLeveKindRaw + 1)
            return [
                namePrefix,
                String(describing: skillKind),
                String(describing: skillLevel),
            ].joined(separator: "_")
        }
    }
    
    func exportSpells() throws {
        try generateTexture(
            atlasName: "spells",
            defFileName: "spells.def"
        ) { frame, frameIndex in
            let namePrefix = "spell_icon"
            let spellID = try Spell.ID(integer: frameIndex)
            return [namePrefix, String(describing: spellID)].joined(separator: "_")
        }
    }
}
