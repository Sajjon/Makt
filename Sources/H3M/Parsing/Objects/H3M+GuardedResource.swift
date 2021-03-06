//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension H3M {
    func parseGuardedResource(objectID: Map.Object.ID, format: Map.Format) throws -> Map.GuardedResource {
        let (message, guardians) = try parseMessageAndGuardians(format: format)
        let quantityBase = try Int32(reader.readUInt32()) // 4 bytes quantity
        try reader.skip(byteCount: 4) // 4 bytes unknown
        
        let kind: Map.GuardedResource.Kind
        if case let .resource(resourceKind) = objectID {
            kind = .specific(resourceKind)
        } else {
            // random
            kind = .random
        }
        
        // Gold is always multiplied by 100
        let resourceQuantity: Quantity = quantityBase == 0 ? .random : .specified((kind == .specific(.gold) ? quantityBase * 100 : quantityBase))
        
        return .init(
            kind: kind,
            quantity: resourceQuantity,
            message: message,
            guardians: guardians
        )
    }
    
}
