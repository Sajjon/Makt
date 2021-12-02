//
//  Resource.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public struct Resource: Hashable, CustomDebugStringConvertible, Codable {
    public typealias Quantity = Int
    public let kind: Kind
    public let quantity: Quantity
    
    public init(kind: Kind, quantity: Quantity) {
        self.kind = kind
        self.quantity = quantity
    }
}


// MARK: Factory
public extension Resource {
    static func wood(_ quantity: Quantity) -> Self {
        .init(kind: .wood, quantity: quantity)
    }
    
    static func mercury(_ quantity: Quantity) -> Self {
        .init(kind: .mercury, quantity: quantity)
    }
    
    static func ore(_ quantity: Quantity) -> Self {
        .init(kind: .ore, quantity: quantity)
    }
    
    static func sulfur(_ quantity: Quantity) -> Self {
        .init(kind: .sulfur, quantity: quantity)
    }
    
    static func crystal(_ quantity: Quantity) -> Self {
        .init(kind: .crystal, quantity: quantity)
    }
    
    static func gems(_ quantity: Quantity) -> Self {
        .init(kind: .gems, quantity: quantity)
    }
    
    static func gold(_ quantity: Quantity) -> Self {
        .init(kind: .gold, quantity: quantity)
    }
}

// MARK: CustomDebugStringConvertible
public extension Resource {
    var debugDescription: String {
        "#\(quantity) \(kind)"
    }
}

// MARK: Knid
public extension Resource {
    enum Kind: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible, Codable {

        case wood
        case mercury
        case ore
        case sulfur
        case crystal
        case gems
        case gold
        
        #if WOG
        case mithril
        #endif // WOG
    }
}

public extension Resource.Kind {
    var debugDescription: String {
        switch self {
        case .wood: return "wood"
        case .mercury: return "mercury"
        case .ore: return "ore"
        case .sulfur: return "sulfur"
        case .crystal: return "crystal"
        case .gems: return "gems"
        case .gold: return "gold"
        }
    }
}
