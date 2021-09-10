//
//  Size.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public struct Size: Hashable {
    public typealias Scalar = Int
    public let width: Scalar
    public let height: Scalar
    
    public init(width: Scalar, height: Scalar) {
        self.width = width
        self.height = height
    }
}

private extension Size.Scalar {
    static let small: Self = 36
    static let medium = Self.small * 2
    static let large = Self.small * 3
    static let extraLarge = Self.small * 4
    
    // MARK: Hota Only
    
    /// HotA only
    static let huge = Self.small * 5
    /// HotA only
    static let extraHuge = Self.small * 6
    /// HotA only
    static let gigantic = Self.small * 7
}

private extension Size {
    static func make(_ size: Size.Scalar) -> Self {
        .init(width: size, height: size)
    }
}
public extension Size {
    
    var tileCount: Int { height * height }
    
    static let small: Self = .make(.small)
    static let medium: Self = .make(.medium)
    static let large: Self = .make(.large)
    static let extraLarge: Self = .make(.extraLarge)
}
