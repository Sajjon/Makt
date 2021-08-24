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
        
        guard definitions.objectAttributes.count <= objectCount else {
            throw Error.expectedDefinitionCountToBeLessThanOrEqualToObjectCount
        }
        
        print("🤡 objectCount: \(objectCount), definitions.objectAttributes.count: \(definitions.objectAttributes.count)")
        
        let objects: [Map.Object] = try objectCount.nTimes {
            let position = try reader.readPosition()
            
            /// Index in just previously parse `definitions: Map.Definitions`
            let definitionIndex = try reader.readUInt32()
            print("🤡 definitionIndex: \(definitionIndex)")
            
            guard
                definitionIndex < definitions.objectAttributes.count
            else {
                fatalError("definitionIndex too large: \(definitionIndex)")
//                throw Error.unknownObjectDefintion(
//                    indexTooLarge: .init(definitionIndex),
//                    haveOnlyParsedDefinitionArrayOfLength: definitions.objectAttributes.count
//                )
            }
            
            let definition = definitions.objectAttributes[.init(definitionIndex)]
            
            try reader.skip(byteCount: 5) // unknown
            
            let objectKind: Map.Object.Kind
            switch definition.objectID.class {
            case .abandonedMine: fatalError("abandoned mine")
            
            case .artifact:
                let (message, guards) = try parseMessageAndGuards(format: format)
                let artifact: Artifact
                if case let .spellScroll(expectedSpellScrollID) = definition.objectID {
                    let spellIDParsed = try Spell.ID(integer: reader.readUInt32())
                    assert(spellIDParsed == expectedSpellScrollID)
                    artifact = .scroll(spell: spellIDParsed)
                } else if case let .artifact(expectedArtifactID) = definition.objectID {
                    artifact = .init(id: expectedArtifactID)
                } else {
                    fatalError("unhandled artifact object: \(definition.objectID)")
                }
                let guardedArtifact = Map.GuardedArtifact(message: message, guards: guards, artifact: artifact)
                objectKind = .artifact(guardedArtifact)
            case .dwelling: fatalError("dwelling")
            case .event:
                objectKind = try .event(parseEvent(format: format))
            case .garrison:
                fatalError("read garrison")
                
            case .genericBoat, .genericImpassableTerrain, .genericPassableTerrain, .genericTreasure, .genericVisitable, .monolithTwoWay, .subterraneanGate:
                // Generic objects have no body, nothing to parse.
                objectKind = .generic
            case .grail:
                fatalError("grail")
            case .hero:
                guard case let .hero(heroID) = definition.objectID else { fatalError("incorrect") }
                objectKind = try .hero(
                    parseHero(
                        format: format,
                        predefinedHeroes: predefinedHeroes,
                        disposedHeroes: disposedHeroes,
                        heroID: heroID
                    )
                )
            case .lighthouse:
                fatalError("lighthouse")
            case .monster:
                switch definition.objectID {
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
                default: fatalError("incorrect impl")
                }
            case .oceanBottle: fatalError("oceanBottle")
            case .pandorasBox:  fatalError("oceanBottle")
            case .placeholderHero:  fatalError("placeholderHero")
                
            case .randomHero: fallthrough
            case .prison:
                objectKind = try .hero(
                                parseRandomHero(
                                    format: format
                                )
                            )
                
            case .questGuard: fatalError("questGuard")
            case .randomDwelling: fatalError("questGuard")
            case .randomDwellingOfFaction: fatalError("randomDwellingOfFaction")
            case .randomDwellingAtLevel: fatalError("randomDwellingAtLevel")
            case .resource:
                guard case let .resource(resourceKind) = definition.objectID else { fatalError("incorrect") }
                let (message, guards) = try parseMessageAndGuards(format: format)
                let quantityBase = try reader.readUInt32()
                try reader.skip(byteCount: 4)
                print("✨ quantuityBase: \(quantityBase)")
                // Gold is always multiplied by 100
                let amount = Resource.Amount(resourceKind == .gold ? quantityBase * 100 : quantityBase)
                let resource = Resource(kind: resourceKind, amount: amount)
                let guardedResource = Map.GuardedResource(message: message, guards: guards, resource: resource)
                objectKind = .resource(guardedResource)
            case .resourceGenerator:
                guard case let .mine(mineKind) = definition.objectID else { fatalError("incorrect") }
                let mine = try Map.Mine(kind: mineKind, owner: .init(rawValue: reader.readUInt8()))
                try reader.skip(byteCount: 3)
                objectKind = .mine(mine)
            case .scholar: fatalError("scholar")
            case .seersHut:  fatalError("seersHut")
            case .shipyard: fatalError("shipyard")
            case .shrine: fatalError("shrine")
            case .sign: fatalError("sign")
            case .spellScroll: fatalError("spellScroll")
            case .town:
                if case let .town(faction) = definition.objectID {
                    objectKind = try .town(
                        parseTown(
                            format: format,
                            faction: faction,
                            allowedSpellsOnMap: allowedSpellsOnMap
                        )
                    )
                } else {
                    assert(definition.objectID == .randomTown)
                    objectKind = try .town(
                        parseRandomTown(
                            format: format,
                            allowedSpellsOnMap: allowedSpellsOnMap
                        )
                    )
                }
            case .witchHut: fatalError("witchHut")
            }
            
            let mapObject = Map.Object(
                position: position,
                objectID: definition.objectID,
                kind: objectKind
            )
            
            print("🔮 successfully parse mapObject: \(mapObject)")
            
            return mapObject
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
    
    public init(creatureStackAtSlot: [Slot: CreatureStack], formation: Formation?) {
        self.creatureStackAtSlot = creatureStackAtSlot
        self.formation = formation
    }
    
    public init(creatureStacks: CreatureStacks, formation: Formation?) {
        self.init(
            creatureStackAtSlot: Dictionary(
                uniqueKeysWithValues: Army.Slot.allCases.enumerated().map({ (key: $0.element, value: creatureStacks.creatureStacks[$0.offset] ) })
            ),
            formation: formation
        )
    }
}

public struct CreatureStacks: Hashable {
    public let creatureStacks: [CreatureStack]
}


// TODO: Extract to separate another (separate?) file?
internal extension Map.Loader.Parser.H3M {
    func parseResources() throws -> Resources {
        let resources: [Resource] = try Resource.Kind.allCases.map { kind in
            try .init(kind: kind, amount: .init(reader.readUInt32()))
        }
        return .init(resources: resources)
    }
    

    
    func parseSpellCountAndIDs() throws -> [Spell.ID] {
        try reader.readUInt8().nTimes {
            try Spell.ID(integer: reader.readInt8())
        }
    }
}

