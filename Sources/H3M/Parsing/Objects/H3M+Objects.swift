//
//  Map+Loader+Parser+H3M+Objects.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation
import Malm
import Util


internal extension H3M {
    
    func parseDetailsAboutObjects(
        inspector: Map.Loader.Parser.Inspector? = nil,
        format: Map.Format,
        playersInfo: Map.InformationAboutPlayers,
        additionalMapInformation: Map.AdditionalInformation,
        attributesOfObjects: Map.AttributesOfObjects
    ) throws -> Map.DetailsAboutObjects {
        
        let allowedSpellsOnMap = additionalMapInformation.availableSpells ?? SpellIDs.init(values: Spell.ID.allCases)
        
        let maxIndex = attributesOfObjects.attributes.count
        let objectCount = try reader.readUInt32()
        
        let objects: [Map.Object] = try objectCount.nTimes {
            let position = try reader.readPosition()
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
            inspector?.willParseObject(at:  position, attributes: attributesOfObject)
            
            let objectKind: Map.Object.Kind
            
            switch attributesOfObject.objectID.class {
            
            case .spellScroll: // TODO figure out a good way to merge `Map.SpellScroll` and `Map.Artifact.Kind == .spellScroll`
                objectKind = try .spellScroll(parseSpellScroll(format: format))
            
            case .artifact:
                objectKind = try .artifact(
                    parseGuardedArtifact(
                        format: format,
                        objectID: attributesOfObject.objectID
                    )
                )
            case .event:
                objectKind = try .geoEvent(
                    parseGeoEvent(
                        format: format,
                        availablePlayers: playersInfo.availablePlayers
                    )
                )
            case .garrison:
                objectKind = try .garrison(parseGarrison(format: format))
                
            case .genericBoat, .genericImpassableTerrain, .genericPassableTerrain, .genericTreasure, .genericVisitable, .monolithTwoWay, .subterraneanGate:
                // Generic objects have no body, nothing to parse.
                objectKind = .generic
            case .grail:
                objectKind = try .grail(.init(radius: reader.readUInt32()))
            case .hero:
                guard case let .hero(heroClass) = attributesOfObject.objectID else { fatalError("Only specific heroes should be parsed here, not Prison nor random heroes. These are handled separately") }
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
                objectKind = try .monster(parseMonsterObject(id: attributesOfObject.objectID, format: format))
            case .pandorasBox:
                objectKind = try .pandorasBox(parsePandorasBox(format: format))
            case .randomHero:
                objectKind = try .hero(
                    parseRandomHero(
                        format: format
                    )
                )
            case .prison:
                objectKind = try .hero(parsePrisonHero(format: format))
            case .questGuard:
                objectKind = try .questGuard(parseQuest())
                
            case .dwelling: fallthrough
            case .randomDwelling: fallthrough
            case .randomDwellingOfFaction: fallthrough
            case .randomDwellingAtLevel:
                objectKind = try .dwelling(parseDwelling(objectID: attributesOfObject.objectID))
                
            case .resource:
                objectKind = try .resource(
                    parseGuardedResource(
                        objectID: attributesOfObject.objectID,
                        format: format
                    )
                )
            case .resourceGenerator:
                guard case let .mine(mineKind) = attributesOfObject.objectID else { incorrectImplementation(shouldAlwaysBeAbleTo: "Get kind of mine.") }
                objectKind = try .mine(parseMine(kind: mineKind))
            case .abandonedMine:
                objectKind = try .mine(parseMine())
            case .scholar:
                objectKind = try .scholar(parseScholar())
            case .seersHut:
                objectKind = try .seershut(parseSeershut(format: format))
            case .shipyard:
                objectKind = try .shipyard(parseShipyard())
            case .shrine:
                let spellID = try parseSpellID()
                try reader.skip(byteCount: 3)
                objectKind = .shrine(.init(spell: spellID))
            case .sign:
                objectKind = try .sign(parseSign())
            case .oceanBottle:
                objectKind = try .oceanBottle(parseOceanBottle())
            case .town:
                objectKind = try .town(
                    parseTownObject(
                        id: attributesOfObject.objectID,
                        format: format,
                        position: position,
                        allowedSpellsOnMap: allowedSpellsOnMap,
                        availablePlayers: playersInfo.availablePlayers
                    )
                )
            case .witchHut:
                objectKind = try .witchHut(parseWitchHut(format: format))
                
            case .placeholderHero:
                // Untested
                objectKind = try .placeholderHero(parsePlaceholderHero())
            }
            
            let mapObject = Map.Object(
                position: position,
                attributes: attributesOfObject,
                kind: objectKind
            )
            
            inspector?.didParseObject(mapObject)
            return mapObject
        }
        let detailsAboutObjects = Map.DetailsAboutObjects(objects: objects)
        return detailsAboutObjects
    }
}


internal extension H3M {
    
    func parseTownObject(
        id objectID: Map.Object.ID,
        format: Map.Format,
        position: Position,
        allowedSpellsOnMap: SpellIDs,
        availablePlayers: [Player]
    ) throws -> Map.Town {
        if case let .town(faction) = objectID {
            return try parseTown(
                format: format,
                faction: faction,
                position: position, // used as ID if Map file does not specify one.
                allowedSpellsOnMap: allowedSpellsOnMap,
                availablePlayers: availablePlayers
            )
        } else {
            assert(objectID == .randomTown)
            return try parseRandomTown(
                format: format,
                position: position, // used as ID if Map file does not specify one.
                allowedSpellsOnMap: allowedSpellsOnMap,
                availablePlayers: availablePlayers
            )
        }
    }
    
    func parseMonsterObject(id objectID: Map.Object.ID, format: Map.Format) throws -> Map.Monster {
        switch objectID {
        case .monster(let creatureID):
            return try
            parseMonster(format: format, kind: .specific(creatureID: creatureID))
        case .randomMonsterLevel1:
            return try parseRandomMonster(format: format, level: .one)
        case .randomMonsterLevel2:
            return try parseRandomMonster(format: format, level: .two)
        case .randomMonsterLevel3:
            return try parseRandomMonster(format: format, level: .three)
        case .randomMonsterLevel4:
            return try
            parseRandomMonster(format: format, level: .four)
        case .randomMonsterLevel5:
            return try parseRandomMonster(format: format, level: .five)
        case .randomMonsterLevel6:
            return try  parseRandomMonster(format: format, level: .six)
        case .randomMonsterLevel7:
            return try parseRandomMonster(format: format, level: .seven)
        case .randomMonster:
            return try parseRandomMonster(format: format)
        default: incorrectImplementation(shouldAlreadyHave: "handled object id: \(objectID) in an earlier switch.")
        }
    }
    
    // WARNING untested method
    func parsePlaceholderHero() throws -> Hero.Placeholder {
        guard let owner = try parseOwner() else { incorrectImplementation(reason: "A placeholder hero should always have an owner, right?") }
        let identityRaw = try reader.readUInt8()
        let identity: Hero.Placeholder.Identity = try identityRaw == 0xff ? .anyHero(powerRating: .init(integer: reader.readUInt8())) : .specificHero(.init(integer: identityRaw))
        
        return .init(owner: owner, identity: identity)
    }
    
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
                    
    func parseWitchHut(format: Map.Format) throws -> Map.WitchHut {
        let learnableSkills: [Hero.SecondarySkill.Kind] = format > .restorationOfErathia ? try {
            try reader.readBitArray(byteCount: 4).prefix(Hero.SecondarySkill.Kind.allCases.count).enumerated().compactMap { (skillIndex, allowed) in
                guard allowed else { return nil }
                return Hero.SecondarySkill.Kind.allCases[skillIndex]
            }
        }() : Hero.SecondarySkill.Kind.allCases
    
        return .init(learnableSkills: learnableSkills)
    }
                    
    func parseOceanBottle() throws -> Map.OceanBottle {
        let message = try reader.readString(maxByteCount: 150) // Cyon 150 is confirmed in Map Editor to be max for ocean bottle.
        try reader.skip(byteCount: 4)
        return .init(message: message)
    }
    
    func parseGuardedResource(objectID: Map.Object.ID, format: Map.Format) throws -> Map.GuardedResource {
        let (message, guardians) = try parseMessageAndGuardians(format: format)
        let quantityBase = try Int32(reader.readUInt32()) // 4 bytes quantity
        try reader.skip(byteCount: 4) // 4 bytes unknown
        
        let resourceKind: Resource.Kind
        if case let .resource(kind) = objectID {
            resourceKind = kind
        } else {
            // random
            resourceKind = .random()
        }
        
        // Gold is always multiplied by 100
        let resourceQuantity: Quantity = quantityBase == 0 ? .random : .specified((resourceKind == .gold ? quantityBase * 100 : quantityBase))
        
        return .init(
            kind: resourceKind,
            quantity: resourceQuantity,
            message: message,
            guardians: guardians
        )
    }
    
    func parseScholar() throws -> Map.Scholar {
        
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
        
        return .init(bonus: bonus)
    }
    
    func parseSeershut(format: Map.Format) throws -> Map.Seershut {
        let seershut: Map.Seershut
        if format > .restorationOfErathia {
            let quest = try parseQuest()
            // can't return yet, need to skip 2 bytes
            seershut = try .init(quest: quest, bounty: parseBounty(format: format))
        } else {
            assert(format == .restorationOfErathia)
            guard let artifactID = try parseArtifactID(format: format) else {
                try reader.skip(byteCount: 3)
                return .empty
            }
            // can't return yet, need to skip 2 bytes
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
        
        return seershut
    }
    
    func parseSign() throws -> Map.Sign {
        let message = try reader.readString()
        try reader.skip(byteCount: 4)
        return .init(message: message)
    }
    
    func parseShipyard() throws -> Map.Shipyard {
        let owner = try parseOwner()
        try reader.skip(byteCount: 3)
        return .init(owner: owner)
    }
    
    func parseMine(kind: Map.Mine.Kind? = nil) throws -> Map.Mine {
        let mine = try Map.Mine(kind: kind, owner: .init(rawValue: reader.readUInt8()))
        try reader.skip(byteCount: 3)
        return mine
    }
}
                                       
