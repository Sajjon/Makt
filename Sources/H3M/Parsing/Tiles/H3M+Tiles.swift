//
//  Map+Loader+Parser+H3M+Tiles.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation
import Malm

fileprivate enum ExtraTileFlags: UInt8, CaseIterable {
    case terrainVertical
    case terrainHorizontal
    case riverVertical
    case riverHorizontal
    case roadVertical
    case roadHorizontal
    case isCoastal
    case hasFavorableWinds
}


// MARK: Parse World/Tiles/Terrain
internal extension H3M {
    func parseTerrain(hasUnderworld: Bool, size: Size) throws -> Map.World {
        
        func parseTiles(inUnderworld: Bool) throws -> [Map.Tile] {
            var tiles = [Map.Tile]()
            for rowIndex in 0..<size.height {
                for columnIndex in 0..<size.width {
                    
                    let position = Position(column: .init(columnIndex), row: .init(rowIndex), inUnderworld: inUnderworld)
                    
                    let terrainKindRaw = try reader.readUInt8()
                    guard let terrainKind = Map.Tile.Terrain.Kind(rawValue: terrainKindRaw) else {
                        throw H3MError.unrecognizedTerrainKind(terrainKindRaw)
                    }
                    let terrainView = try reader.readUInt8()
                    let riverKindRaw = try reader.readUInt8()
                    let riverKind: Map.Tile.River.Kind? = .init(rawValue: riverKindRaw)

                    /// Always read the river flow direction byte even though this tile might not have a river on it. Otherwise we mess up byte offset.
                    let riverDirection = try Map.Tile.River.Direction(reader.readUInt8())
                    
                    let roadKindRaw = try reader.readUInt8()
                    let roadKind: Map.Tile.Road.Kind? = .init(rawValue: roadKindRaw)
                    /// Always read the road direction byte even though this tile might not have a road on it. Otherwise we mess up byte offset.
                    let roadDirection = try Map.Tile.Road.Direction(reader.readUInt8())
                    
                    let flags: [ExtraTileFlags] = try parseBitmaskOfEnum()
                    
                    let tile = Map.Tile(
                        position: position,
                        terrain: .init(
                            kind: terrainKind,
                            mirroring: .init(
                                flipVertical: flags.contains(.terrainVertical),
                                flipHorizontal: flags.contains(.terrainHorizontal)
                            ),
                            viewID: terrainView
                        ),
                        
                        river: riverKind.map {
                            Map.Tile.River(
                                kind: $0,
                                direction: riverDirection,
                                mirroring: .init(
                                    flipVertical: flags.contains(.riverVertical),
                                    flipHorizontal: flags.contains(.riverHorizontal)
                                )
                            )
                        },
                        
                        road: roadKind.map {
                            Map.Tile.Road(
                                kind: $0,
                                direction: roadDirection,
                                mirroring: .init(
                                    flipVertical: flags.contains(.roadVertical),
                                    flipHorizontal: flags.contains(.roadHorizontal)
                                )
                            )
                        },
                        
                        isCoastal: flags.contains(.isCoastal),
                        hasFavourableWindEffect: flags.contains(.hasFavorableWinds)
                    )
                    
                    tiles.append(tile)
                }
            }

            return tiles
        }
        
        // Parse above ground (NOT underworld)
        let aboveGround: Map.Level = try {
            let inUnderworld = false
            let tiles = try parseTiles(inUnderworld: inUnderworld)
            return .init(tiles: tiles, isUnderworld: inUnderworld)
        }()
        
        // If has underworld => parse it
        let underworld: Map.Level? = try hasUnderworld ? {
            let tiles = try parseTiles(inUnderworld: true)
            return .init(tiles: tiles, isUnderworld: true)
        }() : nil
        
        return .init(above: aboveGround, underground: underworld)
    }
}
