//
//  Size.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation
import Util

public struct Size: Hashable, CaseIterable, CustomDebugStringConvertible {
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
    
    #if HOTA
    /// HotA only
    static let huge = Self.small * 5
    /// HotA only
    static let extraHuge = Self.small * 6
    /// HotA only
    static let gigantic = Self.small * 7
    #endif // HOTA
}

private extension Size {
    static func make(_ size: Size.Scalar) -> Self {
        .init(width: size, height: size)
    }
}
public extension Size {
    
    var tileCount: Int { height * height }
    
    /// 36x36 tiles, the smallest map
    static let small: Self = .make(.small)
    
    /// 72x72 tiles, four times the number of tiles as the size as `small`.
    static let medium: Self = .make(.medium)
    
    /// 108x108 tiles, nine times as big as `small`
    static let large: Self = .make(.large)
    
    /// 144x144 tiles, the largest map size (of not playing HoTa), sixteen times the size `small`.
    static let extraLarge: Self = .make(.extraLarge)
    
#if HOTA
/// HotA only
    static let huge: Self = .make(.huge)
/// HotA only
    static let extraHuge: Self = .make(.extraHuge)
/// HotA only
    static let gigantic: Self = .make(.gigantic)
#endif // HOTA
}

// MARK: CaseIterable
public extension Size {
    typealias AllCases = [Self]
#if HOTA
    static let allCases: [Size] = [
        .small, .medium, .large, .extraLarge, .huge, .extraHuge, .gigantic
    ]
#else
    static let allCases: [Size] = [
        .small, .medium, .large, .extraLarge
    ]
#endif // HOTA
}

// MARK: CustomDebugStringConvertible
public extension Size {
    var debugDescription: String {
        switch self {
        case .small: return "small"
        case .medium: return "medium"
        case .large: return "large"
        case .extraLarge: return "extraLarge"
        #if HOTA
        case .huge: return "huge"
        case .extraHuge: return "extraHuge"
        case .gigantic: return "gigantic"
        #endif // HOTA
        default: incorrectImplementation(shouldAlreadyHave: "Handled all cases.")
        }
    }
}
