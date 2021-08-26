//
//  Map+Loader+Parser+H3M+Objects.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation

public struct Quest: Hashable {
    
    /// An identifier identifying some object/entity relating to this quest, e.g. a quest identifier for an hero (not Hero.ID (?)) or for a wandering monster (not just a Creature.ID).
    public struct Identifier: Hashable {
        public let id: UInt32
    }
    
    public let kind: Kind
    
    public struct Messages: Hashable {
        public let firstVisitText: String?
        public let nextVisitText: String?
        public let completedText: String?
        
        public init?(
            firstVisitText: String?,
            nextVisitText: String?,
            completedText: String?
        ) {
            guard !(firstVisitText == nil && nextVisitText == nil && completedText == nil) else {
                return nil
            }
            self.firstVisitText = firstVisitText
            self.nextVisitText = nextVisitText
            self.completedText = completedText
        }
    }
    
    public let messages: Messages?
    
    /// last day, `nil` means no deadline
    public let deadline: Int?
    
    public enum Kind: Hashable {
        case reachPrimarySkillLevels([Hero.PrimarySkill])
        case reachHeroLevel(Int)
        case killHero(Identifier)
        
        case killCreature(Identifier)
        
        case acquireArtifacts([Artifact.ID])
        case raiseArmy(CreatureStacks)
        case acquireResources(Resources)
        case beHero(Hero.ID)
        case bePlayer(PlayerColor)
    }
}

public extension Map {
    struct Seershut: Hashable {
        public let quest: Quest?
        public let bounty: Bounty?
        
        static let empty: Self = .init(quest: nil, bounty: nil)
        
        
        public enum Bounty: Hashable {
            case experience(UInt32)
            case manaPoints(UInt32)
            case moraleBonus(UInt8)
            case luckBonus(UInt8)
            case resource(Resource)
            case primarySkill(Hero.PrimarySkill)
            case secondarySkill(Hero.SecondarySkill)
            case artifact(Artifact.ID)
            case spell(Spell.ID)
            case creature(CreatureStack)
            case aquireKey(Map.Object.KeymastersTentType)
        }
    }
}

public extension Quest.Kind {
    
    enum Stripped: UInt8, Hashable, CaseIterable {
        case reachHeroLevel = 1
        case reachPrimarySkillLevels
        case killHero
        case killCreature
        case acquireArtifacts
        case raiseArmy
        case acquireResources
        case beHero
        case bePlayer
        case aquireKey
    }
    
}

public extension Map.Seershut.Bounty {
    
    enum Stripped: UInt8, Hashable, CaseIterable {
        case experience
        case manaPoints
        case moraleBonus
        case luckBonus
        case resource
        case primarySkill
        case secondarySkill
        case artifact
        case spell
        case creature
    }
}

internal extension Map.Loader.Parser.H3M {
    
    func parseQuest() throws -> Quest {
        let questKindStripped = try Quest.Kind.Stripped(integer: reader.readUInt8())
        let questKind: Quest.Kind
        switch questKindStripped {
        case .reachPrimarySkillLevels:
            questKind = try .reachPrimarySkillLevels(parsePrimarySkills())
        case .reachHeroLevel:
            questKind = try .reachHeroLevel(.init(reader.readUInt32()))
        case .killHero:
            questKind = try .killHero(Quest.Identifier(id: reader.readUInt32()))
        case .killCreature:
            questKind = try .killCreature(Quest.Identifier(id: reader.readUInt32()))
        case .acquireArtifacts:
            // For some reason the artifact IDs in the Quest is ALWAYS represented as UInt16, thus we hardcode `shadowOfDeath` as map format which will result in UInt16s being read as rawValue for each artifact.
            questKind = try .acquireArtifacts(parseArtifactIDs(format: .shadowOfDeath))
        case .raiseArmy:
            // For some reason the creature IDs in the Quest is ALWAYS represented as UInt16, thus we hardcode `shadowOfDeath` as map format which will result in UInt16s being read as rawValue for each creature type.
            questKind  = try .raiseArmy(parseCreatureStacks(format: .shadowOfDeath, count: reader.readUInt8())!)
        case .acquireResources:
            questKind = try .acquireResources(parseResources())
        case .beHero:
            questKind = try .beHero(.init(integer: reader.readUInt8()))
        case .bePlayer:
            questKind = try .bePlayer(.init(integer: reader.readUInt8()))
        case .aquireKey:
            fatalError("Did not expect to parse quest acquire key here...")
        }
        
        let limit = try reader.readUInt32()
        let deadline: Int? = limit == .max ? nil : .init(limit)
        
        let firstVisitTextOrEmpty = try reader.readString()
        let nextVisitTextOrEmpty = try reader.readString()
        let completedTextOrEmpty = try reader.readString()
        
        let firstVisitText: String? = firstVisitTextOrEmpty.isEmpty ? nil : firstVisitTextOrEmpty
        let nextVisitText: String? = nextVisitTextOrEmpty.isEmpty ? nil : nextVisitTextOrEmpty
        let completedText: String? = completedTextOrEmpty.isEmpty ? nil : completedTextOrEmpty
        
        return .init(
            kind: questKind,
            messages: .init(
                firstVisitText: firstVisitText,
                nextVisitText: nextVisitText,
                completedText: completedText
            ),
            deadline: deadline
        )
    }
    
    func parseObjects(
        inspector: Map.Loader.Parser.Inspector? = nil,
        format: Map.Format,
        definitions: Map.Definitions,
        allowedSpellsOnMap: [Spell.ID],
        predefinedHeroes: [Hero.Predefined],
        disposedHeroes: [Hero.Disposed]
    ) throws -> Map.Objects {
        
        let objectCount = try reader.readUInt32()
        
        print("🤡 objectCount: \(objectCount), definitions.objectAttributes.count: \(definitions.objectAttributes.count)")
        guard definitions.objectAttributes.count <= objectCount else {
            throw Error.expectedDefinitionCountToBeLessThanOrEqualToObjectCount
        }
        
        
        var objects = [Map.Object]()
        for objectIndex in 0..<objectCount {
            if let maxObjectsToParse = inspector?.settings.maxObjectsToParse, (objectIndex + 1) > maxObjectsToParse {
                break
            }
            print("🔮 objectIndex: \(objectIndex)")
            let position = try reader.readPosition()
            
            /// Index in just previously parse `definitions: Map.Definitions`
            let definitionIndex = try reader.readUInt32() - 2 // minus two because of [`invisibleHardcodedIntoEveryMapAttribute_RandomMonster`, `invisibleHardcodedIntoEveryMapAttribute_Hole`]
            
            
            
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
            
            print("👻 definition.objectID: \(definition.objectID), class: \(definition.objectID.class)")
            
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
            case .dwelling:
                let ownerRaw = try reader.readUInt8()
                let owner: PlayerColor? = ownerRaw != PlayerColor.neutralRawValue ? try PlayerColor(integer: ownerRaw) : nil
                try reader.skip(byteCount: 3)
                let dwellng = Map.Dwelling(owner: owner, id: definition.objectID)
                objectKind = .dwelling(dwellng)
            case .event:
                objectKind = try .event(parseEvent(format: format))
            case .garrison:
                let owner = try PlayerColor(integer: reader.readUInt8())
                try reader.skip(byteCount: 3)
                let creatures = try parseCreatureStacks(format: format, count: 7)
                let areCreaturesRemovable = try format > .restorationOfErathia ? reader.readBool() : true
                try reader.skip(byteCount: 8)
                let garrison = Map.Garrison(
                    owner: owner,
                    creatures: creatures,
                    areCreaturesRemovable: areCreaturesRemovable
                )
                objectKind = .garrison(garrison)
                
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
                let (message, guards) = try parseMessageAndGuards(format: format)
                let quantityBase = try reader.readUInt32()
                try reader.skip(byteCount: 4)
                
                let resourceKind: Resource.Kind
                if case let .resource(kind) = definition.objectID {
                    resourceKind = kind
                } else {
                    // random
                    resourceKind = .random()
                }
                
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
            case .seersHut:
                
                func bounty() throws -> Map.Seershut.Bounty {
                    
                    let bountyStripped = try Map.Seershut.Bounty.Stripped(
                        integer: reader.readUInt8()
                    )
                    
                    let bounty: Map.Seershut.Bounty
                    
                    switch bountyStripped {
                    case .experience:
                        bounty = try .experience(reader.readUInt32())
                        
                    case .manaPoints:
                        bounty = try .manaPoints(reader.readUInt32())
                        
                    case .moraleBonus:
                        bounty = try .moraleBonus(reader.readUInt8())
                        
                    case .luckBonus:
                        bounty = try .luckBonus(reader.readUInt8())
                        
                    case .resource:
                        let resource = try Resource(
                            kind: .init(integer: reader.readUInt8()),
                            // Only the first 3 bytes are used. Skip the 4th.
                            amount: .init(reader.readUInt32() & 0x00ffffff)
                        )
                        bounty =  .resource(resource)
                        
                    case .primarySkill:
                        let primarySkill = try Hero.PrimarySkill(
                            kind: .init(integer: reader.readInt8()),
                            level: .init(reader.readUInt8())
                        )
                        bounty =  .primarySkill(primarySkill)
                        
                    case .secondarySkill:
                        let secondarySkill = try Hero.SecondarySkill(
                            kind: .init(integer: reader.readInt8()),
                            level: .init(integer: reader.readUInt8())
                        )
                        bounty =  .secondarySkill(secondarySkill)
                        
                    case .artifact:
                        guard let artifactID = try parseArtifactID(format: format) else {
                            fatalError("Expected artifact ID")
                        }
                        bounty = .artifact(artifactID)
                        
                    case .spell:
                        print("🤡 bounty/reward is spell..?")
                        bounty = try .spell(.init(integer: reader.readInt8()))
                        
                    case .creature:
                        let creatureID = try format == .restorationOfErathia ? Creature.ID(integer: reader.readInt8()) : .init(integer: reader.readInt16())
                        
                        bounty = try .creature(
                            .init(creatureID: creatureID,
                                  quantity: .init(reader.readUInt16())
                            )
                        )
                    }
                    return bounty
                }
                
                let seershut: Map.Seershut
                
                if format > .restorationOfErathia {
                    print("🌍 format is AB/SOD => parsing quest")
                    let quest = try parseQuest()
                    print("✅ parsed quest: \(quest)\n\n\nparsing bounty")
                    seershut = try .init(quest: quest, bounty: bounty())
                } else {
                    assert(format == .restorationOfErathia)
                    guard let artifactID = try parseArtifactID(format: format) else {
                        try reader.skip(byteCount: 3)
                        objectKind = .seershut(.empty)
                        break
                    }
                    seershut = try Map.Seershut(
                        quest: .init(
                            kind: Quest.Kind.acquireArtifacts([artifactID]),
                            messages: nil,
                            deadline: nil
                        ),
                        bounty: bounty()
                    )
                }
                try reader.skip(byteCount: 2)
                objectKind = .seershut(seershut)
            case .shipyard:
                let ownerRaw = try reader.readUInt8()
                let owner: PlayerColor? = ownerRaw != PlayerColor.neutralRawValue ? try PlayerColor(integer: ownerRaw) : nil
                try reader.skip(byteCount: 3)
                let shipyard = Map.Shipyard(owner: owner)
                objectKind = .shipyard(shipyard)
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
                attributes: definition,
                kind: objectKind
            )
            
            print("🔮 successfully parse mapObject: \(mapObject)")
            
            inspector?.didParseObject(mapObject)
            objects.append(mapObject)
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
                uniqueKeysWithValues: Army.Slot.allCases.enumerated().map({
                    let key = $0.element
                    print("🤡 $0.element: \($0.element), $0.offset: \($0.offset), creatureStacks.count: \(creatureStacks.creatureStacks.count)")
                    let value = creatureStacks.creatureStacks[$0.offset]
                    return (key: key, value: value)
                })
            ),
            formation: formation
        )
    }
}

public struct CreatureStacks: Hashable {
    public let creatureStacks: [CreatureStack]
    public init?(creatureStacks: [CreatureStack]) {
        guard creatureStacks.count > 0 else {
            return nil
        }
        self.creatureStacks = creatureStacks
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
    
    func parseSpellCountAndIDs() throws -> [Spell.ID] {
        try reader.readUInt8().nTimes {
            try Spell.ID(integer: reader.readInt8())
        }
    }
}

