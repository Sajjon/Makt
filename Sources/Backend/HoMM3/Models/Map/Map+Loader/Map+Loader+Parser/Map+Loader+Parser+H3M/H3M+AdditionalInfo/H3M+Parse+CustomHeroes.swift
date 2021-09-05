//
//  H3M+Parse+CustomHeroes.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-28.
//

import Foundation

// MARK: Parse Custom Heros
extension Map.Loader.Parser.H3M {
    
    func parseCustomHeroes(format: Map.Format, availablePlayers: [PlayerColor]) throws -> Map.AdditionalInformation.CustomHeroes? {
        guard format >= .shadowOfDeath else { return nil }
        let customHeroes: [Map.AdditionalInformation.CustomHero] = try reader.readUInt8().nTimes {
            let heroIdRaw = try reader.readUInt8()
            let heroId = heroIdRaw != 0xff ? try Hero.ID(integer: heroIdRaw) : nil
            let portraitIdRaw = try reader.readUInt8()
            let portraitID = portraitIdRaw != 0xff ? try Hero.ID(integer: portraitIdRaw) : nil
            let name = try reader.readString()
            
            let allowedPlayers = try parseAllowedPlayers(availablePlayers: availablePlayers)
            
            let customHero = Map.AdditionalInformation.CustomHero(
                heroId: heroId,
                portraitID: portraitID,
                name: name,
                allowedPlayers: allowedPlayers
            )
            return customHero
        }
        
        return .init(customHeroes: customHeroes)
    }
}
