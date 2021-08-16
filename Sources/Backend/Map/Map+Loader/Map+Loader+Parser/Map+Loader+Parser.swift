//
//  Map+Loader+Parser.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public extension Map.Loader {
    final class Parser {
        private let config: Config
        init(config: Config) {
            self.config = config
        }
    }
}

import Gzip

public extension Map.Loader.Parser {
    func parse(readMap: Map.Loader.ReadMap) throws -> Map {
     
        let zipEntryMagicNumberFileStart: UInt32 = 0x04034b50
        let zipEntryMagicNumberDirectoryStart: UInt32 = 0x02014b50
        let zipEntryMagicNumberDirectoryEnd: UInt32 = 0x06054b50
        
        let stream = DataReader(readMap: readMap)
        
        let header = try stream.readUInt32()
        // VCMI comment: Check for ZIP magic. Zip files are VCMI maps
        switch header {
        case zipEntryMagicNumberFileStart: fallthrough
        case zipEntryMagicNumberDirectoryStart: fallthrough
        case zipEntryMagicNumberDirectoryEnd:
            fatalError("Zip files used by VCMI is not supported.")
        default:
            let formatRawValue = header & 0xffffff
            guard let format = Map.Format(rawValue: formatRawValue) else {
                fatalError("Unsupported map format: \(formatRawValue)")
            }
            switch format {
            // gzip header magic number, reversed for LE
            case .gzip:
                
                
//                let compressedData = NSData(data: readMap.data)
//                do {
//                    let decompressedNSData = try compressedData.decompressed(using: .zlib)
//                    let decompressedData = Data(decompressedNSData) // TODO optimization this copies all data, might be slow?
//                    return try H3M(readMap: Map.Loader.ReadMap.init(data: decompressedData, filePath: readMap.filePath, id: readMap.id)).parse()
//                } catch {
//                    fatalError("Failed to decompress data using ZLib...error: \(error)")
//                }
            

              
                // gunzip
                guard readMap.data.isGzipped else { fatalError("Gzip library does not think this data is gzipped") }
                let decompressedData = try! readMap.data.gunzipped()
                return try H3M(
                    readMap: Map.Loader.ReadMap(data: decompressedData, filePath: readMap.filePath, id: readMap.id),
                    fileSizeCompressed: readMap.data.count
                ).parse()
                
            // Original game
            case .wakeOGods, .armageddonsBlade, .restorationOfErathia,.shadowOfDeath:
                //                return std::unique_ptr<IMapLoader>(new CMapLoaderH3M(stream.get()));
                return try H3M(readMap: readMap, fileSizeCompressed: nil).parse()
            default: fatalError("Unsupported/unhandled format: \(format)")
            }
            
        }
    }
}



public extension Map {
    struct TriggeredEvent: Equatable {}
}
public extension Map {
    struct TeamInfo: Equatable {
        public let teams: [Team]
        public struct Team: Equatable {
            public let id: Int
        }
    }
}

public enum PlayerColor: String, Equatable, CaseIterable {
    case red, blue, tan, green, orange, purple, teal, pink
}

public enum Difficulty: Int8, Equatable {
    case easy, normal, hard, expert, impossible
}

public enum AITactic: Int, Equatable {
    case random, warrior, builder, explorer
}

public enum Faction: Int, Equatable, CaseIterable {
    case castle, rampart, tower, inferno, necropolis, dungeon, stronghold, fortress, conflux, neutral
}

public extension Map {
    struct PlayersInfo: Equatable {
        public let players: [PlayerInfo]
        public struct PlayerInfo: Equatable {
            public let color: PlayerColor
            public let isPlayableByHuman: Bool
            public let aiTactic: AITactic?
            
            public let allowedFactionsForThisPlayer: [Faction]
            public let isRandomFaction: Bool
            
            public let generateHero: Bool
            public let mainTown: MainTown?
            public let hasRandomHero: Bool
            public let customMainHero: Hero.Custom?
            public let heroSeeds: [Hero.Seed]?
            
            public struct MainTown: Equatable {
                let position: Position
                let generateHeroInThisTown: Bool
            }
        }
        
    }
}

public extension Map.PlayersInfo.PlayerInfo {
    var isPlayableByAI: Bool { aiTactic != nil }
    var hasMainTown: Bool { mainTown != nil }
}

/// Position on adventure map, three dimensions (x, y, z)
public struct Position: Equatable {
    public typealias Scalar = Int32
    public let x: Scalar
    public let y: Scalar
    public let z: Scalar
}

public struct Hero: Equatable, Identifiable {
    public let id: ID
}
public extension Hero {
    struct ID: Hashable {
        public let id: Int
    }
    
    struct Portrait: Equatable, Identifiable {
        public let id: ID
    }
}
public extension Hero.Portrait {
    struct ID: Hashable {
        public let id: Int
    }
}

public extension Hero {
    struct Custom: Equatable {
        let id: Hero.ID
        let portraitId: Hero.Portrait.ID
        let name: String
    }
    
    struct Seed: Equatable {
        let id: Hero.ID
        let name: String
    }

}
