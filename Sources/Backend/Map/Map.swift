//
//  Map.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-15.
//

import Foundation

public struct Map: Equatable, Identifiable {

    public let about: About
    public let playersInfo: PlayersInfo
    public let victoryLossConditions: VictoryLossConditions
    public let teamInfo: TeamInfo
    public let allowedHeroes: AllowedHeroes
}

extension Map {
    
    /// Reader, parser and caching of maps from disc.
    ///
    /// `internal` access modifier so that it can be tested.
    internal static let loader = Loader.shared
    
}

// MARK: Public


// MARK: Identifiable
public extension Map {
    var id: ID { about.id }
}

// MARK: Load
public extension Map {
    
    static func load(_ mapID: Map.ID) throws -> Map {
        try loader.load(id: mapID)
    }
}

