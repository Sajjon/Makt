//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension H3M {
    func parseResources() throws -> Resources? {
        let resources: [Resource] = try Resource.Kind.allCases.map { kind in
            try .init(kind: kind, quantity: .init(reader.readInt32())) // yes signed u32, can be negative, e.g. in Town Event, where resources are lost, not gained.
        }
        return .init(resources: resources)
    }
    
}
