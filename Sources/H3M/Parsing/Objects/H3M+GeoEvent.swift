//
//  Map+Loader+Parser+H3M+Object+Event.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation
import Malm


// MARK: Parse Event
internal extension Map.Loader.Parser.H3M {
    
    func parseGeoEvent(format: Map.Format, availablePlayers: [Player]) throws -> Map.GeoEvent {
        let pandorasBox = try parsePandorasBox(format: format)
        
        let playersAllowedToTriggerThisEvent = try parseAllowedPlayers(availablePlayers: availablePlayers)
        let canBeTriggeredByComputerOpponent = try reader.readBool()
        let cancelEventAfterFirstVisit = try reader.readBool()
        try reader.skip(byteCount: 4) // unknown?
        
        return .init(
            message: pandorasBox.message,
            guardians: pandorasBox.guardians,
            contents: pandorasBox.bounty,
            playersAllowedToTriggerThisEvent: playersAllowedToTriggerThisEvent,
            canBeTriggeredByComputerOpponent: canBeTriggeredByComputerOpponent,
            cancelEventAfterFirstVisit: cancelEventAfterFirstVisit
        )
    }
    
}
