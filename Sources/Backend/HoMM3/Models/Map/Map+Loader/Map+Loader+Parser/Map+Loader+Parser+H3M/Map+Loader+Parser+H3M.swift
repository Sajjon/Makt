//
//  Map+Loader+Parser+H3M.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

// MARK: H3M Parser
public extension Map.Loader.Parser {
    final class H3M {
        internal let readMap: Map.Loader.ReadMap
        internal let reader: DataReader
        internal let fileSizeCompressed: Int?
        public init(readMap: Map.Loader.ReadMap, fileSizeCompressed: Int? = nil) {
            self.readMap = readMap
            self.reader = DataReader(data: readMap.data)
            self.fileSizeCompressed = fileSizeCompressed
        }
    }
}

// MARK: Parse Map
extension Map.Loader.Parser.H3M {
    func parse() throws -> Map {
        
        let checksum = CRC32.checksum(readMap.data)
        
        let about = try parseAbout()
        let format = about.summary.format
        
        let _ = try parseDisposedHeroes(format: format)
        let _ = try parseAllowedArtifacts(format: format)
        let _ = try parseAllowedSpellsAbilities()
        let _ = try parseRumors()
        let _ = try parsePredefinedHeroes()
        let _ = try parseTerrain()
        let _ = try parseDefInfo()
        let _ = try parseObjects()
        let _ = try parseEvents()
        
        return .init(
            checksum: checksum,
            about: about
        )
    }
}


public extension Map {
    struct DefInfo: Equatable {}
}

public struct SpellsAbilities: Equatable {}

public extension Map {
    struct Rumors: Equatable {}
}
public extension Map {
    enum Terrain: Equatable {}
}

public extension Map {
    enum Object: Equatable {}
}

public extension Map {
    struct Event: Equatable {}
}

internal extension Map.Loader.Parser.H3M {
    func parseHeroID() throws -> Hero.ID? {
        try reader.readHeroID {
            Error.unrecognizedHeroID($0)
        }
    }
    func parseHeroPortraitID() throws -> Hero.ID? {
        try parseHeroID()
    }
}

// MARK: Parse Disposed Heros
private extension Map.Loader.Parser.H3M {
    func parseDisposedHeroes(format: Map.Format) throws -> [Hero.Disposed] {
        var disposed = [Hero.Disposed]()
        if format >= .shadowOfDeath {
            disposed = try reader.readUInt8().nTimes {
                let heroID = try parseHeroID()!
                let portraitID = try parseHeroPortraitID()
                let name = try reader.readString()
                
                let availableForPlayers: [PlayerColor] = try BitArray(
                    data: reader.read(byteCount: 1)
                )
                .enumerated()
                .compactMap { (colorIndex, isAvailable) -> PlayerColor? in
                    guard isAvailable else { return nil }
                    return PlayerColor.allCases[colorIndex]
                }
                
                return Hero.Disposed(
                    heroID: heroID,
                    portraitID: portraitID,
                    name: name,
                    availableForPlayers: availableForPlayers
                )
            }
        }
        try reader.skip(byteCount: 31) // skip `nil`s
        return disposed
    }
}

// MARK: Parse Artifacts
private extension Map.Loader.Parser.H3M {
    func parseAllowedArtifacts(format: Map.Format) throws -> [Artifact] {
        if format != .restorationOfErathia {
            
        }
        return []
    }
}

// MARK: Parse Allowed Spells/Abilities
private extension Map.Loader.Parser.H3M {
    func parseAllowedSpellsAbilities() throws -> [SpellsAbilities] {
        []
    }
}

// MARK: Parsed Rumors
private extension Map.Loader.Parser.H3M {
    func parseRumors() throws -> [Map.Rumors] {
        []
    }
}

// MARK: Parse PreDefined Heroes
private extension Map.Loader.Parser.H3M {
    func parsePredefinedHeroes() throws -> [Hero.Predefined] {
        []
    }
}

// MARK: Parse Terrain
private extension Map.Loader.Parser.H3M {
    func parseTerrain() throws -> [Map.Terrain] {
        []
    }
}

// MARK: Parse "Def" info
private extension Map.Loader.Parser.H3M {
    func parseDefInfo() throws -> Map.DefInfo {
        .init()
    }
}

// MARK: Parse Objects
private extension Map.Loader.Parser.H3M {
    func parseObjects() throws -> [Map.Object] {
        []
    }
}

// MARK: Parse Events
private extension Map.Loader.Parser.H3M {
    func parseEvents() throws -> [Map.Event] {
        []
    }
    
}
