//
//  H3M+Parse+CustomHeroes.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-28.
//

import Foundation

// MARK: Parse Custom Heros
extension Map.Loader.Parser.H3M {
    func parseCustomHeroes(format: Map.Format) throws -> Map.AdditionalInformation.CustomHeroes? {
        guard format >= .shadowOfDeath else { return nil }
        let customHeroes: [Map.AdditionalInformation.CustomHero] = try reader.readUInt8().nTimes {
            let heroClass = try parseHeroClass()!
            let portraitID = try Hero.ID(integer: reader.readUInt8())
            let name = try reader.readString()
            
            let availableForPlayers = try parseAvailableForPlayers()
            
            return .init(
                heroClass: heroClass,
                portraitID: portraitID,
                name: name,
                availableForPlayers: availableForPlayers
            )
        }
        
        return .init(customHeroes: customHeroes)
    }
}
