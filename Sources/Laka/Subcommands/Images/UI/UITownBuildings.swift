//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation
import Malm

private enum Building: CustomDebugStringConvertible {
    case normal(Map.Town.Building)
    
    enum Special: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
        case villageHall = 10
        
        var name: String {
            switch self {
            case .villageHall: return "villageHall"
            }
        }
        
        var debugDescription: String {
            name
        }
    }
    case special(Special)
    
    var name: String {
        switch self {
        case .normal(let normal): return normal.name
        case .special(let special): return special.name
        }
    }
    
    var debugDescription: String { name }
    
}

private func buildingIDFrom(frameIndex: Int) throws -> Building {
    let placeholder: Map.Town.Building = .mageGuildLevel1
    
    /// UNKNOWN
    let UNKNOWN: Map.Town.Building = .mageGuildLevel1 /* UNKNOWN */
    
    let placeholderVillageHall = placeholder
    
    let normal: [Map.Town.Building] = [
        .mageGuildLevel1,
        .mageGuildLevel2,
        .mageGuildLevel3,
        .mageGuildLevel4,
        .mageGuildLevel5, // Castle: Mage guild 1 AGAIN (because lacks 5).
       
            .tavern,
        .shipyard, // Tower: Mage guild 1 AGAIN (because lacks `shipyard`)
        
            .fort,
        .citadel,
        .castle,
       
        placeholderVillageHall,
        .townHall,
        .cityHall,
        .capitol,
        
        .marketplace,
        .resourceSilo,
        .blacksmith,
        
        .special1,
        .horde1,
        .horde2,
        UNKNOWN, // ?????
        .special2,
        .special3,
        .special4,
        .horde3,
        .horde4,
        .grail,
        UNKNOWN, // ???
        UNKNOWN, // ???
        UNKNOWN, // ???
        .dwelling1,
        .dwelling2,
        .dwelling3,
        .dwelling4,
        .dwelling5,
        .dwelling6,
        .dwelling7,
        .upgradedDwelling1,
        .upgradedDwelling2,
        .upgradedDwelling3,
        .upgradedDwelling4,
        .upgradedDwelling5,
        .upgradedDwelling6,
        .upgradedDwelling7,
    ]
    
//        let normalBuildings: [Building] = normal.map { Building.normal($0) }
//        let specialBuildings = Building.Special.allCases.map { Building.special($0) }
    
    if let specialBuilding = Building.Special.allCases.first(where:  { $0.rawValue == frameIndex }) {
        return .special(specialBuilding)
    }
    
    return .normal(normal[frameIndex])
}

extension Laka.UI {

    /// Images of buildings to chose to build from the build new buildings UI (in village/town/city HALL - hence the prefix `"hall"`).
    func exportHallBuildings() throws {
        try exportHallCastleBuildings()
        try exportHallDungeonBuildings()
        try exportHallConfluxBuildings()
        try exportHallFortressBuildings()
        try exportHallInfernoBuildings()
        try exportHallNecropolisBuildings()
        try exportHallRampartBuildings()
        try exportHallTowerBuildings()
    }
}

private extension Laka.UI {
    
    func exportHallCastleBuildings() throws {
        try exportHallBuildings(faction: .castle, defFileName: "hallcstl.def")
    }

    func exportHallDungeonBuildings() throws {
        try exportHallBuildings(faction: .dungeon, defFileName: "halldung.def")
    }

    func exportHallConfluxBuildings() throws {
        try exportHallBuildings(faction: .conflux, defFileName: "hallelem.def")
    }

    func exportHallFortressBuildings() throws {
        try exportHallBuildings(faction: .fortress, defFileName: "hallfort.def")
    }

    func exportHallInfernoBuildings() throws {
        try exportHallBuildings(faction: .inferno, defFileName: "hallinfr.def")
    }

    func exportHallNecropolisBuildings() throws {
        try exportHallBuildings(faction: .necropolis, defFileName: "hallnecr.def")
    }

    func exportHallRampartBuildings() throws {
        try exportHallBuildings(faction: .rampart, defFileName: "hallramp.def")
    }

    func exportHallStrongholdBuildings() throws {
        try exportHallBuildings(faction: .stronghold, defFileName: "hallstrn.def")
    }

    func exportHallTowerBuildings() throws {
        try exportHallBuildings(faction: .tower, defFileName: "halltowr.def")
    }

    func exportHallBuildings(
        faction: Faction,
        defFileName: String
    ) throws {
        let atlasName = "hall_\(faction.name)_buildings"
        return try generateTexture(
            atlasName: atlasName,
            defFileName: defFileName
        ) { frame, frameIndex in
            let buildingID = try buildingIDFrom(frameIndex: frameIndex)
            return [
                atlasName,
                String(describing: buildingID)
            ].joined(separator: "_")
        }
    }

}
