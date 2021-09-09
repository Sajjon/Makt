//
//  Map+Loader+Parser+H3M+Object+Event.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation


// MARK: Parse Event
internal extension Map.Loader.Parser.H3M {
    
    func parseMessageAndGuards(format: Map.Format) throws -> (message: String?, guards: CreatureStacks?) {
        let hasMessage = try reader.readBool()
        /// Fan map "Cloak of the Undead King" has >29000 bytes long mesg...
        let message: String? = try hasMessage ? reader.readString(maxByteCount: 32768) : nil
        let guards: CreatureStacks? = try hasMessage ? {
            let hasGuardsAsWell = try reader.readBool()
            var guards: CreatureStacks?
            if hasGuardsAsWell {
                guards = try parseCreatureStacks(format: format, count: 7)
            }
            try reader.skip(byteCount: 4) // unknown?
            return guards
        }() : nil
        return (message, guards)
    }
    
    func parseGeoEvent(format: Map.Format, availablePlayers: [Player]) throws -> Map.GeoEvent {
        let pandorasBox = try parsePandorasBox(format: format)
        
        let playersAllowedToTriggerThisEvent = try parseAllowedPlayers(availablePlayers: availablePlayers)
        let canBeTriggeredByComputerOpponent = try reader.readBool()
        let cancelEventAfterFirstVisit = try reader.readBool()
        try reader.skip(byteCount: 4) // unknown?
        
        return .init(
            message: pandorasBox.message,
            guardians: pandorasBox.guards,
            contents: pandorasBox.bounty,
            playersAllowedToTriggerThisEvent: playersAllowedToTriggerThisEvent,
            canBeTriggeredByComputerOpponent: canBeTriggeredByComputerOpponent,
            cancelEventAfterFirstVisit: cancelEventAfterFirstVisit
        )
    }
    
}
