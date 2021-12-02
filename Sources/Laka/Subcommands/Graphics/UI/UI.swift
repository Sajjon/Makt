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
import Common

extension Laka {
    /// A command to extract all images used to render UI of original game,
    /// which includes game menus, and all in game menus, except for in town
    /// UI.
    struct UI: CMD, TextureGenerating, TaskExecuting {
        @OptionGroup var options: Options
    }
}

// MARK: Computed props
extension Laka.UI {
    
    static var configuration = CommandConfiguration(
        abstract: "Extract images used to render UI of original game."
    )
    
    static let executionOneLinerDescription = "🖼  Extracting all menu UI"
    static let optimisticEstimatedRunTime: TimeInterval = 10
    
    static let tasks: [GenerateAtlasTask] = [
        armyIconsTasks,
        armyIconsSmallTasks,
        artifactsTask,
        flagsTask,
        primarySkillsTask,
        secondarySkillsTask,
        spellsTask,
        spellScrollsTask,
        spellTabsTask,
        magicSchoolsTask,
        resourcesTask,
        dialogBorderTask,
        mageGuildsTask,
        spellBookBackgroundTask,
        spellBookCornerRightTask,
        spellBookCornerLeftTask,
        heroStatsSummaryBackgroundTask,
        dialogBoxBackgroundSmallTask,
        dialogBoxBackgroundTask,
        creatureStatsSummaryBackgroundTask,
        logoTask
    ] + armyBackgroundImagaeTasks + hallBuildingsTasks + buttonsTasks
    
    var inDataURL: URL {
        .init(fileURLWithPath: options.outputPath).appendingPathComponent("Raw")
    }
    
    var outImagesURL: URL {
        .init(fileURLWithPath: options.outputPath)
        .appendingPathComponent("Converted")
        .appendingPathComponent("Graphics")
        .appendingPathComponent("UI")
    }
}


private extension GenerateAtlasTask {
    
    static func armyIcons(
        atlasName: String,
        keyPrefix: String,
        defFileName: String
    ) -> Self {
        .init(
            atlasName: atlasName,
            defFile: .init(
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
        )
    }
}

// MARK: Helpers
private extension Laka.UI {
    
    static let armyIconsTasks = GenerateAtlasTask.armyIcons(
        atlasName: "army_icons",
        keyPrefix: "army_icon",
        defFileName: "twcrport.def"
    )
    
    static let armyIconsSmallTasks = GenerateAtlasTask.armyIcons(
        atlasName: "army_icons_small",
        keyPrefix: "army_icon_small",
        defFileName: "cprsmall.def"
    )
    
    static let artifactsTask = GenerateAtlasTask(
        atlasName: "artifacts",
        defFile: .init(
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
    )
    
    static let flagsTask = GenerateAtlasTask(
        atlasName: "flags",
        defFileName: "crest58.def"
    )
    
    static let primarySkillsTask = GenerateAtlasTask(
        name: "Primary skill",
        atlasName: "primary_skill",
        defFileName: "pskill.def"
    )
    
    static let secondarySkillsTask = GenerateAtlasTask(
        name: "Secondary skill",
        atlasName: "secondary_skill",
        defFile: .init(defFileName: "secskill.def") { frame, frameIndex in
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
    )
    
    static let spellsTask = GenerateAtlasTask(
        atlasName: "spells",
        defFile: .init(defFileName: "spells.def") { frame, frameIndex in
            let namePrefix = "spell_icon"
            let spellID = try Spell.ID(integer: frameIndex)
            return [namePrefix, String(describing: spellID)].joined(separator: "_")
        }
    )
    
    static let spellScrollsTask = GenerateAtlasTask(
        atlasName: "spell_scrolls",
        defFile: .init(defFileName: "spellscr.def") { frame, frameIndex in
            let namePrefix = "spell_icon"
            do {
                let spellID = try Spell.ID(integer: frameIndex)
                return [namePrefix, String(describing: spellID)].joined(separator: "_")
            } catch {
                guard frame.fileName.lowercased() == "sm99all.pcx" else {
                    incorrectImplementation(reason: "Have covered all spell scrolls")
                }
                let humanReadable = "every_spell_in_the_game"
                return [namePrefix, humanReadable].joined(separator: "_")
            }
        }
    )
    
    
    static let spellTabsTask = GenerateAtlasTask(
        atlasName: "spell_tabs",
        defFileName: "speltab.def"
    )
    
    static let magicSchoolsTask = GenerateAtlasTask(
        atlasName: "magic_schools",
        defFileName: "schools.def"
    )
    
    static let resourcesTask = GenerateAtlasTask(
        atlasName: "resource_icons",
        defFileName: "resource.def"
    )
    
    static let dialogBorderTask = GenerateAtlasTask(
        atlasName: "dialog_border_image",
        defFileName: "dialgbox.def"
    )
    
    static let mageGuildsTask = GenerateAtlasTask(
        atlasName: "mage_guild.png",
        pcxFileName: "tpmage.pcx"
    )
    
    static let spellBookBackgroundTask = GenerateAtlasTask(
        atlasName: "spellbook_background.png",
        pcxFileName: "spelback.pcx"
    )
    
    static let spellBookCornerRightTask = GenerateAtlasTask(
        atlasName: "spellbook_corner_right.png",
        pcxFileName: "speltrnr.pcx"
    )
    
    static let spellBookCornerLeftTask = GenerateAtlasTask(
        atlasName: "spellbook_corner_left.png",
        pcxFileName: "speltrnl.pcx"
    )
    
    static let heroStatsSummaryBackgroundTask = GenerateAtlasTask(
        atlasName: "hero_stats_summary_background.png",
        pcxFileName: "heroqvbk.pcx"
    )
    
    static let dialogBoxBackgroundSmallTask = GenerateAtlasTask(
        atlasName: "dialog_box_background_small.png",
        pcxFileName: "dibox128.pcx"
    )
    
    static let dialogBoxBackgroundTask = GenerateAtlasTask(
        atlasName: "dialog_box_background.png",
        pcxFileName: "diboxbck.pcx"
    )
    
    static let creatureStatsSummaryBackgroundTask = GenerateAtlasTask(
        atlasName: "creature_stats_summary_background.png",
        pcxFileName: "crstkpu.pcx"
    )
    
    static let logoTask = GenerateAtlasTask(
        atlasName: "logo.png",
        pcxFileName: "puzzlogo.pcx",
        usePaletteReplacementMap: false
    )
    
}
