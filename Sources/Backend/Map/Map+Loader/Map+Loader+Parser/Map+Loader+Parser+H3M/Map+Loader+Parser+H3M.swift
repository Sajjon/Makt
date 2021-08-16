//
//  Map+Loader+Parser+H3M.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

internal extension Map.Loader.Parser {
    final class H3M {
        private let readMap: Map.Loader.ReadMap
        private let reader: DataReader
        private let fileSizeCompressed: Int?
        public init(readMap: Map.Loader.ReadMap, fileSizeCompressed: Int?) {
            self.readMap = readMap
            self.reader = DataReader(data: readMap.data)
            self.fileSizeCompressed = fileSizeCompressed
        }
    }
}

// MARK: Error
enum Error: Swift.Error {
    case corruptMapFileTooSmall
    case failedToReadHeaderVersion
    case unsupportedHeaderVersion
    case unrecognizedDifficulty(Difficulty.RawValue)
    case unrecognizedAITactic(AITactic.RawValue)
}


extension Map.Loader.Parser.H3M {
    func parse() throws -> Map {
        let about = try parseAboutMap()
        let playerInfo = try parsePlayerInfo(format: about.format)
        let victoryLossConditions = try parseVictoryLossConditions()
        let teamInfo = try parseTeamInfo()
        let allowedHeroes = try parseAllowedHeroes()
        
        
        return .init(
            about: about,
            playersInfo: playerInfo,
            victoryLossConditions: victoryLossConditions,
            teamInfo: teamInfo,
            allowedHeroes: allowedHeroes
        )
    }
}

public struct Size: Equatable {
    public typealias Scalar = Int
    public let width: Scalar
    public let height: Scalar
}
 
// MARK: Parse Map+About
private extension  Map.Loader.Parser.H3M {

    func parseAboutMap() throws -> Map.About {
        // Check map for validity
        guard reader.sourceSize >= 50 else { throw Error.corruptMapFileTooSmall }
        // Map version
        guard let format = try Map.Format(rawValue: reader.readUInt32()) else {
            throw Error.failedToReadHeaderVersion
        }
        
        guard
            format == .restorationOfErathia ||
                format == .armageddonsBlade ||
                format == .shadowOfDeath ||
                format == .wakeOGods
        else {
            throw Error.unsupportedHeaderVersion
        }
        
        let _ = try reader.readBool() /// VCMI variable name `hasPlayablePlayers` but with comment `"unused"`
        let sizeValue = try reader.readUInt32()
        let height = sizeValue
        let width = sizeValue
        let size = Size.init(width: .init(width), height: .init(height))
        let hasTwoLevels = try reader.readBool()
        let name = try reader.readString()
        let description = try reader.readString()
        let difficultyRaw = try reader.readInt8()
        guard let difficulty = Difficulty.init(rawValue: difficultyRaw) else {
            throw Error.unrecognizedDifficulty(difficultyRaw)
        }
        
        let maximumHeroLevel: Int? = try format != .restorationOfErathia ? Int(reader.readUInt8()) : nil
        
        return Map.About(
            id: readMap.id,
            fileSize: readMap.data.count,
            fileSizeCompressed: fileSizeCompressed,
            format: format,
            name: name,
            description: description,
            size: size,
            difficulty: difficulty,
            hasTwoLevels: hasTwoLevels,
            maximumHeroLevel: maximumHeroLevel
        )
    }
}

// MARK: PlayersInfo
private extension  Map.Loader.Parser.H3M {
    
    func parsePlayerInfo(format: Map.Format) throws -> Map.PlayersInfo {
        let players: [Map.PlayersInfo.PlayerInfo] = try PlayerColor.allCases.compactMap { (playerColor: PlayerColor) -> Map.PlayersInfo.PlayerInfo? in
            let isPlayableByHuman = try reader.readBool()
            let isPlayableByAI = try reader.readBool()
            guard isPlayableByAI || isPlayableByHuman else {
                switch format {
                case .shadowOfDeath, .wakeOGods:
                    try reader.skip(byteCount: 13)
                case .armageddonsBlade:
                    try reader.skip(byteCount: 12)
                case .restorationOfErathia:
                    try reader.skip(byteCount: 6)
                default: break // unsure about this
                }
                return nil // unsure about this
            }
            
            /// Unsure about `Int(reader.readUInt8())`, if it ever results in `-1`. In VCMI: `static_cast<EAiTactic::EAiTactic>(reader.readUInt8());` and:
            ///
            /// `enum EAiTactic {
            ///    NONE = -1,
            ///    RANDOM,
            ///    WARRIOR,
            ///    BUILDER,
            ///    EXPLORER
            /// };`
            /// So -1 results in `NONE` which I try to model in swift with code below.
            func readAITacticsIfAny() throws -> AITactic? {
                let aiTacticByte = try reader.readUInt8()
                let aiTacticRaw = Int(aiTacticByte)
                guard aiTacticRaw != -1 else { return nil }
                guard let aiTactic = AITactic(rawValue: aiTacticRaw) else {
                    throw Error.unrecognizedAITactic(aiTacticRaw)
                }
                return aiTactic
            }
            
            let aiTactic: AITactic? = try readAITacticsIfAny()
         
            /// Naming in VCMI: `p7`, with comment `"unknown and unused"`
            let _: Int? = try format == .shadowOfDeath || format == .wakeOGods ? Int(reader.readUInt8()) : nil
            
            // Factions this player can choose
            var allowedFactionsForThisPlayerBitmask = try UInt16(reader.readUInt8())
            var allowedFactionsForThisPlayer = Faction.allCases
            var totalNumberOfFactionsInMap = Faction.allCases.count
            
            if format != .restorationOfErathia {
                allowedFactionsForThisPlayerBitmask += try 256 * UInt16(reader.readUInt8())
            } else {
                totalNumberOfFactionsInMap -= 1 // Exclude `Conflux` from `Restoration Of Erathia`
            }
            
        
            for factionRaw in 0..<totalNumberOfFactionsInMap {
                if allowedFactionsForThisPlayerBitmask & (1 << factionRaw) == 0 {
                    allowedFactionsForThisPlayer.removeAll(where: { $0.rawValue == factionRaw })
                }
            }
            
            let isRandomFaction = try reader.readBool()
            let hasMainTown = try reader.readBool()
            
            
            var generateHeroAtMainTown = true
            var generateHero = false
            var positionOfMainTown: Position?
            if hasMainTown {
                if format != .restorationOfErathia {
                    generateHeroAtMainTown = try reader.readBool()
                    generateHero = try reader.readBool()
                }
                positionOfMainTown = try reader.readPosition()
            }
            
            let hasRandomHero = try reader.readBool()
         
            let customMainHero: Hero.Custom? = try {
                let heroID = try Int(reader.readUInt8())
                guard heroID != 0xff else { return nil }
                let portraitID = try Int(reader.readUInt8())
                guard portraitID != 0xff else { return nil }
                let name = try reader.readString()
                guard !name.isEmpty else { return nil }
                return .init(id: .init(id: heroID), portraitId: .init(id: portraitID), name: name)
            }()
            
            
            var heroSeeds: [Hero.Seed]?
            if format != .restorationOfErathia {
                let _ = try reader.readUInt8() // VCMI code: variable name: `powerPlaceholders` with comment 'unknown byte'
                let heroCount = try Int(reader.readUInt8())
                try reader.skip(byteCount: 3)
                heroSeeds = try (0..<heroCount).map { _ in
                    let heroID = try Hero.ID(id: .init(reader.readUInt8()))
                    let heroName = try reader.readString()
                    return Hero.Seed(id: heroID, name: heroName)
                }
            }
            
            
//            assert((aiTactic != nil) == isPlayableByAI)
//            assert( (generateHeroAtMainTown || positionOfMainTown != nil) == hasMainTown)
            
            return .init(
                color: playerColor,
                isPlayableByHuman: isPlayableByHuman,
                aiTactic: isPlayableByAI ? aiTactic : nil,
                allowedFactionsForThisPlayer: allowedFactionsForThisPlayer,
                isRandomFaction: isRandomFaction,
                generateHero: generateHero,
                mainTown: hasMainTown ? .init(position: positionOfMainTown!, generateHeroInThisTown: generateHeroAtMainTown) : nil,
                hasRandomHero: hasRandomHero,
                customMainHero: customMainHero,
                heroSeeds: heroSeeds
            )
        }
        
        return .init(players: players)
    }
}

// MARK: About+VictoryLoss Cond.
private extension  Map.Loader.Parser.H3M {
    func parseVictoryLossConditions() throws -> Map.VictoryLossConditions {
        return .init(triggeredEvents: [])
    }
}
    
// MARK: About+Team
private extension  Map.Loader.Parser.H3M {
    func parseTeamInfo() throws -> Map.TeamInfo {
        return .init(teams: [])
    }
    
}

// MARK: About+Heros
private extension  Map.Loader.Parser.H3M {
    func parseAllowedHeroes() throws -> Map.AllowedHeroes {
        return .init(heroes: [])
    }
}
