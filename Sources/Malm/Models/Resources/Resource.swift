//
//  Resource.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public struct Resource: Hashable, CustomDebugStringConvertible {
    public typealias Quantity = Int
    public let kind: Kind
    public let quantity: Quantity
    
    public init(kind: Kind, quantity: Quantity) {
        self.kind = kind
        self.quantity = quantity
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
    enum Kind: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {

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
