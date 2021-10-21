//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-11.
//

import Foundation
import Malm



// MARK: - TERRAIN
// MARK: -
internal extension Laka.Textures {

    static let terrainTask = Task(
        atlasName: "terrain",
        defFileList: Map.Tile.Road.Kind.listOfFilesToExport + Map.Tile.River.Kind.listOfFilesToExport + Map.Terrain.listOfFilesToExport
    )
    
//    private var defFiles: [DefImageExport] {
//        let roadFiles = Map.Tile.Road.Kind.listOfFilesToExport
//        let groundFiles = Map.Terrain.listOfFilesToExport
//        let riverFiles = Map.Tile.River.Kind.listOfFilesToExport
//
//        return roadFiles + riverFiles + groundFiles
//    }
//
//    var terrainDefsCount: Int {
//        defFiles.count
//    }
//
//    func exportTerrain() throws {
//        try generateTexture(
//            name: "terrain",
//            list: defFiles.map { .def($0) },
////            didCalculateWorkLoad: { self.report(numberOfEntriesToExtract: $0) },
//            finishedExportingOneEntry: self.finishedExtractingEntry
//        )
//    }
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
