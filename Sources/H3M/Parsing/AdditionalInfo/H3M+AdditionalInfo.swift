//
//  Map+Loader+Parser+H3M+AdditionalInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-28.
//

import Foundation
import Malm

extension Map.Loader.Parser.H3M {
        
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
private extension  Map.Loader.Parser.H3M {
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
            throw Error.unrecognizedVictoryConditionKind(victoryConditionStrippedRaw)
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
            specialVictoryKind = try .captureSpecificTown(locatedAt: reader.readPosition())
        case .flagAllCreatureDwellings:
            specialVictoryKind = .flagAllCreatureDwellings
        case .flagAllMines:
            specialVictoryKind = .flagAllMines
        case .upgradeSpecificTown:
            specialVictoryKind = try .upgradeSpecificTown(
                townLocation: reader.readPosition(),
                upgradeHallToLevel: .init(reader.readUInt8()),
                upgradeFortToLevel: .init(reader.readUInt8())
            )
        case .buildGrailBuilding:
            specialVictoryKind = try .buildGrailBuilding(inTownLocatedAt: reader.readPosition())
        case .defeatSpecificHero:
            specialVictoryKind = try .defeatSpecificHero(locatedAt: reader.readPosition())
        case .defeatSpecificCreature:
            specialVictoryKind = try .defeatSpecificCreature(locatedAt: reader.readPosition())
        case .transportSpecificArtifact:
            specialVictoryKind = try .transportSpecificArtifact(
                id: parseArtifactID(format: format)!,
                toTownLocatedAt: reader.readPosition()
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
            throw Error.unrecognizedLossConditionKind(lossConditionStrippedRaw)
        }
        
        if lossConditionStripped == .standard {
            return [.standard]
        }
        
        let specialLossKind: Map.LossCondition.Kind
        
        switch lossConditionStripped {
        case .loseAllTownsAndHeroesOrAfterTimeLimitStillControlNoTowns:
            fatalError("should have been handled above")
        case .loseSpecificTown:
            specialLossKind = try .loseSpecificTown(locatedAt: reader.readPosition())
        case .loseSpecificHero:
            specialLossKind = try .loseSpecificHero(locatedAt: reader.readPosition())
        case .timeLimit:
            specialLossKind = try .timeLimit(dayCount: .init(reader.readUInt16()))
        }
        
        let specialLossCondition = Map.LossCondition(kind: specialLossKind)
        
        return [specialLossCondition, .standard]
    }
    
}
    
// MARK: Team
private extension  Map.Loader.Parser.H3M {
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
        let offsetBefore = reader.offset
        let teamByColor: [Player: UInt8] = try Dictionary(uniqueKeysWithValues:  Player.allCases.compactMap { player in
            let teamId = try reader.readUInt8()
            guard validColors.contains(player) else { return nil }
            return (key: player, value: teamId)
        })
        assert(reader.offset == offsetBefore + 8)
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
private extension Map.Loader.Parser.H3M {
    func parseRumors() throws -> Map.AdditionalInformation.Rumors {
        let rumors: [Map.Rumor] = try reader.readUInt32().nTimes {
            let name = try reader.readString()
            let text = try reader.readString()
            return .init(name: name, text: text)
        }
        
        return .init(values: rumors)
    }
}



extension DataReader {
    func readBitArray(byteCount: Int) throws -> BitArray {
        try BitArray(data: read(byteCount: byteCount))
    }
}

// MARK: AvailableHeroes
private extension  Map.Loader.Parser.H3M {
    func parseAvailableHeroes(format: Map.Format) throws -> HeroIDs {
        let availableHeroIDs = Hero.ID.playable(in: format)
        
        let byteCount = format == .restorationOfErathia ? 16 : 20

        let rawBytes = try reader.read(byteCount: byteCount)
        
        let bitmaskFlipped =  BitArray(data: Data(rawBytes.reversed()))
        let bitmaskTooMany = BitArray(bitmaskFlipped.reversed())
        let bitmask = BitArray(bitmaskTooMany.prefix(availableHeroIDs.count))
        
        
        let playableHeroIDs: [Hero.ID] = bitmask
        .enumerated()
            .compactMap { (heroIDIndex, available) -> Hero.ID? in
            guard available else {
                return nil
            }
            return availableHeroIDs[heroIDIndex]
        }

        return .init(values: playableHeroIDs)
    }
}


// MARK: Parse Artifacts
private extension Map.Loader.Parser.H3M {
    func parseAvailableArtifacts(format: Map.Format) throws -> ArtifactIDs? {
        guard format > .restorationOfErathia else { return nil }
        let allAvailable = Artifact.ID.available(in: format)
        
        let byteCount = format == .armageddonsBlade ? 17 : 18

        let rawBytes = try reader.read(byteCount: byteCount)
        
        let bitmaskFlipped =  BitArray(data: Data(rawBytes.reversed()))
        let bitmaskTooMany = BitArray(bitmaskFlipped.reversed())
        let bitmask = BitArray(bitmaskTooMany.prefix(allAvailable.count))
                
        let availableArtifactIDs: [Artifact.ID] = bitmask.enumerated().compactMap { (artifactIDIndex, available) in
            guard !available else { return nil }
            return allAvailable[artifactIDIndex]
        }
        
        // TODO VCMI manually bans combination artifacts according to some logic... needed?
        return .init(values: availableArtifactIDs)
    }
}

// MARK: Available Secondary SKills
private extension Map.Loader.Parser.H3M {
    func parseAvailableSecondarySkills(format: Map.Format) throws -> SecondarySkillKinds? {
        guard format >= .shadowOfDeath else { return nil }
        let allSkillIDs = Hero.SecondarySkill.Kind.allCases
        
        let availableSkillIDs: [Hero.SecondarySkill.Kind] = try Array(reader.readBitArray(byteCount: 4).prefix(allSkillIDs.count)).enumerated().compactMap { (skillKindIDIndex, available) in
            guard available else { return nil }
            return allSkillIDs[skillKindIDIndex]
        }
        
        return .init(values: availableSkillIDs)
    }
}

// MARK: Parse Available Spells
private extension Map.Loader.Parser.H3M {
    
    func parseAvailableSpells(format: Map.Format) throws -> SpellIDs? {
        guard format >= .shadowOfDeath else { return nil }
        let spells = try parseSpellIDs(includeIfBitSet: false)
        return .init(values: spells)
    }
}