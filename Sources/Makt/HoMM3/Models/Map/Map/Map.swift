//
//  Map.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public struct Map: Equatable, Identifiable {
    public let checksum: UInt32
    
    /// Name, description, size, difficulty etc.
    public let basicInformation: BasicInformation
    
    
    public let playersInfo: InformationAboutPlayers
    
    /// Victory/Loss conditions, teams, rumors, hero settings, SOD: avaiable skills/artifacts/spells etc.
    public let additionalInformation: AdditionalInformation
    
    public let world: World
    
    public let attributesOfObjects: Map.AttributesOfObjects
    public let detailsAboutObjects: Map.DetailsAboutObjects
    public let globalEvents: Map.TimedEvents
}


extension Map {
    
    /// Reader, parser and caching of maps from disc.
    ///
    /// `internal` access modifier so that it can be tested.
    internal static let loader = Loader.shared
}


// MARK: Identifiable
public extension Map {
    var id: ID { basicInformation.id }
}

// MARK: Load
public extension Map {
    
    static func load(
        _ mapID: Map.ID,
        inspector: Map.Loader.Parser.Inspector? = nil
    ) throws -> Map {
        try loader.load(id: mapID, inspector: inspector)
    }
}

