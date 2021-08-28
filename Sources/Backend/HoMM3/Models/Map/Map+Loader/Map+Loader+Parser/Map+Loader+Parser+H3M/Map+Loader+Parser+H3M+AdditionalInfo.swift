//
//  Map+Loader+Parser+H3M+AdditionalInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-28.
//

import Foundation

extension Map.Loader.Parser.H3M {
        
    func parseAdditionalInfo(
        inspector: Map.Loader.Parser.Inspector? = nil,
        format: Map.Format,
        playersInfo: Map.InformationAboutPlayers
    ) throws -> Map.AdditionalInformation {
        
        let victoryLossConditions = try parseVictoryLossConditions(format: format)
        
        /// The teams might contain non playble colors
        let teamInfo = try parseTeamInfo(validColors: playersInfo.players.map({ $0.color }))
        
        let availableHeroes = try parseAvailableHeroes(format: format)
        
        
        if format > .restorationOfErathia {
            try reader.skip(byteCount: 4)
//            let placeholderQuantity = try Int(reader.readUInt32())
//            try reader.skip(byteCount: placeholderQuantity)
        }
   
        
        let customHeroes = try parseCustomHeroes(format: format)
        customHeroes.map { inspector?.didParseCustomHeroes($0) }
        
        try reader.skip(byteCount: 31) // skip `nil`s
        
        let availableArtifacts = try parseAvailableArtifacts(format: format)
        customHeroes.map { inspector?.didParseCustomHeroes($0) }
        
        let availableSpells = try parseAvailableSpells(format: format)
        availableSpells.map { inspector?.didParseAvailableSpells($0) }
        
        let availableSecondarySkills = try parseAvailableSecondarySkills(format: format)
        availableSecondarySkills.map { inspector?.didParseAvailableSecondarySkills($0) }
        
        let rumors = try parseRumors()
        inspector?.didParseRumors(rumors)
        
        let heroSettings = try parseHeroSettings(format: format)
        heroSettings.map { inspector?.didParseHeroSettings($0) }
        
        return .init(
            victoryLossConditions: victoryLossConditions,
            teamInfo: teamInfo,
            availableHeroes: availableHeroes,
            customHeroes: customHeroes,
            availableArtifacts: availableArtifacts,
            availableSpells: availableSpells,
            availableSecondarySkills: availableSecondarySkills,
            rumors: rumors,
            heroSettings: heroSettings
        )
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
    
// MARK: Team
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


// MARK: Parsed Rumors
private extension Map.Loader.Parser.H3M {
    func parseRumors() throws -> Map.AdditionalInformation.Rumors {
        let rumors: [Map.Rumor] = try reader.readUInt32().nTimes {
            let name = try reader.readString()
            let text = try reader.readString()
            return .init(name: name, text: text)
        }
        
        return .init(rumors: rumors)
    }
}



extension DataReader {
    func readBitArray(byteCount: Int) throws -> BitArray {
        try BitArray(data: read(byteCount: byteCount))
    }
}

// MARK: AvailableHeroes
private extension  Map.Loader.Parser.H3M {
    func parseAvailableHeroes(format: Map.Format) throws -> Map.AvailableHeroes {
        let availableHeroIDs = Hero.ID.playable(in: format)
        
        let playableHeroIDs: [Hero.ID] = try reader.readBitArray(
            byteCount: format == .restorationOfErathia ? 16 : 20
        )
        .prefix(availableHeroIDs.count)
        .enumerated()
        .compactMap {
            let heroID = availableHeroIDs[$0.offset]
            guard $0.element else {
                return nil
            }
            return heroID
        }

        return .init(heroIDs: playableHeroIDs)
    }
}


// MARK: Parse Artifacts
private extension Map.Loader.Parser.H3M {
    func parseAvailableArtifacts(format: Map.Format) throws -> Map.AdditionalInformation.AvailableArtifacts? {
        guard format != .restorationOfErathia else { return nil }
        let allAvailable = Artifact.ID.available(in: format)
        
        let bits = try reader.readBitArray(byteCount: format == .armageddonsBlade ? 17 : 18)
        
        let availableArtifactIDs: [Artifact.ID] = bits.prefix(allAvailable.count).enumerated().compactMap { (artifactIDIndex, available) in
            guard available else { return nil }
            return allAvailable[artifactIDIndex]
        }
        
        // TODO VCMI manually bans combination artifacts according to some logic... needed?
        return .init(artifacts: availableArtifactIDs)
    }
}

// MARK: Available Secondary SKills
private extension Map.Loader.Parser.H3M {
    func parseAvailableSecondarySkills(format: Map.Format) throws -> Map.AdditionalInformation.AvailableSecondarySkills? {
        guard format >= .shadowOfDeath else { return nil }
        let allSkillIDs = Hero.SecondarySkill.Kind.allCases
        
        let availableSkillIDs: [Hero.SecondarySkill.Kind] = try Array(reader.readBitArray(byteCount: 4).prefix(allSkillIDs.count)).enumerated().compactMap { (skillKindIDIndex, available) in
            guard available else { return nil }
            return allSkillIDs[skillKindIDIndex]
        }
        
        return .init(secondarySkills: availableSkillIDs)
    }
}

// MARK: Parse Available Spells
private extension Map.Loader.Parser.H3M {
    
    func parseAvailableSpells(format: Map.Format) throws -> Map.AdditionalInformation.AvailableSpells? {
        guard format >= .shadowOfDeath else { return nil }
        let spells = try parseSpellIDs()
        return .init(spells: spells)
    }
}
