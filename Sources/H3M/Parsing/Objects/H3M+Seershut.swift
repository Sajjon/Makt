//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Malm

internal extension H3M {
    
    
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
                    kind: Quest.Kind.returnWithArtifacts([artifactID]),
                    messages: nil,
                    deadline: nil
                ),
                bounty: parseBounty(format: format)
            )
        }
        try reader.skip(byteCount: 2)
        
        return seershut
    }
    
    func parseBounty(format: Map.Format) throws -> Map.Seershut.Bounty? {
        
        let bountyStrippedRaw = try reader.readUInt8()
        
        guard bountyStrippedRaw > 0 else {
            // No bounty
            return nil
        }
        
        let bountyStripped = try Map.Seershut.Bounty.Stripped(
            integer: bountyStrippedRaw
        )
        
        let bounty: Map.Seershut.Bounty
        
        switch bountyStripped {
        case .experience:
            bounty = try .experience(reader.readUInt32())
            
        case .spellPoints:
            bounty = try .spellPoints(reader.readUInt32())
            
        case .moraleBonus:
            bounty = try .moraleBonus(reader.readUInt8())
            
        case .luckBonus:
            bounty = try .luckBonus(reader.readUInt8())
            
        case .resource:
            let resource = try Resource(
                kind: .init(integer: reader.readUInt8()),
                // Only the first 3 bytes are used. Skip the 4th.
                quantity: .init(reader.readUInt32() & 0x00ffffff)
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
                .specific(id: creatureID, quantity: .init(reader.readUInt16()))
            )
        }
        return bounty
    }
    
}
