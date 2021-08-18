//
//  Faction.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation
public enum Faction: Int, Equatable, CaseIterable, CustomStringConvertible {
    case castle, rampart, tower, inferno, necropolis, dungeon, stronghold, fortress, conflux, neutral
}

// MARK: CustomStringConvertible
public extension Faction {
    var description: String {
        switch self {
        case .castle: return "castle"
        case .rampart: return "rampart"
        case .tower: return "tower"
        case .inferno: return "inferno"
        case .necropolis: return "necropolis"
        case .dungeon: return "dungeon"
        case .stronghold: return "stronghold"
        case .fortress: return "fortress"
        case .conflux: return "conflux"
        case .neutral: return "neutral"
        }
    }
}

public extension Faction {
    
    static func playable(in format: Map.Format) -> [Self] {
        switch format {
        case .armageddonsBlade, .restorationOfErathia: return Self.playableInRestorationOfErathia
        #if HOTA
        case .hornOfTheAbyss: fallthrough
        #endif // HOTA
        
        #if WOG
        case wakeOfGods: fallthrough
        #endif // WOG
        case .shadowOfDeath:
            return Self.playableInShadowOfDeath
        }
    }
    
    
}

private extension Faction {
    
    static let playableInShadowOfDeath: [Self] = {
        var factions = Self.allCases
        factions.removeAll(where: { $0.rawValue >= Self.neutral.rawValue })
        return factions
    }()
    
    static let playableInRestorationOfErathia: [Self] = {
        var factions = Self.playableInShadowOfDeath
        factions.removeAll(where: { $0.rawValue >= Self.conflux.rawValue })
        return factions
    }()
    
}
