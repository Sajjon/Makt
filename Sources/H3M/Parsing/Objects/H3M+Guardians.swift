//
//  Map+Loader+Parser+H3M+Object+Event.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation
import Malm


// MARK: Parse Event
internal extension H3M {
    
    func parseMessageAndGuardians(format: Map.Format) throws -> (message: String?, guardians: CreatureStacks?) {
        let hasMessage = try reader.readBool()
        /// Fan map "Cloak of the Undead King" has >29000 bytes long mesg...
        let message: String? = try hasMessage ? reader.readString(maxByteCount: 32768) : nil
        let guardians: CreatureStacks? = try hasMessage ? {
            let hasGuardiansAsWell = try reader.readBool()
            var guardians: CreatureStacks?
            if hasGuardiansAsWell {
                guardians = try parseCreatureStacks(format: format, count: 7)
            }
            try reader.skip(byteCount: 4) // unknown?
            return guardians
        }() : nil
        return (message, guardians)
    }    
}
