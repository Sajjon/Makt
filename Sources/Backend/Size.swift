//
//  Size.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public struct Size: Equatable {
    public typealias Scalar = Int
    public let width: Scalar
    public let height: Scalar
}

private extension Size.Scalar {
    static let large: Self = 108
}

public extension Size {
    
    static let large: Self = .init(width: .large, height: .large)
}
