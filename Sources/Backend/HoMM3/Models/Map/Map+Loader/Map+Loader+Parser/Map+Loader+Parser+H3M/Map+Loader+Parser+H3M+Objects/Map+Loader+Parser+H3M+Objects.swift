//
//  Map+Loader+Parser+H3M+Objects.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation

internal extension Map.Loader.Parser.H3M {
    
    func parseObjects(
        format: Map.Format,
        definitions: Map.Definitions,
        allowedSpellsOnMap: [Spell.ID],
        predefinedHeroes: [Hero.Predefined],
        disposedHeroes: [Hero.Disposed]
    ) throws -> Map.Objects {
        
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
                objectKind = try .hero(
                    parseHero(
                        format: format,
                        predefinedHeroes: predefinedHeroes,
                        disposedHeroes: disposedHeroes,
                        heroID: heroID
                    )
                )
                
            case .prison: fallthrough
            case .randomHero:
                objectKind = try .hero(
                    parseRandomHero(
                        format: format
                    )
                )
                
            case .randomTown:
                objectKind = try .town(
                    parseRandomTown(
                        format: format,
                        allowedSpellsOnMap: allowedSpellsOnMap
                    )
                )
            case .town(let faction):
                objectKind = try .town(
                    parseTown(
                        format: format,
                        faction: faction,
                        allowedSpellsOnMap: allowedSpellsOnMap
                    )
                )
                
            case .monster(let creatureID):
                objectKind = try .monster(
                    parseMonster(format: format, creatureID: creatureID)
                )
            case .randomMonsterLevel1:
                objectKind = try .monster(
                    parseRandomMonster(format: format, level: .one)
                )
            case .randomMonsterLevel2:
                objectKind = try .monster(
                    parseRandomMonster(format: format, level: .two)
                )
            case .randomMonsterLevel3:
                objectKind = try .monster(
                    parseRandomMonster(format: format, level: .three)
                )
            case .randomMonsterLevel4:
                objectKind = try .monster(
                    parseRandomMonster(format: format, level: .four)
                )
            case .randomMonsterLevel5:
                objectKind = try .monster(
                    parseRandomMonster(format: format, level: .five)
                )
            case .randomMonsterLevel6:
                objectKind = try .monster(
                    parseRandomMonster(format: format, level: .six)
                )
            case .randomMonsterLevel7:
                objectKind = try .monster(
                    parseRandomMonster(format: format, level: .seven)
                )
            case .randomMonster:
                objectKind = try .monster(
                    parseRandomMonster(format: format)
                )
                
            default: fatalError("Not yet parsable event id: \(definition.objectID)")
            }
            
            return .init(
                position: position,
                objectID: definition.objectID,
                kind: objectKind
            )
        }
        return .init(objects: objects)
    }
}

public struct CreatureStack: Hashable {
    public typealias Quantity = Int
    public let creatureID: Creature.ID
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
    public let creatureStackAtSlot: [Slot: CreatureStack]
    public let formation: Formation?
}

public struct CreatureStacks: Hashable {
    public let creatureStacks: [CreatureStack]
}

// TODO: Extract to separate another (separate?) file?
internal extension Map.Loader.Parser.H3M {
    func parseCreatureStacks(count: Int = Army.Slot.allCases.count) throws -> CreatureStacks {
        fatalError()
    }
    
    func parseCreatureStacks() throws -> CreatureStacks? {
        let count: Int = try .init(reader.readUInt8())
        guard count > 0 else { return nil }
        return try parseCreatureStacks(count: count)
    }
    
    func parseArmyOf(size: Int = Army.Slot.allCases.count, parseFormation: Bool) throws -> Army {
        let creatureStacks = try parseCreatureStacks(count: size)
        
        let formation: Army.Formation? = !parseFormation ? nil : try Army.Formation(integer: reader.readUInt8())
        
        return .init(
            creatureStackAtSlot: Dictionary(
                uniqueKeysWithValues: Army.Slot.allCases.enumerated().map({ (key: $0.element, value: creatureStacks.creatureStacks[$0.offset] ) })
            ),
            formation: formation
        )
    }
    
    func parseArmy(parseFormation: Bool) throws -> Army? {
        let size: Int = try .init(reader.readUInt8())
        guard size > 0 else { return nil }
        return try parseArmyOf(size: size, parseFormation: parseFormation)
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
    
    func parseSpellCountAndIDs() throws -> [Spell.ID] {
        try reader.readUInt8().nTimes {
            try Spell.ID(integer: reader.readInt8())
        }
    }
}

