//
//  Map+Loader+Parser+H3M+Objects.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation

internal extension Map.Loader.Parser.H3M {
    
    func parseObjects(format: Map.Format, definitions: Map.Definitions) throws -> Map.Objects {
        
        let objectCount = try reader.readUInt32()
        
        guard objectCount != definitions.objectAttributes.count else {
            throw Error.differentNumberOfObjectsAndDefinitions
        }
        
        let objects: [Map.Object] = try objectCount.nTimes {
            let position = try reader.readPosition()
            
            /// Index in just previously parse `definitions: Map.Definitions`
            let definitionIndex = Int(try reader.readUInt32())
            
            guard
                definitionIndex < definitions.objectAttributes.count
            else {
                throw Error.unknownObjectDefintion(
                    indexTooLarge: definitionIndex,
                    haveOnlyParsedDefinitionArrayOfLength: definitions.objectAttributes.count
                )
            }
            
            let definition = definitions.objectAttributes[definitionIndex]
            
            try reader.skip(byteCount: 5) // unknown
            
            let objectKind: Map.Object.Kind
            switch definition.objectID {
            case .event:
                objectKind = try .event(parseEvent(format: format))
            case .hero(let heroID):
                fatalError("todo parse")
            case .randomHero:
                fatalError("todo parse")
            default: fatalError("todo all")
            }
            
            return .init(
                position: position,
                kind: objectKind
            )
        }
        return .init(objects: objects)
    }
}

public struct CreatureStack: Hashable {
    public typealias Quantity = Int
    public let creature: Creature
    public let quantity: Quantity
}

public struct Army: Hashable {
    public enum Slot: UInt8, Hashable, CaseIterable {
        case one = 0
        case two
        case three
        case four
        case five
        case six
        case seven
    }
    public enum Formation: UInt8, Hashable, CaseIterable {
        case wide, tight
    }
    public let creatureStacks: [Slot: CreatureStack]
}

// TODO: Extract to separate another (separate?) file?
internal extension Map.Loader.Parser.H3M {
    func parseArmyOf(size: Int = Army.Slot.allCases.count) throws -> Army {
        fatalError()
    }
    
    func parseArmy() throws -> Army? {
        let size: Int = try .init(reader.readUInt8())
        guard size > 0 else { return nil }
        return try parseArmyOf(size: size)
    }
}

// TODO: Extract to separate another (separate?) file?
internal extension Map.Loader.Parser.H3M {
    func parseResources() throws -> Resources {
        let resources: [Resource] = try Resource.Kind.allCases.map { kind in
            try .init(kind: kind, amount: .init(reader.readUInt32()))
        }
        return .init(resources: resources)
    }
    
    func parseArtifactIDs(format: Map.Format) throws -> [Artifact.ID] {
        try reader.readUInt8().nTimes {
            try Artifact.ID(integer: format == .restorationOfErathia ? reader.readUInt8() : UInt8(reader.readUInt16()))
        }
    }
    
    func parseSpellIDs() throws -> [Spell.ID] {
        try reader.readUInt8().nTimes {
            try Spell.ID(integer: reader.readInt8())
        }
    }
}



// MARK: Parse Event
private extension Map.Loader.Parser.H3M {
    func parseEvent(format: Map.Format) throws -> Map.Event {
        let hasMessage = try reader.readBool()
        let message: String? = try !hasMessage ? nil : reader.readString()
        let guards: Army? = try !hasMessage ? nil : {
            let hasGuardsAsWell = try reader.readBool()
            var guards: Army?
            if hasGuardsAsWell {
                guards = try parseArmy()
            }
            try reader.skip(byteCount: 4) // unknown?
            return guards
        }()
        let experiencePointsToBeGained = try reader.readUInt32()
        let manaPointsToBeGainedOrDrained = try reader.readUInt32()
        let moraleToBeGainedOrDrained = try reader.readUInt8()
        let luckToBeGainedOrDrained = try reader.readUInt8()
        let resourcesToBeGained = try parseResources()
        let primarySkills = try parsePrimarySkills()
        let secondarySkills = try parseSecondarySkills()
        let artifactIDs = try parseArtifactIDs(format: format)
        let spellIDSs = try parseSpellIDs()
        let armyGained = try parseArmy()
        
        try reader.skip(byteCount: 8) // unknown?
        let availableForPlayers = try parseAvailableForPlayers()
        let canBeActivatedByComputer = try reader.readBool()
        let shouldBeRemovedAfterVisit = try reader.readBool()
        try reader.skip(byteCount: 4) // unknown?
        
        return .init(
            message: message,
            guards: guards,
            experiencePointsToBeGained: .init(experiencePointsToBeGained),
            manaPointsToBeGainedOrDrained: .init(manaPointsToBeGainedOrDrained),
            moraleToBeGainedOrDrained: .init(moraleToBeGainedOrDrained),
            luckToBeGainedOrDrained: .init(luckToBeGainedOrDrained),
            resourcesToBeGained: resourcesToBeGained,
            primarySkills: primarySkills,
            secondarySkills: secondarySkills,
            artifactIDs: artifactIDs,
            spellIDs: spellIDSs,
            armyGained: armyGained,
            availableForPlayers: availableForPlayers,
            canBeActivatedByComputer: canBeActivatedByComputer,
            shouldBeRemovedAfterVisit: shouldBeRemovedAfterVisit,
            canBeActivatedByHuman: true // yes hardcoded
        )
        
    }
    
}
