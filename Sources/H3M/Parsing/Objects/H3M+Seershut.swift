//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Malm

internal extension H3M {
    func parseBounty(format: Map.Format) throws -> Map.Seershut.Bounty {
        
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
