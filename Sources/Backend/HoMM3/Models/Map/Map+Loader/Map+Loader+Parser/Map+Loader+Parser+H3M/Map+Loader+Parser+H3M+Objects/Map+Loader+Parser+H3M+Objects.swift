//
//  Map+Loader+Parser+H3M+Objects.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation

func UNUSED(_ any: Any) { /* noop */ }

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
            questKind = try .acquireResources(parseResources()!)
        case .beHero:
            questKind = try .beHero(.init(integer: reader.readUInt8()))
        case .bePlayer:
            questKind = try .bePlayer(.init(integer: reader.readUInt8()))
        case .aquireKey:
            fatalError("Did not expect to parse quest acquire key here...")
        }
        
        let limit = try reader.readUInt32()
        let deadline: Int? = limit == .max ? nil : .init(limit)
        
        // Map "The story of the Fool (Traemask2.h3m") 9697 bytes...
        let maxStringLength: UInt32 = 10_000
        let firstVisitText = try reader.readString(maxByteCount: maxStringLength)
        let nextVisitText = try reader.readString(maxByteCount: maxStringLength)
        let completedText = try reader.readString(maxByteCount: maxStringLength)
        
       
        
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
    
    func parseDetailsAboutObjects(
        inspector: Map.Loader.Parser.Inspector? = nil,
        format: Map.Format,
        playersInfo: Map.InformationAboutPlayers,
        additionalMapInformation: Map.AdditionalInformation,
        attributesOfObjects: Map.AttributesOfObjects
    ) throws -> Map.DetailsAboutObjects {
        let allowedSpellsOnMap = additionalMapInformation.availableSpells?.spells ?? Spell.ID.allCases
        let objectCount = try reader.readUInt32()
        
        var objects = [Map.Object]()
        let maxIndex = attributesOfObjects.attributes.count
        
        for objectIndex in 0..<objectCount {
            
            // START Debugging/Tests only
            if
                let maxObjectsToParse = inspector?.settings.maxObjectsToParse,
                (objectIndex + 1) > maxObjectsToParse {
                break
            }
            // END Debugging/Tests only
            
            let position = try reader.readPosition()
            
            /// Index of object attributes
            let objectAttributesIndex = try reader.readUInt32()
            
            guard
                objectAttributesIndex < maxIndex
            else {
                throw Error.objectAttributesIndexTooLarge(
                    .init(objectAttributesIndex),
                    maxIndex: maxIndex
                )
            }
            
            try reader.skip(byteCount: 5) // unknown

            let attributesOfObject = attributesOfObjects.attributes[.init(objectAttributesIndex)]
            
            let objectKind: Map.Object.Kind
            
            switch attributesOfObject.objectID.class {
            
            case .spellScroll: // TODO figure out a good way to merge `Map.SpellScroll` and `Map.Artifact.Kind == .spellScroll`
                let (message, guardians) = try parseMessageAndGuards(format: format)
                let spellID = try Spell.ID(integer: reader.readUInt32())
                objectKind = .spellScroll(.init(id: spellID, message: message, guardians: guardians))
            
            case .artifact:
                let (message, guards) = try parseMessageAndGuards(format: format)
                let artifact: Artifact
                if case let .spellScroll(expectedSpellScrollID) = attributesOfObject.objectID {
                    let spellIDParsed = try Spell.ID(integer: reader.readUInt32())
                    assert(spellIDParsed == expectedSpellScrollID)
                    artifact = .scroll(spell: spellIDParsed)
                } else if case let .artifact(specificArtifactID) = attributesOfObject.objectID {
                    artifact =  .specific(id: specificArtifactID) //.init(id: expectedArtifactID)
                } else if case .randomMajorArtifact = attributesOfObject.objectID {
                    artifact = .random(class: .major) //.init(id: .random(class: .major, in: format))
                } else if case .randomMinorArtifact = attributesOfObject.objectID {
                    artifact = .random(class: .minor) //.init(id: .random(class: .minor, in: format))
                } else if case .randomRelic = attributesOfObject.objectID {
                    artifact = .random(class: .relic) //.init(id: .random(class: .relic, in: format))
                } else if case .randomTreasureArtifact = attributesOfObject.objectID {
                    artifact = .random(class: .treasure) //.init(id: .random(class: .treasure, in: format))
                } else if case .randomArtifact = attributesOfObject.objectID {
                    artifact = .random(class: .any) //.init(id: .random(class: .any, in: format))
                } else { fatalError("incorrect implementation, unhandled object ID: \(attributesOfObject.objectID)") }
                let guardedArtifact = Map.GuardedArtifact(artifact, message: message, guards: guards)
              
                objectKind = .artifact(guardedArtifact)
            case .event:
                objectKind = try .geoEvent(parseGeoEvent(format: format, availablePlayers: playersInfo.availablePlayers))
            case .garrison:
                let owner = try parseOwner()
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
                objectKind = try .grail(.init(radius: reader.readUInt32()))
            case .hero:
                guard case let .hero(heroClass) = attributesOfObject.objectID else { fatalError("incorrect") }
                objectKind = try .hero(
                    parseHero(
                        heroClass: heroClass,
                        format: format
                    )
                )
            case .lighthouse:
                let owner = try parseOwner()
                try reader.skip(byteCount: 3)
                objectKind = .lighthouse(.init(owner: owner))
            case .monster:
                switch attributesOfObject.objectID {
                case .monster(let creatureID):
                    objectKind = try .monster(
                        parseMonster(format: format, kind: .specific(creatureID: creatureID))
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
          
            case .pandorasBox:
                let pandorasBox = try parsePandorasBox(format: format)
                objectKind = .pandorasBox(pandorasBox)
            case .placeholderHero:  fatalError("placeholderHero")
                
            case .randomHero:
                objectKind = try .hero(
                    parseRandomHero(
                        format: format
                    )
                )
            case .prison:
                objectKind = try .hero(
                    parsePrisonHero(
                        format: format
                    )
                )
                
            case .questGuard:
                let quest = try parseQuest()
                objectKind = .questGuard(quest)
                
            case .dwelling: fallthrough
            case .randomDwelling: fallthrough
            case .randomDwellingOfFaction: fallthrough
            case .randomDwellingAtLevel:
                objectKind = try .dwelling(parseDwelling(objectID: attributesOfObject.objectID))
                
            case .resource:
                let (message, guards) = try parseMessageAndGuards(format: format)
                let quantityBase = try reader.readUInt32()
                try reader.skip(byteCount: 4)
                
                let resourceKind: Resource.Kind
                if case let .resource(kind) = attributesOfObject.objectID {
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
                guard case let .mine(mineKind) = attributesOfObject.objectID else { fatalError("incorrect") }
                let mine = try Map.Mine(kind: mineKind, owner: .init(rawValue: reader.readUInt8()))
                try reader.skip(byteCount: 3)
                objectKind = .mine(mine)
            case .abandonedMine:
                let mine = try Map.Mine(kind: nil, owner: .init(rawValue: reader.readUInt8()))
                try reader.skip(byteCount: 3)
                objectKind = .mine(mine)
           
            case .scholar:
                let scholarBonusKind = try Map.Scholar.Bonus.Stripped(integer: reader.readUInt8())
                let bonusIDRaw = try reader.readUInt8()
               
                
                let bonus: Map.Scholar.Bonus
                switch scholarBonusKind {
                case .primarySkill:
                    bonus = try .primarySkill(.init(integer: bonusIDRaw))
                case .secondarySkill:
                    bonus = try .secondarySkill(.init(integer: bonusIDRaw))
                case .spell:
                    bonus = try .spell(.init(integer: bonusIDRaw))
                case .random:
                    UNUSED(bonusIDRaw)
                    bonus = .random
                }
                
                try reader.skip(byteCount: 6)
                
                objectKind = .scholar(.init(bonus: bonus))
        
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
                    let quest = try parseQuest()
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
                let owner = try parseOwner()
                try reader.skip(byteCount: 3)
                let shipyard = Map.Shipyard(owner: owner)
                objectKind = .shipyard(shipyard)
            case .shrine:
                let spellID = try parseSpellID()
                try reader.skip(byteCount: 3)
                objectKind = .shrine(.init(spell: spellID))
            case .sign:
                let message = try reader.readString()
                try reader.skip(byteCount: 4)
                objectKind = .sign(.init(message: message))
            case .oceanBottle:
                let message = try reader.readString(maxByteCount: 150) // Cyon 150 is confirmed in Map Editor to be max for ocean bottle.
                try reader.skip(byteCount: 4)
                objectKind = .oceanBottle(.init(message: message))
            case .town:
                if case let .town(faction) = attributesOfObject.objectID {
                    objectKind = try .town(
                        parseTown(
                            format: format,
                            faction: faction,
                            allowedSpellsOnMap: allowedSpellsOnMap,
                            availablePlayers: playersInfo.availablePlayers
                        )
                    )
                } else {
                    assert(attributesOfObject.objectID == .randomTown)
                    objectKind = try .town(
                        parseRandomTown(
                            format: format,
                            allowedSpellsOnMap: allowedSpellsOnMap,
                            availablePlayers: playersInfo.availablePlayers
                        )
                    )
                }
            case .witchHut:
                let allowedSkills: [Hero.SecondarySkill.Kind] = format > .restorationOfErathia ? try {
                    try reader.readBitArray(byteCount: 4).prefix(Hero.SecondarySkill.Kind.allCases.count).enumerated().compactMap { (skillIndex, allowed) in
                        guard allowed else { return nil }
                        return Hero.SecondarySkill.Kind.allCases[skillIndex]
                    }
                }() : Hero.SecondarySkill.Kind.allCases
                
                objectKind = .witchHut(.init(learnableSkills: allowedSkills))
            }
            
            let mapObject = Map.Object(
                position: position,
                attributes: attributesOfObject,
                kind: objectKind,
                indexInObjectAttributesArray: objectAttributesIndex
            )
            
//            print("🔮 successfully parsed mapObject: \(mapObject), at objectAttributeIndex: \(objectAttributesIndex)")
            
            objects.append(mapObject)
            inspector?.didParseObject(mapObject)
        }
        let detailsAboutObjects = Map.DetailsAboutObjects(objects: objects)
        print("objects: \(detailsAboutObjects.objects.suffix(30))")
        return detailsAboutObjects
    }
}

public struct CreatureStack: Hashable, CustomDebugStringConvertible {
    public typealias Quantity = Int
    public let creatureID: Creature.ID
    public let quantity: Quantity
    
    public var debugDescription: String {
        "\(creatureID): \(quantity)"
    }
}


public struct Army: Hashable {

    public enum Formation: UInt8, Hashable, CaseIterable {
        /// Spread/Wide
        case spread
        /// Grouped/Tight
        case grouped
    }
   
    public let formation: Formation?
    public let creatureStacks: CreatureStacks

    public init(creatureStacks: CreatureStacks, formation: Formation?) {
        self.creatureStacks = creatureStacks
        self.formation = formation
    }
}

public struct CreatureStacks: Hashable, CustomDebugStringConvertible {
    
    public enum Slot: UInt8, Hashable, CaseIterable {
        case one = 0
        case two
        case three
        case four
        case five
        case six
        case seven
       
    }
    
    public let creatureStackAtSlot: [Slot: CreatureStack?]
    
    public var debugDescription: String {
        creatureStackAtSlot.filter { $0.value != nil }.sorted(by: { $0.key.rawValue < $1.key.rawValue }).map {
            return "[\($0.key.rawValue)]: \($0.value!)"
        }.joined(separator: "\n")
    }
    
    public init(creatureStackAtSlot: [Slot: CreatureStack?]) {
        self.creatureStackAtSlot = creatureStackAtSlot.filter { $0.value != nil }
    }
    
    public init(stacksAtSlots: [(Slot, CreatureStack?)]) {
        precondition(stacksAtSlots.count <= Slot.allCases.count)
        self.init(creatureStackAtSlot: Dictionary(uniqueKeysWithValues: stacksAtSlots))
    }
    
    public init(stacks: [CreatureStack?]) {
        self.init(stacksAtSlots: Slot.allCases.prefix(stacks.count).enumerated().map({ index, slot in
            return (key: slot, value: stacks[index])
        }))
    }
    
    
//    public init?(creatureStacks: [CreatureStack?]) {
//
//        guard creatureStacks.compactMap({ $0 }).count > 0 else {
//            return nil
//        }
//
//        self.init(
//            creatureStackAtSlot: Dictionary(
//                uniqueKeysWithValues: Slot.allCases.prefix(creatureStacks.count).enumerated().compactMap({
//                    let key = $0.element
//                    guard let value = creatureStacks[$0.offset] else {
//                        return nil
//                    }
//                    return (key: key, value: value)
//                })
//            )
//        )
//    }
    
}


internal extension Map.Loader.Parser.H3M {
    
    
    
    func parseResources() throws -> Resources? {
        let resources: [Resource] = try Resource.Kind.allCases.map { kind in
            try .init(kind: kind, amount: .init(reader.readInt32())) // yes signed u32, can be negative, e.g. in Town Event, where resources are lost, not gained.
        }
        return .init(resources: resources)
    }
    
    func parseSpellCountAndIDs() throws -> [Spell.ID] {
        try reader.readUInt8().nTimes {
            try Spell.ID(integer: reader.readInt8())
        }
    }
}

