//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
/// Used by Map.Monster and GuardedResource (resources on Map)
public enum Quantity: Hashable, CustomDebugStringConvertible, Codable {
    case random, specified(Int32) // might be negative
    
    public var debugDescription: String {
        switch self {
        case .random: return "random"
        case .specified(let quantity): return "#\(quantity)"
        }
        
    }
}
