//
//  Map+Loader+Parser+H3M+PlayersInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-28.
//

import Foundation


// MARK: PlayersInfo
extension Map.Loader.Parser.H3M {
    
    func parseInformationAboutPlayers(
        inspector: Map.Loader.Parser.Inspector.PlayersInfoInspector? = nil,
        format: Map.Format
    ) throws -> Map.InformationAboutPlayers {
        switch format {
        case .restorationOfErathia:
            return try parsePlayersROE(inspector: inspector)
        case .armageddonsBlade:
            return try parsePlayersAB(inspector: inspector)
        case .shadowOfDeath: fatalError("todo")
            #if WOG
            case .wakeOfGods: fatalError("todo")
            #endif // WOG
        }
    }
}

private extension Map.Loader.Parser.H3M {
    func parsePlayers(
        parseInfo: (PlayerColor) throws -> Map.InformationAboutPlayers.PlayerInfoVersioned?
    ) throws -> Map.InformationAboutPlayers {
        let playerColors = PlayerColor.allCases
        assert(playerColors.count == 8)
        var players: [Map.InformationAboutPlayers.PlayerInfo] = []
        for playerColor in playerColors {
            guard let info = try parseInfo(playerColor) else {
                continue // NOT break! will ruin offset
            }
            players.append(.init(color: playerColor, info: info))
        }
        return .init(players: players)
    }
}

extension Map.Loader.Parser.H3M {
    func parseBitFieldAsAllowedCases<Enum>(
        cases: [Enum]
    ) throws -> [Enum] where Enum: CaseIterable, Enum.AllCases == [Enum], Enum: RawRepresentable, Enum.RawValue == UInt8 {
        let caseCount = cases.count
        let qr = caseCount.quotientAndRemainder(dividingBy: 8)
        let byteCount = qr.remainder == 0 ? qr.quotient : qr.quotient + 1
        return try reader.readBitArray(byteCount: byteCount)
            .prefix(caseCount)
            .enumerated().compactMap { (index, allowed) in
            guard allowed else { return nil }
            return cases[index]
        }
    }
    
    func parseBitFieldAsAllowedCases<Enum>(
        of enumType: Enum.Type
    ) throws -> [Enum] where Enum: CaseIterable, Enum.AllCases == [Enum], Enum: RawRepresentable, Enum.RawValue == UInt8 {
        try parseBitFieldAsAllowedCases(cases: Enum.allCases)
    }
    
 
}

private extension Map.Loader.Parser.H3M {
    
    func parseCanBeHuman() throws -> Bool {
        try reader.readBool()
    }
    
    func parseCanBeComputer() throws -> Bool {
        try reader.readBool()
    }
    
    func parseBehaviour() throws -> AITactic {
        try AITactic(integer: reader.readUInt8())
    }
    
    func parseStartingHeroIsRandom() throws -> Bool {
        try reader.readBool()
    }
}


// MARK: ROE
private extension Map.Loader.Parser.H3M {
    func parsePlayersROE(inspector: Map.Loader.Parser.Inspector.PlayersInfoInspector? = nil) throws -> Map.InformationAboutPlayers {
        
        func parseAllowedFactions() throws -> [Faction] {
            let allowedFactionsForThisPlayerBitmask = try UInt16(reader.readUInt8())
            let playableFactions: [Faction] = Faction.playable(in: .restorationOfErathia)
            return playableFactions.filter {
                allowedFactionsForThisPlayerBitmask & (1 << $0.rawValue) != 0
            }
        }
        
        func parseBasic() throws -> Map.InformationAboutPlayers.ROE.Basic? {
            let isPlayableByHuman = try parseCanBeHuman()
            let isPlayableByAI = try parseCanBeComputer()

            guard isPlayableByHuman || isPlayableByAI else {
                try reader.skip(byteCount: 6)
                return nil
            }
            
            let behaviour = try parseBehaviour()
            let playableFactions = try parseAllowedFactions()
            let hasRandomTown = try reader.readBool()
            let hasMainTown = try reader.readBool()
        
            return .init(
                isPlayableByHuman: isPlayableByHuman,
                isPlayableByAI: isPlayableByAI,
                behavior: behaviour,
                playableFactions: playableFactions,
                hasRandomTown: hasRandomTown,
                hasMainTown: hasMainTown
            )
        }
        
        func parseExtra(basic: Map.InformationAboutPlayers.ROE.Basic) throws -> Map.InformationAboutPlayers.ROE.Extra {
            var mainTownPosition: Position!
            if basic.hasMainTown {
                mainTownPosition = try reader.readPosition()
            }
            let startingHeroIsRandom = try parseStartingHeroIsRandom()
            let startingHeroIDRaw = try reader.readUInt8()
            let hasStartingHero = startingHeroIDRaw != 0xff
            
            /// Asserts that the HeroIDRaw is valid
//            let _: Hero.ID? = try hasStartingHero ? nil : Hero.ID(integer: startingHeroIDRaw)
            
            var startingHeroFace: Hero.ID!
            var startingHeroName: String?
            if hasStartingHero {
                startingHeroFace = try .init(integer: reader.readUInt8())
                startingHeroName = try reader.readString(maxByteCount: 12)
            }
            
            let extra: Map.InformationAboutPlayers.ROE.Extra
            switch (basic.hasMainTown, hasStartingHero) {
            case (false, false):
                extra = .default(.init(startingHeroIsRandom: startingHeroIsRandom, startingHeroID: startingHeroIDRaw))
            case (true, false):
                extra = .withTown(.init(startingTownPosition: mainTownPosition!, startingHeroIsRandom: startingHeroIsRandom, startingHeroID: startingHeroIDRaw))
            case (false, true):
                extra = .withHero(.init(startingHeroIsRandom: startingHeroIsRandom, startingHeroID: startingHeroIDRaw, startingHeroFace: startingHeroFace.rawValue, startingHeroName: startingHeroName))
            case (true, true):
                extra = .withTownAndHero(
                    .init(
                        startingTownPosition: mainTownPosition!,
                        startingHeroIsRandom: startingHeroIsRandom,
                        startingHeroID: startingHeroIDRaw,
                        startingHeroFace: startingHeroFace.rawValue,
                        startingHeroName: startingHeroName
                    )
                )
            }
            
            return extra
            
        }
        
        
        return try parsePlayers { playerColor in
            guard let basic = try parseBasic() else { return nil }
            inspector?.didParsePlayerInfoROEBasic(basic, color: playerColor)
            let extra = try parseExtra(basic: basic)
            inspector?.didParsePlayerInfoROEExtra(extra, color: playerColor)
            return .roe(.init(basic: basic, extra: extra))
        }
    }
}



// MARK: AB
private extension Map.Loader.Parser.H3M {
    
    func playableFactionsABSOD(format: Map.Format) throws -> [Faction]  {
         var allowedFactionsForThisPlayerBitmask = try UInt16(reader.readUInt8())

             allowedFactionsForThisPlayerBitmask += try 256 * UInt16(reader.readUInt8())

         let playableFactions: [Faction] = Faction.playable(in: format)

         return playableFactions.filter {
             allowedFactionsForThisPlayerBitmask & (1 << $0.rawValue) != 0
         }
     }
    
    func parsePlayersAB(inspector: Map.Loader.Parser.Inspector.PlayersInfoInspector? = nil) throws -> Map.InformationAboutPlayers {
        
        func parseBasic() throws -> Map.InformationAboutPlayers.AB.Basic? {
            let isPlayableByHuman = try parseCanBeHuman()
            let isPlayableByAI = try parseCanBeComputer()
            
            
            guard isPlayableByHuman || isPlayableByAI else {
                try reader.skip(byteCount: 12)
                return nil
            }
            
            let behaviour = try parseBehaviour()
            
            let allowedAlignmentRaw = try reader.readUInt8()
            let allowedAlignment: Alignment? = allowedAlignmentRaw != 0xff ? try .init(integer: allowedAlignmentRaw) : nil

            var playableFactions = try playableFactionsABSOD(format: .armageddonsBlade)
            let isConfluxAllowed = try reader.readBool()
            if isConfluxAllowed {
                playableFactions.append(.conflux)
            }
            let hasRandomTown = try reader.readBool()
            let hasMainTown = try reader.readBool()
        
            return .init(
                isPlayableByHuman: isPlayableByHuman,
                isPlayableByAI: isPlayableByAI,
                behavior: behaviour,
                playableFactions: playableFactions,
                isConfluxAllowed: isConfluxAllowed,
                hasRandomTown: hasRandomTown,
                hasMainTown: hasMainTown
            )
        }
        
        return try parsePlayers { playerColor in
            print("Trying to parse basic info about player: \(playerColor)")
            guard let basic = try parseBasic() else { return nil }
            print("🍀 Parsed basic info about player: \(playerColor)")
            inspector?.didParsePlayerInfoABBasic(basic, color: playerColor)
            print("Trying to parse extra info about player: \(playerColor)")
            let extra = try parseExtraABSOD(hasMainTown: basic.hasMainTown)
            print("🍀 Parsed extra info about player: \(playerColor)")
            inspector?.didParsePlayerInfoABSODExtra(extra, color: playerColor)
            return .ab(.init(basic: basic, extra: extra))
        }
    }
}

// MARK: ABSOD
private extension Map.Loader.Parser.H3M {
    func parseExtraABSOD(hasMainTown: Bool) throws -> Map.InformationAboutPlayers.ExtraABSOD {
        var mainTownPosition: Position!
        var createHeroAtStartingTown: Bool = false
        var mainTownFaction: Faction!
        if hasMainTown {
            createHeroAtStartingTown = try reader.readBool()
            mainTownFaction = try Faction(integer: reader.readUInt8())
            mainTownPosition = try reader.readPosition()
        }
        let startingHeroIsRandom = try parseStartingHeroIsRandom()
        let startingHeroIDRaw = try reader.readUInt8()
        let maybeHasStartingHero = startingHeroIDRaw != 0xff
        
        /// Asserts that the HeroIDRaw is valid
//        let _: Hero.ID? = try maybeHasStartingHero ? nil : Hero.ID(integer: startingHeroIDRaw)
        
        var startingHeroFace: Hero.ID!
        var startingHeroName: String?
        if maybeHasStartingHero {
            startingHeroFace = try .init(integer: reader.readUInt8())
            startingHeroName = try reader.readString(maxByteCount: 12)
        }
        
        let hasStartingHero = maybeHasStartingHero && startingHeroName != nil
        
        let extra: Map.InformationAboutPlayers.ExtraABSOD
        switch (hasMainTown, hasStartingHero) {
        case (false, false):
            fatalError("Ever get here?")
            extra = .default(.init(
                startingHeroIsRandom: startingHeroIsRandom,
                startingHeroID: startingHeroIDRaw,
                startingHeroFace: startingHeroFace.rawValue,
                startingHeroName: startingHeroName!
            )
            )
        case (true, false):
            extra = .withTown(.init(
                createHeroAtStartingTown: createHeroAtStartingTown,
                startingTownFaction: mainTownFaction,
                startingTownPosition: mainTownPosition,
                startingHeroIsRandom: startingHeroIsRandom,
                startingHeroID: startingHeroIDRaw
            )
            )
        case (false, true):
            fatalError("Ever get here?")
            extra = .withHero(.init(
                startingHeroIsRandom: startingHeroIsRandom,
                startingHeroID: startingHeroIDRaw,
                startingHeroFace: startingHeroFace.rawValue,
                startingHeroName: startingHeroName!
            )
            )
        case (true, true):
            fatalError("Ever get here?")
            extra = .withTownAndHero(.init(
                createHeroAtStartingTown: createHeroAtStartingTown,
                startingTownFaction: mainTownFaction,
                startingTownPosition: mainTownPosition,
                startingHeroIsRandom: startingHeroIsRandom,
                startingHeroID: startingHeroIDRaw,
                startingHeroFace: startingHeroFace.rawValue,
                startingHeroName: startingHeroName!
            )
            )
        }
        
        return extra
        
    }
    
}
