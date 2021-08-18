//
//  Map+Loader+Parser+H3M.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public extension Map.Loader.Parser {
    final class H3M {
        private let readMap: Map.Loader.ReadMap
        private let reader: DataReader
        private let fileSizeCompressed: Int?
        public init(readMap: Map.Loader.ReadMap, fileSizeCompressed: Int? = nil) {
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
    case unsupportedFormat(Map.Format)
    case unrecognizedDifficulty(Difficulty.RawValue)
    case unrecognizedAITactic(AITactic.RawValue)
    case unrecognizedFaction(Faction.RawValue)
    case unrecognizedHeroID(Hero.ID.RawValue)
    case unrecognizedVictoryConditionKind(Map.VictoryCondition.Kind.Stripped.RawValue)
    case unrecognizedLossConditionKind(Map.VictoryCondition.Kind.Stripped.RawValue)
}


// MARK: Parse Map
extension Map.Loader.Parser.H3M {
    func parse() throws -> Map {
        let about = try parseAbout()
        return .init(about: about)
    }
}

// MARK: Parse About
extension Map.Loader.Parser.H3M {
    
    func parseAbout() throws -> Map.About {
        let summary = try parseMapSummary()
        let format = summary.format
        print(summary.debugDescription)
        let playerInfo = try parsePlayerInfo(format: format)
//        print(playerInfo.debugDescription)
        let victoryLossConditions = try parseVictoryLossConditions(format: format)
        
        /// The teams might contain non playble colors
        let teamInfo = try parseTeamInfo(validColors: playerInfo.players.map({ $0.color }))
        
        let allowedHeroes = try parseAllowedHeroes(format: format)
        
        return .init(
            summary: summary,
            playersInfo: playerInfo,
            victoryLossConditions: victoryLossConditions,
            teamInfo: teamInfo,
            allowedHeroes: allowedHeroes
        )
    }
}


 
// MARK: Parse Map+Summary
private extension  Map.Loader.Parser.H3M {

    func parseMapSummary() throws -> Map.About.Summary {
        // Check map for validity
        guard reader.sourceSize >= 50 else { throw Error.corruptMapFileTooSmall }
        // Map version
        let format = try Map.Format(id: reader.readUInt32())
        
        guard
            format == .restorationOfErathia ||
                format == .armageddonsBlade ||
                format == .shadowOfDeath ||
                format == .wakeOfGods
        else {
            throw Error.unsupportedFormat(format)
        }
        
        /// VCMI variable name `hasPlayablePlayers` but with comment `"unused"`
        try reader.skip(byteCount: 1)
        
        let sizeValue = try reader.readUInt32()
        let height = sizeValue
        let width = sizeValue
        let size = Size(width: .init(width), height: .init(height))
        let hasTwoLevels = try reader.readBool()
        let name = try reader.readString()
        let description = try reader.readString()
        let difficultyRaw = try reader.readInt8()
        guard let difficulty = Difficulty(rawValue: difficultyRaw) else {
            throw Error.unrecognizedDifficulty(difficultyRaw)
        }
        
        let maximumHeroLevel: Int? = try format != .restorationOfErathia ? Int(reader.readUInt8()) : nil
        
        return Map.About.Summary(
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
                case .shadowOfDeath, .wakeOfGods:
                    try reader.skip(byteCount: 13)
                case .armageddonsBlade:
                    try reader.skip(byteCount: 12)
                case .restorationOfErathia:
                    try reader.skip(byteCount: 6)
                }
                return nil
            }
            
            let aiTactic: AITactic? = try {
                /// Unsure about `Int(reader.readUInt8())`, if it ever results in `-1`, probably never?. In VCMI: `static_cast<EAiTactic::EAiTactic>(reader.readUInt8());` and:
                ///
                /// `enum EAiTactic {
                ///    NONE = -1,
                ///    RANDOM,
                ///    WARRIOR,
                ///    BUILDER,
                ///    EXPLORER
                /// };`
                /// So -1 results in `NONE` which I try to model in swift with code below.
                let aiTacticByte = try reader.readUInt8()
                let aiTacticRaw = Int(aiTacticByte)
                guard aiTacticRaw != -1 else { return nil }
                guard let aiTactic = AITactic(rawValue: aiTacticRaw) else {
                    throw Error.unrecognizedAITactic(aiTacticRaw)
                }
                return aiTactic
            }()
            
            if format == .shadowOfDeath || format == .wakeOfGods {
                /// Naming in VCMI: `p7`, with comment `"unknown and unused"`
                try reader.skip(byteCount: 1)
            }
            
            // Factions this player can choose
            let allowedFactionsForThisPlayer: [Faction] = try {
                var allowedFactionsForThisPlayerBitmask = try UInt16(reader.readUInt8())
                
                if format != .restorationOfErathia {
                    allowedFactionsForThisPlayerBitmask += try 256 * UInt16(reader.readUInt8())
                }
                
                let playableFactions: [Faction] = Faction.playable(in: format)
            
                return playableFactions.filter {
                    allowedFactionsForThisPlayerBitmask & (1 << $0.rawValue) != 0
                }
            }()
            
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
                let heroIDRaw = try reader.readUInt8()
                guard heroIDRaw != 0xff else { return nil }
                guard let heroID = Hero.ID(rawValue: heroIDRaw) else {
                    throw Error.unrecognizedHeroID(heroIDRaw)
                }
                let portraitIDRaw = try reader.readUInt8()
              
                let name = try reader.readString()
                guard portraitIDRaw != 0xff else { return nil }
                guard !name.isEmpty else { return nil }
                guard let portraitID = Hero.ID(rawValue: portraitIDRaw) else {
                    throw Error.unrecognizedHeroID(portraitIDRaw)
                }
                return .init(
                    id: heroID,
                    portraitId: portraitID,
                    name: name
                )
            }()
            
            
            var heroSeeds: [Hero.Seed]?
            if format != .restorationOfErathia {

                // VCMI code: variable name: `powerPlaceholders` with comment 'unknown byte'
                try reader.skip(byteCount: 1)

                let heroCount = try Int(reader.readUInt8())
                try reader.skip(byteCount: 3)
                heroSeeds = try (0..<heroCount).map { _ in
                    let heroIDRaw = try reader.readUInt8()
                    guard let heroID = Hero.ID(rawValue: heroIDRaw) else {
                        throw Error.unrecognizedHeroID(heroIDRaw)
                    }
                    let heroName = try reader.readString()
                    return Hero.Seed(id: heroID, name: heroName)
                }
            }
            
            assert((aiTactic != nil) == isPlayableByAI)
            
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

// MARK: VictoryLoss Cond.
private extension  Map.Loader.Parser.H3M {
    func parseVictoryLossConditions(format: Map.Format) throws -> Map.VictoryLossConditions {
    
        let victories = try parseVictoryConditions(format: format)
        let losses = try parseLossConditions()
        
        return .init(
            victoryConditions: victories,
            lossConditions: losses
        )
    }
    
    // MARK: Victory
    func parseVictoryConditions(format: Map.Format) throws -> [Map.VictoryCondition] {
        
        let victoryConditionStrippedRaw = try reader.readUInt8()
        guard let victoryConditionStripped = Map.VictoryCondition.Kind.Stripped(rawValue: victoryConditionStrippedRaw) else {
            throw Error.unrecognizedVictoryConditionKind(victoryConditionStrippedRaw)
        }
        
        if victoryConditionStripped == .standard {
            return [.standard]
        }
        
        let allowNormalVictory = try reader.readBool()
        let appliesToAI = try reader.readBool()
        
        var parameter1: UInt8?
        var parameter2: UInt32?
        var position: Position?
        
        switch victoryConditionStripped {
        case .defeatAllEnemies:
            fatalError("Should have been handled above")
            
        case .acquireSpecificArtifact:
            parameter1 = try reader.readUInt8()
            
            if format != .restorationOfErathia {
                try reader.skip(byteCount: 1)
            }
        case .accumulateCreatures:
            parameter1 = try reader.readUInt8()
            if format != .restorationOfErathia {
                try reader.skip(byteCount: 1)
            }
            parameter2 = try reader.readUInt32()
        case .accumulateResources:
            parameter1 = try reader.readUInt8()
            parameter2 = try reader.readUInt32()
        case .captureSpecificTown:
            position = try reader.readPosition()
        case .flagAllCreatureDwellings:
            break
        case .flagAllMines:
            break
        case .upgradeSpecificTown:
            position = try reader.readPosition()
            parameter1 = try reader.readUInt8()
            parameter2 = try UInt32(reader.readUInt8()) // completely unneccessary to cast this to UInt32, but for basically every other case the `parameter1` is used as a UInt32, thus declaring it having that type makes code (for other cases) safer.
        case .buildGrailBuilding:
            position = try reader.readPosition()
        case .defeatSpecificHero:
            position = try reader.readPosition()
        case .defeatSpecificCreature:
            position = try reader.readPosition()
        case .transportSpecificArtifact:
            parameter1 = try reader.readUInt8()
            position = try reader.readPosition()
        }
        
        let specialVictoryKind = try Map.VictoryCondition.Kind(
            stripped: victoryConditionStripped,
            parameter1: parameter1 != nil ? .init(parameter1!) : nil,
            parameter2: parameter2 != nil ? .init(parameter2!) : nil,
            position: position
        )
        
        let specialVictory = Map.VictoryCondition(
            kind: specialVictoryKind,
            appliesToAI: appliesToAI
        )
        
        var victories: [Map.VictoryCondition] = [specialVictory]
        
        if allowNormalVictory {
            victories.append(.standard)
        }
        
        return victories
    }
    
    // MARK: Loss
    func parseLossConditions() throws -> [Map.LossCondition] {
        
        let lossConditionStrippedRaw = try reader.readUInt8()
        guard let lossConditionStripped = Map.LossCondition.Kind.Stripped(rawValue: lossConditionStrippedRaw) else {
            throw Error.unrecognizedLossConditionKind(lossConditionStrippedRaw)
        }
        
        if lossConditionStripped == .standard {
            return [.standard]
        }
        
        var parameter1: UInt16?
        var position: Position?
        
        switch lossConditionStripped {
        
        case .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns:
            fatalError("should have been handled above")
            
        case .loseSpecificTown, .loseSpecificHero:
            position = try reader.readPosition()
        case .timeLimit:
            parameter1 = try reader.readUInt16()
        }
        
        let specialLossKind = try Map.LossCondition.Kind(
            stripped: lossConditionStripped,
            parameter1: parameter1 != nil ? .init(parameter1!) : nil,
            position: position
        )
        
        let specialLossCondition = Map.LossCondition(kind: specialLossKind)
        
        return [specialLossCondition, .standard]
    }
    
}
    
// MARK: Summary+Team
private extension  Map.Loader.Parser.H3M {
    private final class TempTeam {
        let teamID: UInt8
        var colors: [PlayerColor]
        init(teamID: UInt8, color: PlayerColor) {
            self.colors = [color]
            self.teamID = teamID
        }
    }
    func parseTeamInfo(validColors: [PlayerColor]) throws -> Map.TeamInfo {
        let teamCount = try reader.readUInt8()
        guard teamCount > 0 else {
            // No teams/alliances
            return .init(teams: nil)
        }
        
        let teamByColor: [PlayerColor: UInt8] = try Dictionary(uniqueKeysWithValues:  PlayerColor.allCases.compactMap { playerColor in
            let teamId = try reader.readUInt8()
            guard validColors.contains(playerColor) else { return nil }
            return (key: playerColor, value: teamId)
        })
        var teamsByTeamID: [UInt8: TempTeam] = [:]
        
        teamByColor.forEach({ (color: PlayerColor, teamID: UInt8) in
            if teamsByTeamID[teamID] == nil {
                teamsByTeamID[teamID] = TempTeam(teamID: teamID, color: color)
            } else {
                teamsByTeamID[teamID]!.colors.append(color)
            }
        })
        
        let teams: [Map.TeamInfo.Team] = teamsByTeamID.map({ $0.value }).map({ Map.TeamInfo.Team.init(id: Int($0.teamID), players: $0.colors.sorted()) })
        
        return .init(teams: teams.sorted(by: { $0.id < $1.id }))
    }
    
}

// MARK: Summary+Heros
private extension  Map.Loader.Parser.H3M {
    func parseAllowedHeroes(format: Map.Format) throws -> Map.AllowedHeroes {
        let byteCount = format == .restorationOfErathia ? 16 : 20
        let availableHeroIDs = Hero.ID.playable(in: format)
        let data = try reader.read(byteCount: byteCount)
        let bits = BitArray(data: data)
        
        let playableHeroIDs: [Hero.ID] = bits.prefix(availableHeroIDs.count).enumerated().compactMap {
            let heroID = availableHeroIDs[$0.offset]
            guard $0.element else {
                return nil
            }
            return heroID
        }
        
   
        
        return .init(heroIDs: playableHeroIDs)
    }
}
