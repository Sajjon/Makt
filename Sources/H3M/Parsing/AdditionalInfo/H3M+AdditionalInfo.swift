//
//  Map+Loader+Parser+H3M+AdditionalInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-28.
//

import Foundation
import Malm

extension H3M {
        
    func parseAdditionalInfo(
        inspector: Map.Loader.Parser.Inspector.AdditionalInfoInspector? = nil,
        format: Map.Format,
        playersInfo: Map.InformationAboutPlayers
    ) throws -> Map.AdditionalInformation {
        let victoryLossConditions = try parseVictoryLossConditions(
            inspector: inspector?.victoryLossInspector, format: format
        )
        
        /// The teams might contain non playble players
        let teamInfo = try parseTeamInfo(validColors: playersInfo.players.map({ $0.player }))
        inspector?.didParseTeamInfo(teamInfo)
        
        let availableHeroes = try parseAvailableHeroes(format: format)
        inspector?.didParseAvailableHeroes(availableHeroes)
        
        
        if format > .restorationOfErathia {
            try reader.skip(byteCount: 4)
        }
        
        let customHeroes = try parseCustomHeroes(format: format, availablePlayers: playersInfo.availablePlayers)
        inspector?.didParseCustomHeroes(customHeroes)
        
        try reader.skip(byteCount: 31) // skip `nil`s
        let availableArtifacts = try parseAvailableArtifacts(format: format)
        inspector?.didParseAvailableArtifacts(availableArtifacts)
        
        let availableSpells = try parseAvailableSpells(format: format)
        inspector?.didParseAvailableSpells(availableSpells)
        
        let availableSecondarySkills = try parseAvailableSecondarySkills(format: format)
        inspector?.didParseAvailableSecondarySkills(availableSecondarySkills)
        
        let rumors = try parseRumors()
        inspector?.didParseRumors(rumors)
        
        let settingsForHeroes = try parseHeroSettings(format: format)
        settingsForHeroes.map { inspector?.didParseHeroSettings($0) }
        
        return .init(
            victoryLossConditions: victoryLossConditions,
            teamInfo: teamInfo,
            availableHeroes: availableHeroes,
            customHeroes: customHeroes,
            availableArtifacts: availableArtifacts,
            availableSpells: availableSpells,
            availableSecondarySkills: availableSecondarySkills,
            rumors: rumors,
            settingsForHeroes: settingsForHeroes
        )
    }
}

// MARK: VictoryLoss Cond.
private extension  H3M {
    func parseVictoryLossConditions(
        inspector: Map.Loader.Parser.Inspector.AdditionalInfoInspector.VictoryLossInspector? = nil,
        format: Map.Format
    ) throws -> Map.VictoryLossConditions {
        
        let victories = try parseVictoryConditions(format: format)
        inspector?.didParseVictoryConditions(victories)
        
        let losses = try parseLossConditions()
        inspector?.didParseLossConditions(losses)
        
        return .init(
            victoryConditions: victories,
            lossConditions: losses
        )
    }
    
    // MARK: Victory
    func parseVictoryConditions(format: Map.Format) throws -> [Map.VictoryCondition] {
        
        let victoryConditionStrippedRaw = try reader.readUInt8()
        guard let victoryConditionStripped = Map.VictoryCondition.Kind.Stripped(rawValue: victoryConditionStrippedRaw) else {
            throw H3MError.unrecognizedVictoryConditionKind(victoryConditionStrippedRaw)
        }
        
        if victoryConditionStripped == .standard {
            return [.standard]
        }
        
        let allowNormalVictory = try reader.readBool()
        let appliesToAI = try reader.readBool()
        
        let specialVictoryKind: Map.VictoryCondition.Kind
        
        switch victoryConditionStripped {
        case .defeatAllEnemies:
            fatalError("Should have been handled above")
        case .acquireSpecificArtifact:
            specialVictoryKind = try .acquireSpecificArtifact(parseArtifactID(format: format)!)
        case .accumulateCreatures:
            specialVictoryKind = try .accumulateCreatures(
                kind: parseCreatureID(format: format)!,
                amount: .init(reader.readUInt32())
            )
        case .accumulateResources:
            specialVictoryKind = try.accumulateResources(
                kind: .init(integer: reader.readUInt8()),
                quantity: Resource.Quantity(reader.readUInt32())
            )
        case .captureSpecificTown:
            specialVictoryKind = try .captureSpecificTown(locatedAt: parsePosition())
        case .flagAllCreatureDwellings:
            specialVictoryKind = .flagAllCreatureDwellings
        case .flagAllMines:
            specialVictoryKind = .flagAllMines
        case .upgradeSpecificTown:
            specialVictoryKind = try .upgradeSpecificTown(
                townLocation: parsePosition(),
                upgradeHallToLevel: .init(reader.readUInt8()),
                upgradeFortToLevel: .init(reader.readUInt8())
            )
        case .buildGrailBuilding:
            specialVictoryKind = try .buildGrailBuilding(inTownLocatedAt: parsePosition())
        case .defeatSpecificHero:
            specialVictoryKind = try .defeatSpecificHero(locatedAt: parsePosition())
        case .defeatSpecificCreature:
            specialVictoryKind = try .defeatSpecificCreature(locatedAt: parsePosition())
        case .transportSpecificArtifact:
            specialVictoryKind = try .transportSpecificArtifact(
                id: parseArtifactID(format: format)!,
                toTownLocatedAt: parsePosition()
            )
        }
        
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
            throw H3MError.unrecognizedLossConditionKind(lossConditionStrippedRaw)
        }
        
        if lossConditionStripped == .standard {
            return [.standard]
        }
        
        let specialLossKind: Map.LossCondition.Kind
        
        switch lossConditionStripped {
        case .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns:
            fatalError("should have been handled above")
        case .loseSpecificTown:
            specialLossKind = try .loseSpecificTown(locatedAt: parsePosition())
        case .loseSpecificHero:
            specialLossKind = try .loseSpecificHero(locatedAt: parsePosition())
        case .timeLimit:
            specialLossKind = try .timeLimit(dayCount: .init(reader.readUInt16()))
        }
        
        let specialLossCondition = Map.LossCondition(kind: specialLossKind)
        
        return [specialLossCondition, .standard]
    }
    
}
    
// MARK: Team
private extension  H3M {
    private final class TempTeam {
        let teamID: UInt8
        var players: [Player]
        init(teamID: UInt8, player: Player) {
            self.players = [player]
            self.teamID = teamID
        }
    }
    
    func parseTeamInfo(validColors: [Player]) throws -> Map.TeamInfo {
        let teamCount = try reader.readUInt8()
        guard teamCount > 0 else {
            return .noTeams
        }
        let teamByColor: [Player: UInt8] = try Dictionary(uniqueKeysWithValues:  Player.allCases.compactMap { player in
            let teamId = try reader.readUInt8()
            guard validColors.contains(player) else { return nil }
            return (key: player, value: teamId)
        })
        var teamsByTeamID: [UInt8: TempTeam] = [:]
        
        teamByColor.forEach({ (player: Player, teamID: UInt8) in
            if teamsByTeamID[teamID] == nil {
                teamsByTeamID[teamID] = TempTeam(teamID: teamID, player: player)
            } else {
                teamsByTeamID[teamID]!.players.append(player)
            }
        })
        
        let teams: [Map.TeamInfo.Team] = teamsByTeamID.map({ $0.value }).map({ Map.TeamInfo.Team.init(id: Int($0.teamID), players: $0.players.sorted()) })
        
        return .teams(teams.sorted(by: { $0.id < $1.id }))
    }
}

// MARK: Parsed Rumors
private extension H3M {
    func parseRumors() throws -> Map.AdditionalInformation.Rumors? {
        let rumors: [Map.Rumor] = try reader.readUInt32().nTimes {
            let name = try reader.readLengthOfStringAndString(assertingMaxLength: 50)! // arbitrarily chosen
            let text = try reader.readLengthOfStringAndString(assertingMaxLength: 2000)! // arbitrarily chosen
            return .init(name: name, text: text)
        }
        guard !rumors.isEmpty else {
            return nil
        }
        
        return .init(values: rumors)
    }
}

// MARK: AvailableHeroes
private extension  H3M {
    func parseAvailableHeroes(format: Map.Format) throws -> HeroIDs {
        let byteCount = format == .restorationOfErathia ? 16 : 20
        return try .init(values: parseBitmask(as: Hero.ID.self, byteCount: byteCount))
    }
}


// MARK: Parse Artifacts
private extension H3M {
    func parseAvailableArtifacts(format: Map.Format) throws -> ArtifactIDs? {
        guard format > .restorationOfErathia else { return nil }
        return try .init(values: parseBitmask(
            of: Artifact.ID.available(in: format),
            byteCount: format == .armageddonsBlade ? 17 : 18,
            negate: true
        ))
    }
}

// MARK: Available Secondary SKills
private extension H3M {
    func parseAvailableSecondarySkills(format: Map.Format) throws -> SecondarySkillKinds? {
        guard format >= .shadowOfDeath else { return nil }
        return try SecondarySkillKinds(values: parseBitmaskOfEnum())
    }
}


// MARK: Available Spells
private extension H3M {
    func parseAvailableSpells(format: Map.Format) throws -> SpellIDs? {
        guard format >= .shadowOfDeath else { return nil }
        return try parseSpellIDs(negate: true)
    }
}

