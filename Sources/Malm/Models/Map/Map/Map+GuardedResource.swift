//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Util

public extension Map {
    struct GuardedResource: Hashable, CustomDebugStringConvertible {
     
        public let kind: Resource.Kind
        public let quantity: Quantity
        public let message: String?
        public let guardians: CreatureStacks?
   
        public init(
            kind: Resource.Kind,
            quantity: Quantity,
            message: String? = nil,
            guardians: CreatureStacks? = nil
        ) {
            self.kind = kind
            self.quantity = quantity
            self.message = message
            self.guardians = guardians
        }
    }
}

// MARK: CustomDebugStringConvertible
public extension Map.GuardedResource {
    
    var debugDescription: String {
        let resourceString: String = {
            switch quantity {
            case .random: return "random amount of \(kind)"
            case .specified(let quantity): return "\(quantity) \(kind)"
            }
        }()
        let stringOptionals: [String?] = [
            resourceString,
            message.map { "message: \($0)" },
            guardians.map { "guardians: \($0)" }
        ]
        return stringOptionals.filterNils().joined(separator: "\n")
    }
}
