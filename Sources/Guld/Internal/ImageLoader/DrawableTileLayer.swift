//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-29.
//

import Foundation
import Malm
import Util

public protocol DrawableLayer: DefinitionFileFrameIndexing, Flippable, RenderZAxisIndexing, Hashable {
    associatedtype DefinitionFileNameKey: Hashable
    static var definitionFileNameTable: [DefinitionFileNameKey: String] { get }
    var definitionFileNameKey: DefinitionFileNameKey { get }
    var definitionFileName: String { get }
    
    /// Some Info about which def files can be found in which lodfiles: http://heroescommunity.com/viewthread.php3?TID=33205&PID=872844#focus
    var archive: Archive { get }
}


public extension DrawableLayer {
    var definitionFileName: String {
        guard let fileName = Self.definitionFileNameTable[definitionFileNameKey] else {
            incorrectImplementation(reason: "Should always be able to find definition file for key: '\(definitionFileNameKey)', but found none.")
        }
        return fileName
    }
    var archive: Archive {
        .lod(.restorationOfErathiaSpriteArchive)
    }
}

public typealias DrawableTileLayer = DrawableLayer & TileLayer



extension Map.Tile.Ground: DrawableLayer {}
public extension Map.Tile.Ground {
    typealias DefinitionFileNameKey = Map.Terrain
    var definitionFileNameKey: DefinitionFileNameKey { self.terrain }
    static let definitionFileNameTable: [DefinitionFileNameKey: String] = [
        .dirt:  "DIRTTL.def",
        .sand: "SANDTL.def",
        .grass: "GRASTL.def",
        .snow: "SNOWTL.def",
        .swamp: "SWMPTL.def",
        .rough: "ROUGTL.def",
        .subterranean: "SUBBTL.def",
        .lava: "LAVATL.def",
        .water: "WATRTL.def",
        .rock: "ROCKTL.def"
    ]
}

extension Map.Tile.Road: DrawableLayer {}
public extension Map.Tile.Road {
    typealias DefinitionFileNameKey = Self.Kind
    var definitionFileNameKey: DefinitionFileNameKey { self.kind }
    static let definitionFileNameTable: [DefinitionFileNameKey: String] = [
        .dirt: "dirtrd.def",
        .gravel: "gravrd.def",
        .cobbelStone: "cobbrd.def",
    ]
}

extension Map.Tile.River: DrawableLayer {}
public extension Map.Tile.River {
    typealias DefinitionFileNameKey = Self.Kind
    var definitionFileNameKey: DefinitionFileNameKey { self.kind }
    static let definitionFileNameTable: [DefinitionFileNameKey: String] = [
        .clear: "Clrrvr.def",
        .icy: "Icyrvr.def",
        .muddy: "Mudrvr.def",
        .lava: "Lavrvr.def",
    ]
}
