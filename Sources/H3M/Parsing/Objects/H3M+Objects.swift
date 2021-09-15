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
        let maxIndex = attributesOfObjects.attributes.count
        let objectCount = try reader.readUInt32()
        
        let objects: [Map.Object] = try objectCount.nTimes {
            let position = try parsePosition()
            let attributesIndex = try reader.readUInt32()
            
            guard attributesIndex < maxIndex else {
                throw H3MError.objectAttributesIndexTooLarge(.init(attributesIndex), maxIndex: maxIndex)
            }
            
            try reader.skip(byteCount: 5) // unknown

            let attributes = attributesOfObjects.attributes[.init(attributesIndex)]
            inspector?.willParseObject(at:  position, attributes: attributes)
            
            let objectKind = try parseObject(
                position: position,
                attributes: attributes,
                format: format,
                playersInfo: playersInfo,
                additionalMapInformation: additionalMapInformation
            )
            
            let mapObject = Map.Object(
                position: position,
                attributes: attributes,
                kind: objectKind
            )
            
            inspector?.didParseObject(mapObject)
            return mapObject
        }
        
        return .init(objects: objects)
    }
}

private extension H3M {
    
    func parseObject(
        position: Position,
        attributes attributesOfObject: Map.Object.Attributes,
        format: Map.Format,
        playersInfo: Map.InformationAboutPlayers,
        additionalMapInformation: Map.AdditionalInformation
    ) throws -> Map.Object.Kind {
        
        let objectID = attributesOfObject.objectID
        
        switch objectID.class {
        
        case .spellScroll: // TODO figure out a good way to merge `Map.SpellScroll` and `Map.Artifact.Kind == .spellScroll`
            return try .spellScroll(parseSpellScroll(format: format))
        case .artifact:
            return try .artifact(parseGuardedArtifact(format: format, objectID: objectID))
        case .event:
            return try .geoEvent(parseGeoEvent(format: format, availablePlayers: playersInfo.availablePlayers))
        case .garrison:
            return try .garrison(parseGarrison(format: format))
        case .grail:
            return try .grail(.init(radius: reader.readUInt32()))
        case .hero:
            guard case let .hero(heroClass) = objectID else {
                incorrectImplementation(reason: "Only specific heroes should be parsed here, not Prison nor random heroes. These are handled separately.")
            }
            return try .hero(parseHero(heroClass: heroClass, format: format))
        case .lighthouse:
            return try .lighthouse(parseLighthouse())
        case .monster:
            return try .monster(parseMonsterObject(id: objectID, format: format))
        case .pandorasBox:
            return try .pandorasBox(parsePandorasBox(format: format))
        case .randomHero:
            return try .hero(parseRandomHero(format: format))
        case .prison:
            return try .hero(parsePrisonHero(format: format))
        case .questGuard:
            return try .questGuard(parseQuest())
            
        // Dwellings
        case .dwelling: fallthrough
        case .randomDwelling: fallthrough
        case .randomDwellingOfFaction: fallthrough
        case .randomDwellingAtLevel:
            return try .dwelling(parseDwelling(attributes: attributesOfObject))
            
        case .resource:
            return try .resource(parseGuardedResource(objectID: objectID, format: format))
        case .resourceGenerator:
            guard case let .resourceGenerator(placeholderKind) = objectID else { incorrectImplementation(shouldAlwaysBeAbleTo: "Get kind of mine.") }
            switch placeholderKind {
            case .abandonedMine: return try .abandonedMine(parseAbandonedMine())
            default:
                let kind = placeholderKind
                assert(kind != .abandonedMine)
                return try .resourceGenerator(parseResourceGenerator(kind: kind))
            }
           
        case .abandonedMine:
            return try .abandonedMine(parseAbandonedMine())
        case .scholar:
            return try .scholar(parseScholar())
        case .seersHut:
            return try .seershut(parseSeershut(format: format))
        case .shipyard:
            return try .shipyard(parseShipyard())
        case .shrine:
            return try .shrine(parseShrine())
        case .sign:
            return try .sign(parseSign())
        case .oceanBottle:
            return try .oceanBottle(parseOceanBottle())
        case .town:
            return try .town(
                parseTownObject(
                    id: objectID,
                    format: format,
                    position: position,
                    allowedSpellsOnMap: additionalMapInformation.availableSpells ?? SpellIDs.init(values: Spell.ID.allCases),
                    availablePlayers: playersInfo.availablePlayers
                )
            )
        case .witchHut:
            return try .witchHut(parseWitchHut(format: format))
        case .placeholderHero:
            // Untested
            return try .placeholderHero(parsePlaceholderHero())
        case .genericBoat, .genericImpassableTerrain, .genericPassableTerrain, .genericTreasure, .genericVisitable, .monolithTwoWay, .subterraneanGate:
            // Generic objects have no body, nothing to parse.
            return .generic
        }
    }
}
