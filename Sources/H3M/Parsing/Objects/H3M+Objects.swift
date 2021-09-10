//
//  Map+Loader+Parser+H3M+Objects.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation
import Malm
import Util


internal extension Map.Loader.Parser.H3M {
    
    func parseDetailsAboutObjects(
        inspector: Map.Loader.Parser.Inspector? = nil,
        format: Map.Format,
        playersInfo: Map.InformationAboutPlayers,
        additionalMapInformation: Map.AdditionalInformation,
        attributesOfObjects: Map.AttributesOfObjects
    ) throws -> Map.DetailsAboutObjects {
        
        let allowedSpellsOnMap = additionalMapInformation.availableSpells?.values ?? Spell.ID.allCases
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
            
            inspector?.willParseObject(at:  position, attributes: attributesOfObject)
            
            switch attributesOfObject.objectID.class {
            
            case .spellScroll: // TODO figure out a good way to merge `Map.SpellScroll` and `Map.Artifact.Kind == .spellScroll`
                let (message, guardians) = try parseMessageAndGuardians(format: format)
                let spellID = try Spell.ID(integer: reader.readUInt32())
                objectKind = .spellScroll(.init(id: spellID, message: message, guardians: guardians))
            
            case .artifact:
                let (message, guardians) = try parseMessageAndGuardians(format: format)
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
                let guardedArtifact = Map.GuardedArtifact(artifact, message: message, guardians: guardians)
              
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
                    areCreaturesRemovable: areCreaturesRemovable,
                    owner: owner,
                    creatures: creatures
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
                let (message, guardians) = try parseMessageAndGuardians(format: format)
                let quantityBase = try Int32(reader.readUInt32()) // 4 bytes quantity
                try reader.skip(byteCount: 4) // 4 bytes unknown
                
                let resourceKind: Resource.Kind
                if case let .resource(kind) = attributesOfObject.objectID {
                    resourceKind = kind
                } else {
                    // random
                    resourceKind = .random()
                }
                
                // Gold is always multiplied by 100
                let resourceQuantity: Quantity = quantityBase == 0 ? .random : .specified((resourceKind == .gold ? quantityBase * 100 : quantityBase))
                
                
                let guardedResource = Map.GuardedResource(
                    kind: resourceKind,
                    quantity: resourceQuantity,
                    message: message,
                    guardians: guardians
                )
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
                let seershut: Map.Seershut
                if format > .restorationOfErathia {
                    let quest = try parseQuest()
                    seershut = try .init(quest: quest, bounty: parseBounty(format: format))
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
                        bounty: parseBounty(format: format)
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
                            position: position, // used as ID if Map file does not specify one.
                            allowedSpellsOnMap: allowedSpellsOnMap,
                            availablePlayers: playersInfo.availablePlayers
                        )
                    )
                } else {
                    assert(attributesOfObject.objectID == .randomTown)
                    objectKind = try .town(
                        parseRandomTown(
                            format: format,
                            position: position, // used as ID if Map file does not specify one.
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
                kind: objectKind
            )
            
            objects.append(mapObject)
            inspector?.didParseObject(mapObject)
        }
        let detailsAboutObjects = Map.DetailsAboutObjects(objects: objects)
        return detailsAboutObjects
    }
}



internal extension Map.Loader.Parser.H3M {
    
    func parseResources() throws -> Resources? {
        let resources: [Resource] = try Resource.Kind.allCases.map { kind in
            try .init(kind: kind, quantity: .init(reader.readInt32())) // yes signed u32, can be negative, e.g. in Town Event, where resources are lost, not gained.
        }
        return .init(resources: resources)
    }
    
    func parseSpellCountAndIDs() throws -> [Spell.ID] {
        try reader.readUInt8().nTimes {
            try Spell.ID(integer: reader.readInt8())
        }
    }
}

