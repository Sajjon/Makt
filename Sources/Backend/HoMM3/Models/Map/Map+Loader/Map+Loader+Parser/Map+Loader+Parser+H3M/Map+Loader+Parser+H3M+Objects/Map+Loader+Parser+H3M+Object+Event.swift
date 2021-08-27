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
        let message: String? = try hasMessage ? reader.readString() : nil
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
    
    func parseEvent(format: Map.Format) throws -> Map.Event {
        let pandorasBox = try parsePandorasBox(format: format)
        
        try reader.skip(byteCount: 8) // unknown?
        let availableForPlayers = try parseAvailableForPlayers()
        let canBeActivatedByComputer = try reader.readBool()
        let shouldBeRemovedAfterVisit = try reader.readBool()
        try reader.skip(byteCount: 4) // unknown?
        
        return .init(
             pandorasBox: pandorasBox,
            availableForPlayers: availableForPlayers,
            canBeActivatedByComputer: canBeActivatedByComputer,
            shouldBeRemovedAfterVisit: shouldBeRemovedAfterVisit,
            canBeActivatedByHuman: true // yes hardcoded
        )
        
    }
    
}
