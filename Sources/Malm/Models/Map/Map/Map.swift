//
//  Map.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public struct Map: Hashable, Identifiable, Codable {
    public let checksum: UInt32
    
    /// Name, description, size, difficulty etc.
    public let basicInformation: BasicInformation
    
    public let playersInfo: InformationAboutPlayers
    
    /// Victory/Loss conditions, teams, rumors, hero settings, SOD: avaiable skills/artifacts/spells etc.
    public let additionalInformation: AdditionalInformation
    
    public let world: World
    
    public let attributesOfObjects: Map.AttributesOfObjects
    public let detailsAboutObjects: Map.DetailsAboutObjects
    public let globalEvents: Map.TimedEvents?
    
    public init(
        checksum: UInt32,
        basicInformation: BasicInformation,
        playersInfo: InformationAboutPlayers,
        additionalInformation: AdditionalInformation,
        world: World,
        attributesOfObjects: Map.AttributesOfObjects,
        detailsAboutObjects: Map.DetailsAboutObjects,
        globalEvents: Map.TimedEvents?
    ) {
        self.checksum = checksum
        self.basicInformation = basicInformation
        self.playersInfo = playersInfo
        self.additionalInformation = additionalInformation
        self.world = world
        self.attributesOfObjects = attributesOfObjects
        self.detailsAboutObjects = detailsAboutObjects
        self.globalEvents = globalEvents
    }
}



// MARK: Identifiable
public extension Map {
    var id: ID { basicInformation.id }
    
    static let fileExtension = "h3m"
    static let fileExtensionTutorialMap = "tut"
}

