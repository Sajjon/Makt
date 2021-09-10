//
//  Map+Loader+Parser+H3M+Object+Town.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-22.
//

import Foundation
import Malm


// MARK: Parse Town
internal extension Map.Loader.Parser.H3M {
    
    func parseRandomTown(
        format: Map.Format,
        position: Position,
        allowedSpellsOnMap: SpellIDs,
        availablePlayers: [Player]
    ) throws -> Map.Town {
        try parseTown(
            format: format,
            position: position,
            allowedSpellsOnMap: allowedSpellsOnMap,
            availablePlayers: availablePlayers
        )
    }
    
    func parseTown(
        format: Map.Format,
        faction: Faction? = nil,
        position: Position,
        allowedSpellsOnMap: SpellIDs,
        availablePlayers: [Player]
    ) throws -> Map.Town {
        
        let townID: Map.Town.ID = try format > .restorationOfErathia ? .fromMapFile(reader.readUInt32()) : .position(position)
        
        let owner = try parseOwner()
        let hasName = try reader.readBool()
        let name: String? = try hasName ? reader.readString(maxByteCount: 32) : nil
        
        let hasGarrison = try reader.readBool()
        let garrison: CreatureStacks? = try hasGarrison ? parseCreatureStacks(format: format, count: 7) : nil
        let formation: CreatureStacks.Formation = try .init(integer: reader.readUInt8())
        let hasCustomBuildings = try reader.readBool()
        let buildings: Map.Town.Buildings = try hasCustomBuildings ? parseTownWithCustomBuildings() : parseSimpleTown()
        
        
        let obligatorySpells = try format >= .armageddonsBlade ? parseSpellIDs(includeIfBitSet: true) : []
        let possibleSpells = try parseSpellIDs(includeIfBitSet: false).filter({ allowedSpellsOnMap.contains($0) })
        
        // Read castle events
        let eventCount = try reader.readUInt32()
        assert(eventCount <= 8192, "Cannot be more than 8192 town events... something is wrong. got: \(eventCount)")
        let events: [Map.Town.Event] = try eventCount.nTimes {
            let timedEvent = try parseTimedEvent(
                format: format,
                availablePlayers: availablePlayers
            )
            
            
            // New buildings
            let buildings = try parseBuildings()
            
            // Creatures added to generator
            let creatureQuantities = try CreatureStacks.Slot.allCases.count.nTimes {
                CreatureStack.Quantity(try reader.readUInt16())
            }
            
            try reader.skip(byteCount: 4)

            return Map.Town.Event(
                townID: townID,
                timedEvent: timedEvent,
                buildings: buildings,
                creaturesToBeGained: creatureQuantities
            )
        }
        
        var alignment: Map.Town.Alignment?
        if format >= .shadowOfDeath {
            let alignmentRaw = try reader.readUInt8()
            alignment = alignmentRaw == 0xff ? .sameAsOwnerOrRandom : .sameAs(player: try Player(integer: alignmentRaw))
        }
        
        try reader.skip(byteCount: 3)
        
        return Map.Town(
            id: townID,
            faction: faction,
            owner: owner,
            name: name,
            garrison: garrison,
            formation: formation,
            buildings: buildings,
            spells: .init(
                possible: .init(values: possibleSpells),
                obligatory: .init(values: obligatorySpells)
            ),
            events: events.isEmpty ? nil : .init(values: events),
            alignment: alignment
        )
    }
}




// MARK: Private
private extension Map.Loader.Parser.H3M {
    
    func parseBuildings() throws -> [Map.Town.Building] {
        let rawBytes = try reader.read(byteCount: 6)
        let bitmaskFlipped =  BitArray(data: Data(rawBytes.reversed()))
        let bitmask = BitArray(bitmaskFlipped.reversed())
        return try bitmask.enumerated().compactMap { (buildingID, isBuilt) in
           guard isBuilt else { return nil }
        return try Map.Town.Building(integer: buildingID)
       }
    }
    
    func parseTownWithCustomBuildings() throws -> Map.Town.Buildings {
        let built = try parseBuildings()
        let forbidden = try parseBuildings()
        return .custom(.init(built: built, forbidden: forbidden))
    }
    
    func parseSimpleTown() throws -> Map.Town.Buildings {
        let hasFort = try reader.readBool()
        return .simple(hasFort: hasFort)
    }
}
