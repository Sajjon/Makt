//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-09.
//

import Foundation
import Util

public extension Map {
    struct GuardedResource: Hashable, CustomDebugStringConvertible, Codable {
     
        public enum Kind: Hashable, CustomDebugStringConvertible, Codable {
            case specific(Resource.Kind)
            case random
            
            public var debugDescription: String {
                switch self {
                case .specific(let kind): return String(describing: kind)
                case .random: return "random" 
                }
            }
        }
        
        public let kind: Kind
        public let quantity: Quantity
        public let message: String?
        public let guardians: CreatureStacks?
   
        public init(
            kind: Kind,
            quantity: Quantity,
            message: String? = nil,
            guardians: CreatureStacks? = nil
        ) {
            self.kind = kind
            self.quantity = quantity
            self.message = message
            self.guardians = guardians
        }
        
        public init(
            resourceKind: Resource.Kind,
            quantity: Quantity,
            message: String? = nil,
            guardians: CreatureStacks? = nil
        ) {
            self.init(kind: .specific(resourceKind), quantity: quantity, message: message, guardians: guardians)
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
