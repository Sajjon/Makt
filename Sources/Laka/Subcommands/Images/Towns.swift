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
    
    /// A command to extract in town game menu such as background and buildings.
    struct Towns: ParsableCommand, TextureGenerating {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract in town game menu such as background and buildings."
        )
        
        @OptionGroup var parentOptions: Options
    }
}

// MARK: Run
extension Laka.Towns {
    
    var verbose: Bool { parentOptions.printDebugInformation }
    
    
    var inDataURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath).appendingPathComponent("Raw")
    }
    
    var outImagesURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath)
        .appendingPathComponent("Converted")
        .appendingPathComponent("Towns")
    }
    
    mutating func run() throws {
        print(
            """
            
            🔮
            About to extract all town UI in town original game, from entries exported by the `Laka LOD` command.
            Located at: \(inDataURL.path)
            To folder: \(outImagesURL.path)
            This will take about 12 seconds on a fast machine (Macbook Pro 2019 - Intel CPU)
            ☕️
            
            """
        )
        
        try exportTown(template: .castle)
    }
    
    func exportTown<BuildingKind: BuildingIDForFaction>(template: TownTemplate<BuildingKind>) throws {
        let fileMatrix: [[ImageExport]] = [
            [
                .pcx(.init(pcxImageName: template.townBackground.lowercased())),
                .pcx(.init(pcxImageName: template.creatureBackground.lowercased()))
            ],
            template.buildings.flatMap({ (buildingID: BuildingKind, building: TownTemplate<BuildingKind>.BuildingDetails) -> [ImageExport] in
                return [
                    .def(
                        DefImageExport(
                            defFileName: building.gfx.animation.lowercased(),
                            nameFromFrameAtIndexIndex: { _, frameIndex in "\(buildingID.name)_\(frameIndex)" }
                        )
                    ),
                    .pcx(.init(pcxImageName: building.gfx.border.lowercased()))
                ]
            }),
            template.animations.map({ animation in
                return .def(
                    DefImageExport(
                        defFileName: animation.gfx.lowercased(),
                        nameFromFrameAtIndexIndex: { frame, frameIndex in "\(frame.fileName)_\(frameIndex)" }
                    )
                )
            })
        ]
        
        let fileList: [ImageExport] = fileMatrix.flatMap { $0 }
        
        return try generateTexture(
            name: "town_\(template.faction)",
            list: fileList,
            skipCalculateWorkload: true
        )
        
    }
}
extension TownTemplate {
    var faction: Faction {
        BuildingKind.faction
    }
}
struct TownTemplate<BuildingKind: BuildingIDForFaction>: Codable {
    
    struct Location: Codable {
        let x: Int
        let y: Int
        let z: Int
        
        init(x: Int, y: Int, z: Int = 1) {
            self.x = x
            self.y = y
            self.z = z
        }
    }
    
    struct Graphics: Codable {
        let animation: String
        let border: String
        let area: String
        let animated: Bool
        
        init(
            animation: String,
            border: String,
            area: String,
            animated: Bool = true
        ) {
            self.animation = animation
            self.border = border
            self.area = area
            self.animated = animated
        }
    }
    
    
    struct BuildingDetails: Codable {
        
        typealias Production = Dictionary<Resource.Kind, Int>
        let location: Location
        let gfx: Graphics
        let upgrades: BuildingKind?
        let requires: [BuildingKind]?
        let produce: Production? // Resources?
        
        init(
            location: Location,
            gfx: Graphics,
            upgrades: BuildingKind? = nil,
            requires: [BuildingKind]? = nil,
            produce: Production? = nil
        ) {
            self.location = location
            self.gfx = gfx
            self.produce = produce
            self.upgrades = upgrades
            
            if var requires = requires, let upgrades = upgrades, !requires.contains(upgrades) {
                requires.append(upgrades) // kind of self explainatory that BuildingB upgrading BuildingA requires BuildingA.
                self.requires = requires
            } else {
                self.requires = requires
            }
        }
    }
    
    struct Animation: Codable {
        let location: Location
        let gfx: String
    }
    
    let buildings: [BuildingKind: BuildingDetails]
    let animations: [Animation]
    
    struct Extra: Codable {
        let location: Location
        let gfx: String
    }
    
    struct Upgrade: Codable {
        let location: Location
        let graphics: Graphics
        let requires: [BuildingKind]?
    }
    
    let extras: [BuildingKind: Extra]
    //    let upgrades: [BuildingKind: Upgrade]
    
    let musicTheme: String
    let townBackground: String
    let guildBackground: String
    let guildWindow: String
    let buildingsIcons: String
    let hallBackground: String
    let hallSlots: Array<Array<Array<BuildingKind>>>
    
    struct CreatureUpgradePair: Codable {
        let nonUpgraded: Creature.ID
        let upgraded: Creature.ID
    }
    
    let creatures: [CreatureUpgradePair]
    let warMachine: Artifact.ID
    let primaryResource: Resource.Kind?
    let creatureBackground: String
}

extension Resource.Kind: Codable {}
//extension Resource: Codable {}
//extension Resources: Codable {}
extension Building.ID.Common: Codable {}
extension Creature.ID: Codable {}
extension Artifact.ID: Codable {}

extension TownTemplate where BuildingKind == Building.ID.Castle {
    static var castle: TownTemplate<Building.ID.Castle> {
        return TownTemplate<Building.ID.Castle>(
            buildings: [
                .mageGuildLevel1: .init(
                    location: .init(x: 707, y: 166),
                    gfx: .init(
                        animation: "TBCSMAGE.def",
                        border: "TOCSMAG1.pcx",
                        area: "TZCSMAG1.pcx"
                    )
                ),
                
                    .mageGuildLevel2: .init(
                        location: .init(x: 706, y: 135),
                        gfx: .init(
                            animation: "TBCSMAG2.def",
                            border: "TOCSMAG2.pcx",
                            area: "TZCSMAG2.pcx"
                        )
                    ),
                
                    .mageGuildLevel3: .init(
                        location: .init(x: 704, y: 107),
                        gfx: .init(
                            animation: "TBCSMAG3.def",
                            border: "TOCSM301.pcx",
                            area: "TZCSM301.pcx"
                        )
                    ),
                
                    .mageGuildLevel4: .init(
                        location: .init(x: 704, y: 76),
                        gfx: .init(
                            animation: "TBCSMAG4.def",
                            border: "TOCSM401.pcx",
                            area: "TZCSM401.pcx"
                        )
                    ),
                
                    .tavern: .init(
                        location: .init(x: 0, y: 230),
                        gfx: .init(
                            animation: "TBCSTVRN.def",
                            border: "TOCSTAV1.pcx",
                            area: "TZCSTAV1.pcx"
                        )
                    ),
                
                    .shipyard: .init(
                        location: .init(x: 478, y: 134, z: 0),
                        gfx: .init(
                            animation: "TBCSDOCK.def",
                            border: "TOCSDKMS.pcx",
                            area: "TZCSDKMS.pcx",
                            animated: false
                        )
                    ),
                
                    .ship: .init(
                        location: .init(x: 478, y: 134, z: 0),
                        gfx: .init(
                            animation: "TBCSBOAT.def",
                            border: "TOCSDKMN.pcx",
                            area: "TZCSDKMN.pcx",
                            animated: false
                        ),
                        upgrades: .shipyard
                    ),
                
                    .fort: .init(
                        location: .init(x: 595, y: 66, z: 0),
                        gfx: .init(
                            animation: "TBCSCSTL.def",
                            border: "TOCSCAS1.pcx",
                            area: "TZCSCAS1.pcx"
                        )
                    ),
                
                    .citadel: .init(
                        location: .init(x: 478, y: 66, z: 0),
                        gfx: .init(
                            animation: "TBCSCAS2.def",
                            border: "TOCSCAS2.pcx",
                            area: "TZCSCAS2.pcx"
                        ),
                        upgrades: .fort
                    ),
                
                    .castle: .init(
                        location: .init(x: 478, y: 37, z: 0),
                        gfx: .init(
                            animation: "TBCSCAS3.def",
                            border: "TOCSCAS3.pcx",
                            area: "TZCSCAS3.pcx"
                        ),
                        upgrades: .citadel
                    ),
                
                    .villageHall: .init(
                        location: .init(x: 0, y: 209, z: 0),
                        gfx: .init(
                            animation: "TBCSHALL.def",
                            border: "TOCSH101.pcx",
                            area: "TZCSH101.pcx"
                        ),
                        produce: [Resource.Kind.gold: 500]
                    ),
                
                    .townHall: .init(
                        location: .init(x: 0, y: 176, z: 0),
                        gfx: .init(
                            animation: "TBCSHAL2.def",
                            border: "TOCSH201.pcx",
                            area: "TZCSH201.pcx"
                        ),
                        upgrades: .villageHall,
                        requires: [.tavern],
                        produce: [Resource.Kind.gold: 1000]
                    ),
                
                    .cityHall: .init(
                        location: .init(x: 0, y: 164, z: 0),
                        gfx: .init(
                            animation: "TBCSHAL3.def",
                            border: "TOCSH301.pcx",
                            area: "TZCSH301.pcx"
                        ),
                        upgrades: .townHall,
                        requires: [
                            .mageGuildLevel1,
                            .marketplace,
                            .blacksmith
                        ],
                        produce: [Resource.Kind.gold: 2000]
                    ),
                
                    .capitol: .init(
                        location: .init(x: 0, y: 154, z: 0),
                        gfx: .init(
                            animation: "TBCSHAL4.def",
                            border: "TOCSH401.pcx",
                            area: "TZCSH401.pcx"
                        ),
                        upgrades: .cityHall,
                        requires: [
                            .castle
                        ],
                        produce: [Resource.Kind.gold: 4000]
                    ),
                
                    .marketplace: .init(
                        location: .init(x: 413, y: 264, z: 0),
                        gfx: .init(
                            animation: "TBCSMARK.def",
                            border: "TOCSMRK1.pcx",
                            area: "TZCSMRK1.pcx"
                        )
                    ),
                
                    .resourceSilo: .init(
                        location: .init(x: 488, y: 228, z: 0),
                        gfx: .init(
                            animation: "TBCSSILO.def",
                            border: "TOCSMRK2.pcx",
                            area: "TZCSMRK2.pcx"
                        ),
                        requires: [.marketplace],
                        produce: [Resource.Kind.ore: 1, .wood: 1]
                    ),
                
                    .blacksmith: .init(
                        location: .init(x: 213, y: 251, z: 0),
                        gfx: .init(
                            animation: "TBCSBLAK.def",
                            border: "TOCSBLAK.pcx",
                            area: "TZCSBLAK.pcx"
                        )
                    ),
                
                    .lighthouse: .init(
                        location: .init(x: 553, y: 71, z: 0),
                        gfx: .init(
                            animation: "TBCSSPEC.def",
                            border: "TOCSLT01.pcx",
                            area: "TZCSLT01.pcx"
                        ),
                        requires: [.shipyard]
                    ),
                
                    .griffinBastion(isUpgraded: false): .init(
                        location: .init(x: 76, y: 53, z: -1),
                        gfx: .init(
                            animation: "TBCSHRD1.def",
                            border: "TOCSGR1H.pcx",
                            area: "TZCSGR1H.pcx"
                        ),
                        requires: [.griffinTower(isUpgraded: false)]
                    ),
                
                    .griffinBastion(isUpgraded: true): .init(
                        location: .init(x: 76, y: 35, z: -1),
                        gfx: .init(
                            animation: "TBCSHRD2.def",
                            border: "TOCSGR2H.pcx",
                            area: "TZCSGR2H.pcx"
                        ),
                        requires: [
                            .griffinTower(isUpgraded: true)
                        ]
                    ),
                
                    .stables: .init(
                        location: .init(x: 384, y: 193, z: -2),
                        gfx: .init(
                            animation: "TBCSEXT0.def",
                            border: "TOCSCAVM.pcx",
                            area: "TZCSCAVM.pcx"
                        ),
                        requires: [.barracks(isUpgraded: false)]
                    ),
                
                    .brotherhoodOfSword: .init(
                        location: .init(x: 0, y: 198, z: 1),
                        gfx: .init(
                            animation: "TBCSEXT1.def",
                            border: "TOCSTAV2.pcx",
                            area: "TZCSTAV2.pcx"
                        ),
                        requires: [.tavern]
                    ),
                
                    .colossus: .init(
                        location: .init(x: 456, y: 109, z: -1),
                        gfx: .init(
                            animation: "TBCSHOLY.def",
                            border: "TOCSHOLY.pcx",
                            area: "TZCSHOLY.pcx"
                        ),
                        produce: [.gold: 5000]
                    ),
                
                    .guardhouse(isUpgraded: false): .init(
                        location: .init(x: 304, y: 92, z: 0),
                        gfx: .init(
                            animation: "TBCSDW_0.def",
                            border: "TOCSPIK1.pcx",
                            area: "TZCSPIK1.pcx"
                        ),
                        requires: [.fort]
                    ),
                
                    .guardhouse(isUpgraded: true): .init(
                        location: .init(x: 304, y: 65, z: 0),
                        gfx: .init(
                            animation: "TBCSUP_0.def",
                            border: "TOCSPIK2.pcx",
                            area: "TZCSPIK2.pcx"
                        ),
                        upgrades: .guardhouse(isUpgraded: false)
                    ),
                
                    .archersTower(isUpgraded: false): .init(
                        location: .init(x: 360, y: 130, z: 0),
                        gfx: .init(
                            animation: "TBCSDW_1.def",
                            border: "TOCSCRS1.pcx",
                            area: "TZCSCRS1.pcx"
                        ),
                        requires: [.guardhouse(isUpgraded: false)]
                    ),
                
                    .archersTower(isUpgraded: true): .init(
                        location: .init(x: 360, y: 115, z: 0),
                        gfx: .init(
                            animation: "TBCSUP_1.def",
                            border: "TOCSCRS2.pcx",
                            area: "TZCSCRS2.pcx"
                        ),
                        upgrades: .archersTower(isUpgraded: false)
                    ),
                
                    .griffinTower(isUpgraded: false): .init(
                        location: .init(x: 76, y: 57, z: -1),
                        gfx: .init(
                            animation: "TBCSDW_2.def",
                            border: "TOCSGR1N.pcx",
                            area: "TZCSGR1N.pcx"
                        ),
                        requires: [.barracks(isUpgraded: false)] /* YES Griffin Tower requires Barracks! https://heroes.thelazy.net/index.php/Castle */
                    ),
                
                    .griffinTower(isUpgraded: true): .init(
                        location: .init(x: 76, y: 35, z: -1),
                        gfx: .init(
                            animation: "TBCSUP_2.def",
                            border: "TOCSGR2N.pcx",
                            area: "TZCSGR2N.pcx"
                        ),
                        upgrades: .griffinTower(isUpgraded: false)
                    ),
                
                    .barracks(isUpgraded: false): .init(
                        location: .init(x: 176, y: 101, z: 0),
                        gfx: .init(
                            animation: "TBCSDW_3.def",
                            border: "TOCSSWD1.pcx",
                            area: "TZCSSWD1.pcx"
                        ),
                        requires: [.guardhouse(isUpgraded: false), .blacksmith]
                    ),
                
                    .barracks(isUpgraded: true): .init(
                        location: .init(x: 176, y: 101, z: 0),
                        gfx: .init(
                            animation: "TBCSUP_3.def",
                            border: "TOCSSWD2.pcx",
                            area: "TZCSSWD2.pcx"
                        ),
                        upgrades: .barracks(isUpgraded: false)
                    ),
                
                    .monastery(isUpgraded: false): .init(
                        location: .init(x: 563, y: 211, z: 1),
                        gfx: .init(
                            animation: "TBCSDW_4.def",
                            border: "TOCSMON1.pcx",
                            area: "TZCSMON1.pcx"
                        ),
                        requires: [.barracks(isUpgraded: false), .mageGuildLevel1]
                    ),
                
                    .monastery(isUpgraded: true): .init(
                        location: .init(x: 563, y: 173, z: 1),
                        gfx: .init(
                            animation: "TBCSUP_4.def",
                            border: "TOCSMON2.pcx",
                            area: "TZCSMON2.pcx"
                        ),
                        upgrades: .monastery(isUpgraded: false)
                    ),
                
                    .trainingGrounds(isUpgraded: false): .init(
                        location: .init(x: 174, y: 190, z: -1),
                        gfx: .init(
                            animation: "TBCSDW_5.def",
                            border: "TOCSC101.pcx",
                            area: "TZCSCAV1.pcx"
                        ),
                        requires: [.stables]
                    ),
                
                    .trainingGrounds(isUpgraded: true): .init(
                        location: .init(x: 160, y: 190, z: -1),
                        gfx: .init(
                            animation: "TBCSUP_5.def",
                            border: "TOCSCAV2.pcx",
                            area: "TZCSCAV2.pcx"
                        ),
                        upgrades: .trainingGrounds(isUpgraded: false)
                    ),
                
                    .portalOfGlory(isUpgraded: false): .init(
                        location: .init(x: 303, y: 0, z: -1),
                        gfx: .init(
                            animation: "TBCSDW_6.def",
                            border: "TOCSANG1.pcx",
                            area: "TZCSANG1.pcx"
                        ),
                        requires: [.monastery(isUpgraded: false)]
                    ),
                
                    .portalOfGlory(isUpgraded: true): .init(
                        location: .init(x: 303, y: 0, z: -1),
                        gfx: .init(
                            animation: "TBCSUP_6.def",
                            border: "TOCSANG2.pcx",
                            area: "TZCSANG2.pcx"
                        ),
                        upgrades: .portalOfGlory(isUpgraded: false)
                    ),
                
            ],
            
            animations: [.init(location: .init(x: 46, y: 119, z: 0), gfx: "TBCSEXT2.def")],
            extras: [:],
            musicTheme: "music/CstleTown",
            townBackground: "TBCSBACK.pcx",
            guildBackground: "TPMAGE.pcx",
            guildWindow: "TPMAGECS.pcx",
            buildingsIcons: "HALLCSTL.DEF",
            hallBackground: "TPTHBKCS.pcx",
            hallSlots: [
                [
                    [.villageHall, .townHall, .cityHall, .capitol],
                    [.fort, .citadel, .castle],
                    [.tavern, .brotherhoodOfSword]
                ],
                [
                    [.marketplace, .resourceSilo],
                    [.mageGuildLevel1, .mageGuildLevel2, .mageGuildLevel3, .mageGuildLevel4],
                    [.shipyard, .lighthouse]
                ],
                [
                    [.stables, .griffinBastion(isUpgraded: false)]
                ],
                [
                    [.guardhouse(isUpgraded: false), .guardhouse(isUpgraded: true)],
                    [.archersTower(isUpgraded: false), .archersTower(isUpgraded: true)],
                    [.griffinTower(isUpgraded: false), .griffinTower(isUpgraded: true)],
                    [.barracks(isUpgraded: false), .barracks(isUpgraded: true)]
                ],
                [
                    [.monastery(isUpgraded: false), .monastery(isUpgraded: true)],
                    [.trainingGrounds(isUpgraded: false), .trainingGrounds(isUpgraded: true)],
                    [.portalOfGlory(isUpgraded: false), .portalOfGlory(isUpgraded: true)]
                ]
            ],
            
            creatures: [
                .init(nonUpgraded: .pikeman, upgraded: .halberdier),
                .init(nonUpgraded: .archer, upgraded: .marksman),
                .init(nonUpgraded: .griffin, upgraded: .royalGriffin),
                .init(nonUpgraded: .swordsman, upgraded: .crusader),
                .init(nonUpgraded: .monk, upgraded: .zealot),
                .init(nonUpgraded: .cavalier, upgraded: .champion),
                .init(nonUpgraded: .angel, upgraded: .archangel)
            ],
            
            warMachine: .ballista,
            primaryResource: nil,
            creatureBackground: "CRBKGCAS.pcx"
        )
    }
}
