//
//  Resource.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public struct Resource: Hashable {
    public typealias Amount = Int
    public let kind: Kind
    public let amount: Amount
}

public extension Resource {
    enum Kind: UInt8, Hashable, CaseIterable {

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
