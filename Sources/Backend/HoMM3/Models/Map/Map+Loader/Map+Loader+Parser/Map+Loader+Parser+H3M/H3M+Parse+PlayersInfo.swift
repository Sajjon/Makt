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
            
            let allowedAlignment: Alignment? = try format >= .shadowOfDeath ? Alignment(integer: reader.readUInt8()) : nil
           
            
            // Factions this player can choose
            let allowedFactionsForThisPlayer: [Faction] = try {
                var allowedFactionsForThisPlayerBitmask = try UInt16(reader.readUInt8())
                
                if format > .restorationOfErathia {
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
            var heroClass: Hero.Class?
            var positionOfMainTown: Position?
            if hasMainTown {
                if format > .restorationOfErathia {
                    generateHeroAtMainTown = try reader.readBool()
                    heroClass = try Hero.Class(integer: reader.readUInt8())
                }
                positionOfMainTown = try reader.readPosition()
            }
            
            let hasRandomHero = try reader.readBool()
         
            let customStartingHero: Map.InformationAboutPlayers.StartingHero? = try {
                let heroClassRaw = try reader.readUInt8()
                guard heroClassRaw != 0xff else { return nil }
//                guard hasCustomMainHeroID else { return nil }
                let heroClass = try Hero.Class(id: heroClassRaw)
                let portratidIDRaw = try reader.readUInt8()
                
                /// Always read the `name` even though we might not have a portrait id => which results in returnin nil. Otherwise we mess up byte offset.
                let name = try reader.readString()
                guard !name.isEmpty else { return nil }
                guard portratidIDRaw != 0xff else { return nil }
                let portraitID = try Hero.ID(id: portratidIDRaw)
                return .init(
                    class: heroClass,
                    portraitId: portraitID,
                    name: name
                )
            }()
            
            
//            var heroSettings: [Hero.Settings]?
//            if format != .restorationOfErathia {
//
//                // VCMI code: variable name: `powerPlaceholders` with comment 'unknown byte'
//                try reader.skip(byteCount: 1)
//
//                let heroCount = try Int(reader.readUInt8())
//                try reader.skip(byteCount: 3)
//                heroSettings = try heroCount.nTimes {
//                    let heroID = try parseHeroID()!
//                    let heroName = try reader.readString()
//                    return .init(id: heroID, name: heroName)
//                }
//            }
//

            fatalError()
            
//            let basic = Map.InformationAboutPlayers.PlayerInfo.Basic(
//                color: playerColor,
//                isPlayableByHuman: isPlayableByHuman,
//                isPlayableByAI: isPlayableByAI,
//                aiTactic: aiTactic,
//                allowedAlignments: allowedAlignment,
//                playableFactions: allowedFactionsForThisPlayer,
//                hasMainTown: hasMainTown ? )
//
//            let additional = Map.InformationAboutPlayers.PlayerInfo.Basic()
//
//            return Map.InformationAboutPlayers.PlayerInfo(
//                basic: basic,
//                additional: additional
//            )
        }
        
        return .init(players: players)
    }
}
