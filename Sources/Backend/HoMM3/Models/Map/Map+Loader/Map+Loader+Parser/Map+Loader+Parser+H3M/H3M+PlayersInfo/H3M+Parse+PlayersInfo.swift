//
//  Map+Loader+Parser+H3M+PlayersInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-28.
//

import Foundation

private extension Map.Loader.Parser.H3M {
    func parsePlayer(
        inspector: Map.Loader.Parser.Inspector.PlayersInfoInspector? = nil,
        format: Map.Format,
        player: Player,
        isPlayableByHuman: Bool,
        isPlayableByAI: Bool,
        assertIsPlayable: Bool = true
    ) throws -> Map.InformationAboutPlayers.PlayerInfo {
        let isPlayable = isPlayableByHuman || assertIsPlayable
        if assertIsPlayable {
            precondition(isPlayable)
        }
        let aiTactic: AITactic = try AITactic(integer: reader.readUInt8())
        
        if isPlayable {
            inspector?.didParseAITactic(aiTactic, player: player)
        }
        
        let allowedAlignments: UInt8? = try format >= .shadowOfDeath ? reader.readUInt8() : nil
       
        
        // Factions this player can choose
        let playableFactions: [Faction] = try {
            var playableFactionsBitmask = try UInt16(reader.readUInt8())
            
            if format != .restorationOfErathia {
                playableFactionsBitmask += try 256 * UInt16(reader.readUInt8())
            }
            
            let playableFactions: [Faction] = Faction.playable(in: format)
        
            return playableFactions.filter {
                playableFactionsBitmask & (1 << $0.rawValue) != 0
            }
        }()
        
        if isPlayable {
            inspector?.didParsePlayableFactions(playableFactions, player: player)
        }
        
        let _ = try reader.readBool() // `hasRandomTown`
        
        let hasMainTown = try reader.readBool()
        inspector?.didParseHasMainTown(hasMainTown, player: player)
        
    
        let maybeMainTown: Map.InformationAboutPlayers.PlayerInfo.MainTown? = hasMainTown ? try {
            var generateHeroAtMainTown = true
            var townFaction: Faction = .random
            if format != .restorationOfErathia {
                generateHeroAtMainTown = try reader.readBool()
                townFaction = try Faction(integer: reader.readUInt8())
            }
            let positionOfMainTown = try reader.readPosition()
            let mainTown = Map.InformationAboutPlayers.PlayerInfo.MainTown.init(generateHeroInThisTown: generateHeroAtMainTown, faction: townFaction, position: positionOfMainTown)
            return mainTown
        }() : nil
        inspector?.didParseMainTown(maybeMainTown, player: player)
        
        
        let hasRandomHero = try reader.readBool()

        let mainHero: Map.InformationAboutPlayers.PlayerInfo.MainHero? = try {
            let heroIDRaw = try reader.readUInt8()
            guard heroIDRaw != 0xff else { return nil }
            let heroID = try Hero.ID(id: heroIDRaw)
            let customPortraitIDRaw = try reader.readUInt8()
            let face: Hero.ID? = customPortraitIDRaw != 0xff ? try Hero.ID(integer: customPortraitIDRaw) : nil
            /// TODO? CHANGE? Always read? the `name` even though we might not have a portrait id => which results in returning nil. Otherwise we mess up byte offset.
            let name = try reader.readString(maxByteCount: isPlayable ? 12 : 0) // max length of `12` is from `homm3tools`
            let mainHero = Map.InformationAboutPlayers.PlayerInfo.MainHero(heroID: heroID, portraitId: face, name: name)
            return mainHero
        }()
        
        
        let additionalInfo: Map.InformationAboutPlayers.PlayerInfo.AdditionalInfo? = try {
            guard format > .restorationOfErathia else { return nil }
            
            try reader.skip(byteCount: 1)
            
            let heroCount = try Int(reader.readUInt8())
            try reader.skip(byteCount: 3)
        
            let heroes: [Map.InformationAboutPlayers.PlayerInfo.AdditionalInfo.SimpleHero] = try heroCount.nTimes {
                let faceID = try Hero.ID(integer: reader.readUInt8())
                let heroName = try reader.readString()
                return .init(faceID: faceID, name: heroName)
            }
            
            let additionalInfo = Map.InformationAboutPlayers.PlayerInfo.AdditionalInfo(heroes: heroes)
            return additionalInfo
        }()
        
        let playersInfo = Map.InformationAboutPlayers.PlayerInfo(
            player: player,
            isPlayableByHuman: isPlayableByHuman,
            aiTactic: isPlayableByAI ? aiTactic : nil,
            allowedAlignments: allowedAlignments,
            playableFactions: playableFactions,
            mainTown: maybeMainTown,
            hasRandomHero: hasRandomHero,
            mainHero: mainHero,
            additionalInfo: additionalInfo
        )
  
        
        return playersInfo
    }
}

// MARK: PlayersInfo
extension Map.Loader.Parser.H3M {
    
    func parseInformationAboutPlayers(
        inspector: Map.Loader.Parser.Inspector.PlayersInfoInspector? = nil,
        format: Map.Format
    ) throws -> Map.InformationAboutPlayers {
        var parsedLastPlayer = false
        let players: [Map.InformationAboutPlayers.PlayerInfo] = try Player.allCases.compactMap { player in
            let isPlayableByHuman = try reader.readBool()
            if !parsedLastPlayer {
                print("♕ \(player): isPlayableByHuman=\(isPlayableByHuman)")
                inspector?.didParseIsPlayableByHuman(isPlayableByHuman, player: player)
            }
            
            let isPlayableByAI = try reader.readBool()
            if !parsedLastPlayer {
                print("♕ \(player): isPlayableByAI=\(isPlayableByAI)")
                inspector?.didParseIsPlayableByAI(isPlayableByAI, player: player)
            }
            
            let playerIsPlayable = isPlayableByAI || isPlayableByHuman
            
            guard playerIsPlayable else {
                // Supress errors, this player is not playable and coming bytes will contain junk.
                let _ = try? parsePlayer(
                    inspector: nil,
                    format: format,
                    player: player,
                    isPlayableByHuman: false,
                    isPlayableByAI: false,
                    assertIsPlayable: false
                )
                parsedLastPlayer = true
                return nil
            }
            
            return try parsePlayer(
                inspector: inspector,
                format: format,
                player: player,
                isPlayableByHuman: isPlayableByHuman,
                isPlayableByAI: isPlayableByAI
            )
        }
        
        let informationAboutPlayers = Map.InformationAboutPlayers(players: players)
        inspector?.didFinishParsingInformationAboutPlayers(informationAboutPlayers)
        
        return informationAboutPlayers
    }
    
}
