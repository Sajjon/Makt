//
//  Map+Loader+Parser+H3M+Tiles.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation


// MARK: Parse Terrain
internal extension Map.Loader.Parser.H3M {
    func parseTerrain(hasUnderworld: Bool, size: Size) throws -> Map.World {
        
        func parseTiles(inUnderworld: Bool) throws -> [Map.Level.Tile] {
            var tiles = [Map.Level.Tile]()
            for columnIndex in 0..<size.width {
                for rowIndex in 0..<size.height {
                    
                    let position = Position(x: .init(columnIndex), y: .init(rowIndex), inUnderworld: inUnderworld)
                    
                    let terrainKindRaw = try reader.readUInt8()
                    guard let terrainKind = Map.Level.Tile.Terrain.Kind(rawValue: terrainKindRaw) else {
                        throw Error.unrecognizedTerrainKind(terrainKindRaw)
                    }
                    let terrainView = try Map.Level.Tile.Terrain.ViewID(view: reader.readUInt8())
                    let riverKindRaw = try reader.readUInt8()
                    let riverKind: Map.Level.Tile.River.Kind? = .init(rawValue: riverKindRaw)

                    /// Always read the river flow direction byte even though this tile might not have a river on it. Otherwise we mess up byte offset.
                    let riverDirectionRaw = try reader.readUInt8()
                    let riverDirection: Map.Level.Tile.Direction? = .init(rawValue: riverDirectionRaw)
                    
                    let roadKindRaw = try reader.readUInt8()
                    let roadKind: Map.Level.Tile.Road.Kind? = .init(rawValue: roadKindRaw)
                    /// Always read the road direction byte even though this tile might not have a road on it. Otherwise we mess up byte offset.
                    let roadDirectionRaw = try reader.readUInt8()
                    let roadDirection: Map.Level.Tile.Direction? = .init(rawValue: roadDirectionRaw)
                    
                    let extraTileFlags = try Map.Level.Tile.ExtraTileFlags(flags: reader.readUInt8())
                    
                    let tile = Map.Level.Tile(
                        position: position,
                        terrain: .init(
                            kind: terrainKind,
                            viewID: terrainView,
                            rotation: extraTileFlags.terrainGraphicRotation
                        ),
                        
                        river: riverKind.map {
                            Map.Level.Tile.River(
                                kind: $0,
                                direction: riverDirection!,
                                rotation: extraTileFlags.riverGraphicRotation
                            )
                        },
                        
                        road: roadKind.map {
                            Map.Level.Tile.Road(
                                kind: $0,
                                direction: roadDirection!,
                                rotation: extraTileFlags.roadGraphicRotation
                            )
                        },
                        
                        isCoastal: extraTileFlags.isCoastal,
                        hasFavourableWindEffect: extraTileFlags.hasFavourableWindEffect
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
            return .init(isUnderworld: inUnderworld, tiles: tiles)
        }()
        
        // If has underworld => parse it
        let underworld: Map.Level? = try !hasUnderworld ? nil : {
            let tiles = try parseTiles(inUnderworld: true)
            return .init(isUnderworld: true, tiles: tiles)
        }()
        
        return .init(above: aboveGround, belowGround: underworld)
    }
}

// MARK: ExtraTileFlags
extension Map.Level.Tile {
    
    /// first two bits - how to rotate terrain graphic (next two - river graphic, next two - road)
    /// 7h bit: whether tile is coastal (allows disembarking if land or block movement if water)
    /// 8th bit: Favorable Winds effect
    fileprivate struct ExtraTileFlags: Equatable {
        
        public let terrainGraphicRotation: Map.Level.Tile.Rotation
        public let riverGraphicRotation: Map.Level.Tile.Rotation
        public let roadGraphicRotation: Map.Level.Tile.Rotation
        
        /// Whether tile is coastal (allows disembarking if land or block movement if water)
        public let isCoastal: Bool
        
        /// If water tile, then we might have greater speed with our boats thanks to favourable winds.
        public let hasFavourableWindEffect: Bool
        
        init(flags: UInt8) {
            let rotationCount = UInt8(Map.Level.Tile.Rotation.allCases.count)
            let terrainGraphicRotationRaw = flags % rotationCount  // read bits at index 0 and 1
            let riverGraphicRotationRaw = (flags >> 2) % rotationCount // read bits at index 2 and 3
            let roadGraphicRotationRaw = (flags >> 4) % rotationCount // read bits at index 4 and 5
            
            self.isCoastal            = (flags & 0b01000000) != 0 // read 7th bit at index 6
            self.hasFavourableWindEffect  = (flags & 0b10000000) != 0 // read 8th bit at index 7
            
            self.terrainGraphicRotation = .init(rawValue: terrainGraphicRotationRaw)!
            self.riverGraphicRotation = .init(rawValue: riverGraphicRotationRaw)!
            self.roadGraphicRotation = .init(rawValue: roadGraphicRotationRaw)!
        }
    }
}