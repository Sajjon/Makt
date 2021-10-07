//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-06.
//

import Foundation
import ArgumentParser

import Util
import Malm
import Guld

// MARK: Textures
extension Laka {
    
    /// A command to extract all textures, such as terrain, monsters, artifacts,
    /// heroes and towns on the map etc. But not game menu UI, neither
    /// in combat/battle creature sprites nor in town UI.
    struct Textures: ParsableCommand, TextureGenerating {
        
        static var configuration = CommandConfiguration(
            abstract: "Extract texture images such as terrain, artifacts, monsters etc. But not game menu UI."
        )
        
        @OptionGroup var parentOptions: Options
        
    }
}

// MARK: Run
extension Laka.Textures {
    
    mutating func run() throws {
        print(
            """
            
            🔮
            About to extract textures from entries exported by the `Laka LOD` command.
            Located at: \(inDataURL.path)
            To folder: \(outImagesURL.path)
            This will take about 30 seconds on a fast machine (Macbook Pro 2019 - Intel CPU)
            ☕️
            
            """
        )
        try exportTerrain()
        try exportTowns()
        try exportMonsters()
    }
}


// MARK: Computed props
extension Laka.Textures {
    
    var verbose: Bool { parentOptions.printDebugInformation }
    
    var fileManager: FileManager { .default }
    
    var inDataURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath).appendingPathComponent("entries")
    }
    
    var outImagesURL: URL {
        .init(fileURLWithPath: parentOptions.outputPath).appendingPathComponent("images")
    }
}

// MARK: - TERRAIN
// MARK: -
private extension Laka.Textures {
    func exportTerrain() throws {
        let roadFiles = Map.Tile.Road.Kind.listOfFilesToExport
        let groundFiles = Map.Terrain.listOfFilesToExport
        let riverFiles = Map.Tile.River.Kind.listOfFilesToExport
        
        try generateTexture(
            name: "terrain",
            list: roadFiles + riverFiles + groundFiles
        )
    }
}

// MARK: Ground Files
extension Map.Terrain: PNGExportable {
    static var namePrefix: String { "ground" }
    var defFileName: String {
        switch self {
        case .dirt: return "dirttl.def"
        case .sand: return "sandtl.def"
        case .grass: return "grastl.def"
        case .snow: return "snowtl.def"
        case .swamp: return "swmptl.def"
        case .rough: return "rougtl.def"
        case .subterranean: return "subbtl.def"
        case .lava: return "lavatl.def"
        case .water: return "watrtl.def"
        case .rock: return "rocktl.def"
        }
    }
}

// MARK: River Files
extension Map.Tile.River.Kind: PNGExportable {
    static var namePrefix: String { "river" }
    var defFileName: String {
        switch self {
        case .clear: return "clrrvr.def"
        case .icy: return "icyrvr.def"
        case .muddy: return "mudrvr.def"
        case .lava: return "lavrvr.def"
        }
    }
}

// MARK: Road + Files
extension Map.Tile.Road.Kind: PNGExportable {
    static var namePrefix: String { "road" }
    var defFileName: String {
        switch self {
        case .dirt: return "dirtrd.def"
        case .gravel: return "gravrd.def"
        case .cobbelStone: return "cobbrd.def"
        }
    }
}

// MARK: - TOWNS
// MARK: -
private extension Laka.Textures {
    
    // MARK: Town + Files
    var townDefFiles: [String] {
        [
            "avccasx0.def",
            "avccast0.def",
            "avccasz0.def",
            "avchforx.def",
            "avchfor0.def",
            "avchforz.def",
            "avcdunx0.def",
            "avcdung0.def",
            "avcdunz0.def",
            "avcftrx0.def",
            "avcftrt0.def",
            "avcforz0.def",
            "avcinfx0.def",
            "avcinft0.def",
            "avcinfz0.def",
            "avcnecx0.def",
            "avcnecr0.def",
            "avcnecz0.def",
            "avcramx0.def",
            "avcramp0.def",
            "avcramz0.def",
            "avcranx0.def",
            "avcrand0.def",
            "avcranz0.def",
            "avcstrx0.def",
            "avcstro0.def",
            "avcstrz0.def",
            "avctowx0.def",
            "avctowr0.def",
            "avctowz0.def"
        ]
    }
    
    func exportTowns() throws {
        let townFiles: [ImageExport] = townDefFiles.map { defFileName in
            ImageExport(defFileName: defFileName, nameFromFrameIndex: { _ in defFileName })
        }
        try generateTexture(
            name: "towns",
            list: townFiles
        )
    }
}

// MARK: - Monsters
// MARK: -
extension Laka.Textures {
    var monsters: [String] { [
        "avwpike.def",
        "avwpikx0.def",
        "avwlcrs.def",
        "avwhcrs.def",
        "avwgrif.def",
        "avwgrix0.def",
        "avwswrd0.def",
        "avwswrx0.def",
        "avwmonk.def",
        "avwmonx0.def",
        "avwcvlr0.def",
        "avwcvlx0.def",
        "avwangl.def",
        "avwarch.def",
        "avwcent0.def",
        "avwcenx0.def",
        "avwdwrf0.def",
        "avwdwrx0.def",
        "avwelfw0.def",
        "avwelfx0.def",
        "avwpega0.def",
        "avwpegx0.def",
        "avwtree0.def",
        "avwtrex0.def",
        "avwunic0.def",
        "avwunix0.def",
        "avwdrag0.def",
        "avwdrax0.def",
        "avwgrem0.def",
        "avwgrex0.def",
        "avwgarg0.def",
        "avwgarx0.def",
        "avwgolm0.def",
        "avwgolx0.def",
        "avwmage0.def",
        "avwmagx0.def",
        "avwgeni0.def",
        "avwgenx0.def",
        "avwnaga0.def",
        "avwnagx0.def",
        "avwtitn0.def",
        "avwtitx0.def",
        "avwimp0.def",
        "avwimpx0.def",
        "avwgog0.def",
        "avwgogx0.def",
        "avwhoun0.def",
        "avwhoux0.def",
        "avwdemn0.def",
        "avwdemx0.def",
        "avwpitf0.def",
        "avwpitx0.def",
        "avwefre0.def",
        "avwefrx0.def",
        "avwdevl0.def",
        "avwdevx0.def",
        "avwskel0.def",
        "avwskex0.def",
        "avwzomb0.def",
        "avwzomx0.def",
        "avwwigh.def",
        "avwwigx0.def",
        "avwvamp0.def",
        "avwvamx0.def",
        "avwlich0.def",
        "avwlicx0.def",
        "avwbkni0.def",
        "avwbknx0.def",
        "avwbone0.def",
        "avwbonx0.def",
        "avwtrog0.def",
        "avwinfr.def",
        "avwharp0.def",
        "avwharx0.def",
        "avwbehl0.def",
        "avwbehx0.def",
        "avwmeds.def",
        "avwmedx0.def",
        "avwmino.def",
        "avwminx0.def",
        "avwmant0.def",
        "avwmanx0.def",
        "avwrdrg.def",
        "avwddrx0.def",
        "avwgobl0.def",
        "avwgobx0.def",
        "avwwolf0.def",
        "avwwolx0.def",
        "avworc0.def",
        "avworcx0.def",
        "avwogre0.def",
        "avwogrx0.def",
        "avwroc0.def",
        "avwrocx0.def",
        "avwcycl0.def",
        "avwcycx0.def",
        "avwbhmt0.def",
        "avwbhmx0.def",
        "avwgnll0.def",
        "avwgnlx0.def",
        "avwlizr.def",
        "avwlizx0.def",
        "avwdfly.def",
        "avwdfir.def",
        "avwbasl.def",
        "avwgbas.def",
        "avwgorg.def",
        "avwgorx0.def",
        "avwwyvr.def",
        "avwwyvx0.def",
        "avwhydr.def",
        "avwhydx0.def",
        "avwpixie.def",
        "avwsprit.def",
        "avwelmw0.def",
        "avwicee.def",
        "avwelme0.def",
        "avwstone.def",
        "avwelma0.def",
        "avwstorm.def",
        "avwelmf0.def",
        "avwnrg.def",
        "avwpsye.def",
        "avwmagel.def",
        "avwfbird.def",
        "avwphx.def",
        "avwglmg0.def",
        "avwglmd0.def",
        "avwazure.def",
        "avwcdrg.def",
        "avwfdrg.def",
        "avwrust.def",
        "avwench.def",
        "avwsharp.def",
        "avwhalf.def",
        "avwpeas.def",
        "avwboar.def",
        "avwmumy.def",
        "avwnomd.def",
        "avwrog.def",
        "avwtrll.def",
        "avwmrnd0.def",
        "avwmon1.def",
        "avwmon2.def",
        "avwmon3.def",
        "avwmon4.def",
        "avwmon5.def",
        "avwmon6.def",
        "avwmon7.def"
    ]
    }
    
    func exportMonsters() throws {
        let monsterFiles: [ImageExport] = monsters.map { defFileName in
            ImageExport(defFileName: defFileName, nameFromFrameIndex: { _ in defFileName })
        }
        try generateTexture(
            name: "monsters",
            list: monsterFiles,
            limit: 1
        )
    }
}
