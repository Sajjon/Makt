//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation
import Malm
import Common

extension Laka.UI {

    /// Images of buildings to chose to build from the build new buildings UI (in village/town/city HALL - hence the prefix `"hall"`).
    static let hallBuildingsTasks: [GenerateAtlasTask] = [
        hallBuildingsTask(faction: .castle, defFileName: "hallcstl.def"),
        hallBuildingsTask(faction: .dungeon, defFileName: "halldung.def"),
        hallBuildingsTask(faction: .conflux, defFileName: "hallelem.def"),
        hallBuildingsTask(faction: .fortress, defFileName: "hallfort.def"),
        hallBuildingsTask(faction: .inferno, defFileName: "hallinfr.def"),
        hallBuildingsTask(faction: .necropolis, defFileName: "hallnecr.def"),
        hallBuildingsTask(faction: .rampart, defFileName: "hallramp.def"),
        hallBuildingsTask(faction: .stronghold, defFileName: "hallstrn.def"),
        hallBuildingsTask(faction: .tower, defFileName: "halltowr.def")
    ]
}

private extension Building.ID.Castle {
    init(frameName frameNameWithSuffix: String) throws {
        let frameName = String(frameNameWithSuffix.split(separator: ".").first!)
        switch frameName {
        case "ThCsMag1": self = .mageGuildLevel1
        case "ThCsMag2": self = .mageGuildLevel2
        case "ThCsMag3": self = .mageGuildLevel3
        case "ThCsMag4": self = .mageGuildLevel4
        case "ThCsTav1": self = .tavern
        case "ThCsDock": self = .shipyard
        case "ThCsCas1": self = .fort
        case "ThCsCas2": self = .citadel
        case "ThCsCas3": self = .castle
        case "ThCsHal1": self = .villageHall
        case "ThCsHal2": self = .townHall
        case "ThCsHal3": self = .cityHall
        case "ThCsHal4": self = .capitol
        case "ThCsMrk1": self = .marketplace
        case "ThCsMrk2": self = .resourceSilo
        case "ThCsBlak": self = .blacksmith
        case "ThCsLite": self = .lighthouse
        case "ThCsGr1H": self = .griffinBastion(isUpgraded: false)
        case "ThCsGr2H": self = .griffinBastion(isUpgraded: true)
        case "ThCsCv2S": self = .stables
        case "ThCsTav2": self = .brotherhoodOfSword
        case "ThCsHoly": self = .colossus
        case "ThCsPik1": self = .guardhouse()
        case "ThCsCrs1": self = .archersTower()
        case "ThCsGr1": self = .griffinTower()
        case "ThCsSwd1": self = .barracks()
        case "ThCsMon1": self = .monastery()
        case "ThCsCv1": self = .trainingGrounds()
        case "ThCsAng1": self = .portalOfGlory()
        case "ThCsPik2": self = .guardhouse(isUpgraded: true)
        case "ThCsCrs2": self = .archersTower(isUpgraded: true)
        case "ThCsGr2": self = .griffinTower(isUpgraded: true)
        case "ThCsSwd2": self = .barracks(isUpgraded: true)
        case "ThCsMon2": self = .monastery(isUpgraded: true)
        case "ThCsCv2": self = .trainingGrounds(isUpgraded: true)
        case "ThCsAng2": self = .portalOfGlory(isUpgraded: true)
        default: incorrectImplementation(reason: "Unrecognized castle building: \(frameName)")
        }
    }
}

func buildingName(faction: Faction, frameName: String) throws -> String {
    switch faction {
    case .castle: return try Building.ID.Castle(frameName: frameName).name
    default: return frameName
    }
}


private extension Laka.UI {
    
    static func hallBuildingsTask(
        faction: Faction,
        defFileName: String
    ) -> GenerateAtlasTask {
        let atlasName = "hall_\(faction.name)_buildings"

        return .init(
            atlasName: atlasName,
            defFile: .init(
                defFileName: defFileName
            )  { frame, frameIndex in
                let buildingName = try buildingName(faction: faction, frameName: frame.fileName)
                return [
                    atlasName,
                    buildingName,
                    String(describing: frameIndex)
                ].joined(separator: "_")
            }
        )
    }

}
