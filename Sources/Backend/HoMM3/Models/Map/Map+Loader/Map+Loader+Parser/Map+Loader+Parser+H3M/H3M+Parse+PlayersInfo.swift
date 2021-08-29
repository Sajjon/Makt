//
//  Map+Loader+Parser+H3M+PlayersInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-28.
//

import Foundation


// MARK: PlayersInfo
extension  Map.Loader.Parser.H3M {
    
    func parseInformationAboutPlayers(format: Map.Format) throws -> Map.InformationAboutPlayers {
        
        let playerColors = PlayerColor.allCases
        
        assert(playerColors.count == 8) // parsing logic depends on this.
        
        let players: [Map.InformationAboutPlayers.PlayerInfo] = try playerColors.compactMap { playerColor in
            let isPlayableByHuman = try reader.readBool()
            let isPlayableByAI = try reader.readBool()
            guard isPlayableByAI || isPlayableByHuman else {
                switch format {
                #if WOG
                case .wakeOfGods: fallthrough
                #endif // WOG
                case .shadowOfDeath:
                    try reader.skip(byteCount: 13)
                case .armageddonsBlade:
                    try reader.skip(byteCount: 12)
                case .restorationOfErathia:
                    try reader.skip(byteCount: 6)
                }
                return nil
            }
            
            let aiTactic = try AITactic(integer: reader.readUInt8())
            
            let allowedAlignments: [Alignment] = try format >= .shadowOfDeath ? {
                try reader.readBitArray(byteCount: 1).enumerated().compactMap { (alignmentID, allowed) in
                    guard allowed else { return nil }
                    return Alignment.allCases[alignmentID]
                }
            }() : Alignment.allCases
           
            
            // Factions this player can choose
            let playableFactions: [Faction] = try {
                var playableFactionsBitmask = try UInt16(reader.readUInt8())
                
                if format > .restorationOfErathia {
                    playableFactionsBitmask += try 256 * UInt16(reader.readUInt8())
                }
                
                let playableFactions: [Faction] = Faction.playable(in: format)
            
                return playableFactions.filter {
                    playableFactionsBitmask & (1 << $0.rawValue) != 0
                }
            }()
            
            let basic = Map.InformationAboutPlayers.PlayerInfo.Basic(
                color: playerColor,
                isPlayableByHuman: isPlayableByHuman,
                isPlayableByAI: isPlayableByAI,
                aiTactic: aiTactic,
                allowedAlignments: allowedAlignments,
                playableFactions: playableFactions
            )
            
            
            let _ = try reader.readBool() // isRandomFaction ??? Russians: "Whether the player owns Random Town"???
            let hasMainTown = try reader.readBool()
            
            
            let mainTown: Map.InformationAboutPlayers.PlayerInfo.Additional.MainTown? = hasMainTown ? try {
                let generateHeroAtMainTown = try format == .restorationOfErathia ? true : reader.readBool()
                
                let generateHeroID: Hero.ID? = try format == .restorationOfErathia ? nil : {
                    let heroIDRaw = try reader.readUInt8()
                    guard heroIDRaw != 0xff else {
                        return nil
                    }
                    return try Hero.ID(integer: heroIDRaw)
                }()
                
                //                assert((generateHeroClass != nil) == generateHeroAtMainTown)
                let mainTownPosition = try reader.readPosition()
                
                return .init(
                    position: mainTownPosition,
                    generateHeroInThisTown: generateHeroAtMainTown,
                    generateHeroID: generateHeroID
                )
           }() : nil
            
         
            
            let hasRandomHero = try reader.readBool()
            
            let mainCustomHero: Map.InformationAboutPlayers.StartingHero? = try {
                let heroIDRaw = try reader.readUInt8()
                guard heroIDRaw != 0xff else {
                    return nil
                }
                let heroID = try Hero.ID(integer: heroIDRaw)
                let portraitIDRaw =  try reader.readUInt8()
                var portraitID: Hero.ID?
                if portraitIDRaw != 0xff {
                    portraitID = try Hero.ID(integer: portraitIDRaw)
                }
                let name = try reader.readString()
                
                return .init(
                    heroID: heroID,
                    portraitId: portraitID,
                    name: name
                )
            }()

            if hasRandomHero {
                assert(mainCustomHero == nil)
            }

            assert(isPlayableByHuman || isPlayableByAI)
            
            let additional = Map.InformationAboutPlayers.PlayerInfo.Additional(
                mainTown: mainTown,
                startingHero: mainCustomHero.map { .specific($0) } ?? (hasRandomHero ? .random : nil )
            )
            
            
            return .init(basic: basic, additional: additional)
            
        }
        
        return .init(players: players)
    }
}
