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
