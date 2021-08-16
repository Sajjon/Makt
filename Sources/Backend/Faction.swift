//
//  Faction.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation
public enum Faction: Int, Equatable, CaseIterable {
    case castle, rampart, tower, inferno, necropolis, dungeon, stronghold, fortress, conflux, neutral
    private static let playableInShadowOfDeath: [Self] = {
        var factions = Self.allCases
        factions.removeAll(where: { $0 == .neutral })
        return factions
    }()
    private static let playableInRestorationOfErathia: [Self] = {
        var factions = Self.playableInShadowOfDeath
        factions.removeAll(where: { $0 == .conflux })
        return factions
    }()
    
    public static func playable(in format: Map.Format) -> [Self] {
        switch format {
        case .armageddonsBlade, .restorationOfErathia: return Self.playableInRestorationOfErathia
        case .shadowOfDeath, .hornOfTheAbyss, .wakeOfGods: return Self.playableInShadowOfDeath
        }
    }
}
