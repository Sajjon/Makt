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
    

    /// A "well known"/standardized unique header number idenitfying a file as a "gzip" file.
    ///
    /// Source1: https://github.com/vcmi/vcmi/blob/develop/lib/mapping/CMapService.cpp#L105
    /// Source2: https://github.com/brgl/busybox/blob/master/archival/gzip.c#L2081
    /// Source3: https://stackoverflow.com/a/33378248/1311272
    /// Source4: https://zenhax.com/viewtopic.php?p=62470#p62470
    private static let gzipped: UInt32 = 0x00088b1f
    
    func parse(readMap: Map.Loader.ReadMap) throws -> Map {
        let stream = DataReader(readMap: readMap)
        let header = try stream.readUInt32()
        let formatRawValue = header & 0xffffff
        
        if formatRawValue == Map.Loader.Parser.gzipped {
            guard readMap.data.isGzipped else { fatalError("Gzip library does not think this data is gzipped") }
            let decompressedData: Data = try readMap.data.gunzipped()
            let h3mParser = H3M(
                readMap: .init(data: decompressedData, filePath: readMap.filePath, id: readMap.id),
                fileSizeCompressed: readMap.data.count
            )
            return try h3mParser.parse()
        } else {
            guard let format = Map.Format(id: formatRawValue) else {
                throw Error.unrecognizedFormat(formatRawValue)
            }
            
            switch format {
            case .hornOfTheAbyss: fatalError("Unknown if hota is supported")
            case .wakeOfGods, .armageddonsBlade, .restorationOfErathia,.shadowOfDeath:
                let h3mParser = H3M(readMap: readMap)
                return try h3mParser.parse()
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
