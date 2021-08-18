//
//  Resource.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public struct Resource: Equatable {
    public typealias Amount = Int
    public let kind: Kind
    public let amount: Amount
}

public extension Resource {
    enum Kind: Int, Equatable {
        case gold
    }
}
