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
        playerColor: PlayerColor,
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
        print("♕ \(playerColor): aiTactic=\(aiTactic)")
        inspector?.didParseAITactic(aiTactic, playerColor: playerColor)
        }
        
        let allowedAlignments: UInt8? = try format >= .shadowOfDeath ? reader.readUInt8() : nil
        if isPlayable {
            print("♕ \(playerColor): allowedAlignments=\(allowedAlignments)")
            
        }
        
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
            
        print("♕ \(playerColor): playableFactions=\(playableFactions)")
        inspector?.didParsePlayableFactions(playableFactions, playerColor: playerColor)
        }
        
        let hasRandomTown = try reader.readBool()
        print("♕ \(playerColor): hasRandomTown=\(hasRandomTown)")
//        inspector?.didParseHasRandomHero(<#T##value: Bool##Bool#>, playerColor: <#T##PlayerColor#>)
        
        let hasMainTown = try reader.readBool()
        print("♕ \(playerColor): hasMainTown=\(hasMainTown)")
        inspector?.didParseHasMainTown(hasMainTown, playerColor: playerColor)
        
    
        let maybeMainTown: Map.InformationAboutPlayers.PlayerInfo.MainTown? = hasMainTown ? try {
            var generateHeroAtMainTown = true
            var townFaction: Faction = .random
            if format != .restorationOfErathia {
                generateHeroAtMainTown = try reader.readBool()
                print("♕ \(playerColor): generateHeroAtMainTown=\(generateHeroAtMainTown)")
                townFaction = try Faction(integer: reader.readUInt8())
                print("♕ \(playerColor): townFaction=\(townFaction)")
            }
            let positionOfMainTown = try reader.readPosition()
            print("♕ \(playerColor): positionOfMainTown=\(positionOfMainTown)")
            let mainTown = Map.InformationAboutPlayers.PlayerInfo.MainTown.init(generateHeroInThisTown: generateHeroAtMainTown, faction: townFaction, position: positionOfMainTown)
            return mainTown
        }() : nil
        inspector?.didParseMainTown(maybeMainTown, playerColor: playerColor)
        
        
        let hasRandomHero = try reader.readBool()
        print("♕ \(playerColor): hasRandomHero=\(hasRandomHero)")

        let mainHero: Map.InformationAboutPlayers.PlayerInfo.MainHero? = try {
            let heroIDRaw = try reader.readUInt8()
            guard heroIDRaw != 0xff else { return nil }
            let heroID = try Hero.ID(id: heroIDRaw)
            let customPortraitIDRaw = try reader.readUInt8()
            let face: Hero.ID? = customPortraitIDRaw != 0xff ? try Hero.ID(integer: customPortraitIDRaw) : nil
            /// TODO? CHANGE? Always read? the `name` even though we might not have a portrait id => which results in returnin nil. Otherwise we mess up byte offset.
            let name = try reader.readString(maxByteCount: isPlayable ? 12 : 0) // from `homm3tools`
            let mainHero = Map.InformationAboutPlayers.PlayerInfo.MainHero(heroID: heroID, portraitId: face, name: name)
            print("♕ \(playerColor): mainHero=\(mainHero)")
            return mainHero
        }()
        
        
        let additionalInfo: Map.InformationAboutPlayers.PlayerInfo.AdditionalInfo? = try {
            guard format > .restorationOfErathia else { return nil }
            
            try reader.skip(byteCount: 1)
            
            let heroCount = try Int(reader.readUInt8())
            try reader.skip(byteCount: 3) // same as
            
            reader.rewind(byteCount: 4)
            let heroCountU32 = try Int(reader.readUInt32())
            assert(heroCountU32 == heroCount, "Just debugging and chechking that in all instances where we just read one byte and skip 3, that we are doing the right thing...")
            
            let heroes: [Map.InformationAboutPlayers.PlayerInfo.AdditionalInfo.SimpleHero] = try heroCount.nTimes {
                let faceID = try Hero.ID(integer: reader.readUInt8())
                let heroName = try reader.readString()
                return .init(faceID: faceID, name: heroName)
            }
            
            let additionalInfo = Map.InformationAboutPlayers.PlayerInfo.AdditionalInfo(heroes: heroes)
            print("♕ \(playerColor): additionalInfo=\(additionalInfo)")
            return additionalInfo
        }()
        
        return Map.InformationAboutPlayers.PlayerInfo(
            color: playerColor,
            isPlayableByHuman: isPlayableByHuman,
            aiTactic: isPlayableByAI ? aiTactic : nil,
            allowedAlignments: allowedAlignments,
            playableFactions: playableFactions,
        
//                isRandomFaction: hasRandomTown,
//                generateHero: generateHero,
            mainTown: maybeMainTown,
            hasRandomHero: hasRandomHero,
            mainHero: mainHero,
            additionalInfo: additionalInfo
//                customMainHero: customMainHero,
//                heroSeeds: heroSeeds
        )
    }
}

// MARK: PlayersInfo
extension Map.Loader.Parser.H3M {
    
    func parseInformationAboutPlayers(
        inspector: Map.Loader.Parser.Inspector.PlayersInfoInspector? = nil,
        format: Map.Format
    ) throws -> Map.InformationAboutPlayers {
        var parsedLastPlayer = false
        let players: [Map.InformationAboutPlayers.PlayerInfo] = try PlayerColor.allCases.compactMap { playerColor in
            let isPlayableByHuman = try reader.readBool()
            if !parsedLastPlayer {
                print("♕ \(playerColor): isPlayableByHuman=\(isPlayableByHuman)")
                inspector?.didParseIsPlayableByHuman(isPlayableByHuman, playerColor: playerColor)
            }
            
            let isPlayableByAI = try reader.readBool()
            if !parsedLastPlayer {
                print("♕ \(playerColor): isPlayableByAI=\(isPlayableByAI)")
                inspector?.didParseIsPlayableByAI(isPlayableByAI, playerColor: playerColor)
            }
            
            let playerIsPlayable = isPlayableByAI || isPlayableByHuman
            
            guard playerIsPlayable else {
                // Supress errors, this player is not playable and coming bytes will contain junk.
                let _ = try? parsePlayer(
                    inspector: nil,
                    format: format,
                    playerColor: playerColor,
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
                playerColor: playerColor,
                isPlayableByHuman: isPlayableByHuman,
                isPlayableByAI: isPlayableByAI
            )
        }
        
        return .init(players: players)
    }
    
}
