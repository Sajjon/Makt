//
//  Map+Object+Kind+FromIDs.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation



public extension Map.Object.ID {
   
    enum Error: Swift.Error {
        case unrecognizedObjectClassIdentifier(Stripped.RawValue)
    }
    
    init(id: UInt32, subId: UInt32) throws {
        guard let stripped = Stripped(rawValue: id) else {
            throw Error.unrecognizedObjectClassIdentifier(id)
        }
        try self.init(stripped: stripped, subId: subId)
    }
}

private extension Map.Object.ID {
    init(stripped: Stripped, subId: UInt32) throws {
   
        switch stripped {
        case .artifact:
            let artifactID = try Artifact.ID(fittingIn: subId)
            self = .artifact(artifactID)
        case .borderguard:
            fatalError()
        case .keymastersTent:
            fatalError()
        case .creatureBank:
            fatalError()
        case .creatureGenerator1:
            fatalError()
        case .creatureGenerator4:
            fatalError()
        case .garrison:
            fatalError()
        case .hero:
            fatalError()
        case .monolithOneWayEntrance:
            fatalError()
        case .monolithOneWayExit:
            fatalError()
        case .monolithTwoWay:
            fatalError()
        case .mine:
            fatalError()
        case .monster:
            fatalError()
        case .spellScroll:
            fatalError()
        case .town:
            fatalError()
        case .witchHut:
            fatalError()
        case .borderGate:
            fatalError()
        case .randomDwellingWithLevel:
            fatalError()
        case .randomDwellingFactoion:
            fatalError()
        default:
            fatalError("TODO handle stripped with no sub id")
        }
    }
}
