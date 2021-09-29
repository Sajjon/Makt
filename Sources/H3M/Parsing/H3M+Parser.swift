//
//  Map+Loader+Parser+H3M.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation
import Malm
import Util

// MARK: H3M Parser
public extension Map.Loader.Parser {
    final class H3M {
        internal let readMap: Map.Loader.ReadMap
        internal let reader: DataReader
        internal let fileSizeCompressed: Int?
        public init(readMap: Map.Loader.ReadMap, fileSizeCompressed: Int? = nil) {
            self.readMap = readMap
            self.reader = DataReader(data: readMap.data)
            self.fileSizeCompressed = fileSizeCompressed
        }
    }
}


public extension DataReader {
    
    
    convenience init(readMap: Map.Loader.ReadMap) {
        self.init(data: readMap.data)
    }
    
}


internal typealias H3M = Map.Loader.Parser.H3M

// MARK: Parse Map
extension H3M {
    
    func parseBasicInformation(inspector: Map.Loader.Parser.Inspector.BasicInfoInspector? = nil) throws -> Map.BasicInformation {
        try parseBasicInfo(inspector: inspector)
    }
    
    func parse(inspector: Map.Loader.Parser.Inspector? = nil) throws -> Map {
        
        let checksum = CRC32.checksum(readMap.data)
        
        let basicInfo = try parseBasicInfo(inspector: inspector?.basicInfoInspector)
        
        let format = basicInfo.format
        let size = basicInfo.size
        
        let playersInfo = try parseInformationAboutPlayers(inspector: inspector?.playersInfoInspector, format: format)
        
        let additionalInfo = try parseAdditionalInfo(inspector: inspector?.additionalInformationInspector, format: format, playersInfo: playersInfo)
        
        let world = try parseTerrain(
            hasUnderworld: basicInfo.hasTwoLevels,
            size: size
        )
        assert(world.above.tiles.count == size.tileCount)
        inspector?.didParseWorld(world)
        
        let attributesOfObjects = try parseAttributesOfObjects()
        assert(attributesOfObjects.attributes.count < (world.above.tiles.count + (world.underground?.tiles.count ?? 0)))
        inspector?.didParseAttributesOfObjects(attributesOfObjects)
        
        
        let detailsAboutObjects = try parseDetailsAboutObjects(
            inspector: inspector,
            format: format,
            playersInfo: playersInfo,
            additionalMapInformation: additionalInfo,
            attributesOfObjects: attributesOfObjects
        )
        inspector?.didParseAllObjects(detailsAboutObjects)
        
        let globalEvents = try parseTimedEvents(format: format, availablePlayers: playersInfo.availablePlayers)
        inspector?.didParseEvents(globalEvents)
        
        return .init(
            checksum: checksum,
            basicInformation: basicInfo,
            playersInfo: playersInfo,
            additionalInformation: additionalInfo,
            world: world,
            attributesOfObjects: attributesOfObjects,
            detailsAboutObjects: detailsAboutObjects,
            globalEvents: globalEvents
        )
    }
}

internal extension H3M {
    
    
    func parseAllowedPlayers(availablePlayers: [Player]) throws -> [Player] {
        let players: [Player] = try parseBitmaskOfEnum()
        return players.filter { availablePlayers.contains($0) }
    }
    
    
    func parseHeroClass() throws -> Hero.Class? {
        let heroClassRaw = try reader.readUInt8()
        guard heroClassRaw != 0xff else { return nil }
        return try Hero.Class(integer: heroClassRaw)
    }
    
}

public typealias Bitmask = BitArray

// MARK: Parse "Attributes
private extension H3M {
    
    /// Parse object atributes
    /// Here are properties of all objects on the map including castles and heroes
    /// (but not land itself, roads and rivers) and Events, both placed on the map
    /// and global events (these are set in Map Specifications)
    func parseAttributesOfObjects() throws -> Map.AttributesOfObjects {
        let attributesCount = try reader.readUInt32()
        let attributes: [Map.Object.Attributes] = try (0..<attributesCount).compactMap { _ in
            /// aka "Sprite name"
            let animationFileName = try reader.readLengthOfStringAndString(assertingMaxLength: 20)! // arbitrarily chosen
            
            /// Which squares (of this object) are passable, counted from the bottom right corner
            /// (bit 1: passable, bit 0: impassable
            let passabilityBitmask = try reader.readPathfindingMask()
            
            /// Active/visitable squares (overlaid on impassable squares)
            /// (bit 1: active, bit 0: passive
            let visitabilityBitmask = try reader.readPathfindingMask()
            
            let pathfinding = Map.Object.Attributes.Pathfinding(
                visitability: .init(
                    relativePositionsOfVisitableTiles: visitabilityBitmask
                ),
                passability: .init(
                    relativePositionsOfPassableTiles: passabilityBitmask
                )
            )
            
            func parseLandscapes() throws -> [Map.Terrain] {
                try parseBitmaskOfEnum()
            }
            
            /// what kinds of landscape it can be put on
            let supportedLandscapes = try parseLandscapes()
            
            /// What landscape group the object will be in the editor
            let mapEditorLandscapeGroup = try parseLandscapes()
            
            let objectIDRaw = try reader.readUInt32()
            
            let objectID = try Map.Object.ID(
                id: objectIDRaw,
                subId: reader.readUInt32()
            )
            
            /// used by editor
            let objectGroupRaw = try reader.readUInt8()
            let group: Map.Object.Attributes.Group? = .init(rawValue: objectGroupRaw)
            
            let sprite: Sprite = {
                if let sprite = Sprite(rawValue: animationFileName) {
                    return sprite
                } else {
                    var caseBaseName = objectID.subtypeDescription.map({ "\(objectID.name)\($0.capitalizingFirstLetter())" }) ?? objectID.name
                    
                    if objectID.stripped == .creatureBank || objectID.stripped == .artifact || objectID.stripped == .monster || objectID.stripped == .resourceGenerator || objectID.stripped == .creatureGenerator1 {
                        caseBaseName = objectID.subtypeDescription!
                    }
                    
                    let animationFileNameWithoutExtension = animationFileName.hasSuffix(".def") ? String(animationFileName.dropLast(4)) : animationFileName
                    let caseName = "\(caseBaseName)_\(animationFileNameWithoutExtension)"
                    var mapEditorLandscapeGroupString = ""
                    if mapEditorLandscapeGroup == [.water] {
                        mapEditorLandscapeGroupString = "Water"
                    } else if mapEditorLandscapeGroup.count == 8 && !mapEditorLandscapeGroup.contains(.water) {
                        mapEditorLandscapeGroupString = "Land"
                    } else if mapEditorLandscapeGroup.count != 9 {
                        mapEditorLandscapeGroupString = mapEditorLandscapeGroup.map({ String(describing: $0) }).joined(separator: ", ")
                    }
                    
                    if !mapEditorLandscapeGroupString.isEmpty {
                        mapEditorLandscapeGroupString = "\n/// Terrain kind: \(mapEditorLandscapeGroupString)"
                    }
                    
                    let definiition = """
                        
                        /// \(objectID.debugDescription)\(mapEditorLandscapeGroupString)
                        case \(caseName) = "\(animationFileName)"
                        """
                    
                    let customDebugPrint = """
                        
                        /// Sprite for object ID: \(objectID.stripped.rawValue)
                        /// \(objectID.debugDescription)
                        case .\(caseName): return "\(objectID.debugDescription)"
                        """
                    
                    fatalError("⚠️⚠️⚠️  New sprite found ⚠️⚠️⚠️\n\nAdd the sprite to the enum:\n\n\(definiition)\n and the Sprite extension for CustomDebugPrintConvertible as well: \n\n\(customDebugPrint)\\nn")
                }
            }()
            
            
            let zAxisRenderingPriority = Int(try reader.readUInt8()) * 10 // We multiply by 10 so that we can set values for terrain, river, road with lower values.
            
            /// Unknown
            let unknownBytes = try reader.read(byteCount: 16)
            
            guard unknownBytes.allSatisfy({ $0 == 0x00 }) else {
                fatalError("If we hit this fatalError we can probably remove this check. I THINK I've identified behaviour that these 16 unknown bytes are always 16 zeroes. This might not be the case for some custom maps. I've added this assertion as a kind of 'offset check', meaning that it is helpful that we expect these 16 bytes to all be zero as an indicator that we are reading the correct values before at the expected offset in the maps byte blob.")
            }
            
            let attributes = Map.Object.Attributes(
                sprite: sprite,
                supportedLandscapes: supportedLandscapes,
                mapEditorLandscapeGroup: mapEditorLandscapeGroup,
                objectID: objectID,
                group: group,
                pathfinding: pathfinding,
                zAxisRenderingPriority: zAxisRenderingPriority
            )
            return attributes
        }
        
        return .init(attributes: attributes)
    }
}

// MARK: Parse Events
internal extension H3M {
    
    func parseTimedEvent(
        format: Map.Format,
        availablePlayers: [Player]
    ) throws -> Map.TimedEvent {
        let name = try reader.readLengthOfStringAndString(assertingMaxLength: 8192) // arbitrarily chosen
        let message = try reader.readLengthOfStringAndString(assertingMaxLength: 29861) // Cyon: found to be max in Map Editor
        let resources = try parseResources()
        let affectedPlayers = try parseAllowedPlayers(availablePlayers: availablePlayers)
        let appliesToHumanPlayers = try format >= .shadowOfDeath ? reader.readBool() : true
        let appliesToComputerPlayers = try reader.readBool()
        let firstOccurence = try reader.readUInt16()
        let subsequentOccurenceRaw = try reader.readUInt8()
        let subsequentOccurence: Map.TimedEvent.Occurrences.Subsequent? = try subsequentOccurenceRaw == Map.TimedEvent.Occurrences.Subsequent.neverRawValue ? .never : Map.TimedEvent.Occurrences.Subsequent(integer: subsequentOccurenceRaw)
        
        try reader.skip(byteCount: 17)
        return .init(
            name: name,
            message: message,
            firstOccurence: firstOccurence,
            subsequentOccurence: subsequentOccurence,
            affectedPlayers: affectedPlayers,
            appliesToHumanPlayers: appliesToHumanPlayers,
            appliesToComputerPlayers: appliesToComputerPlayers,
            resources: resources
        )
    }
}

internal extension H3M {
    func parseTimedEvents(
        format: Map.Format,
        availablePlayers: [Player]
    ) throws -> Map.TimedEvents? {
        let eventCount = try reader.readUInt32()
        let events: [Map.TimedEvent] = try eventCount.nTimes {
            try parseTimedEvent(format: format, availablePlayers: availablePlayers)
        }
        
        guard !events.isEmpty else {
            return nil
        }
        
        return .init(values: events.sorted(by: \.occurrences.first))
    }
    
}
