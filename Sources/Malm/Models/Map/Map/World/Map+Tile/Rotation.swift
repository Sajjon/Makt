//
//  Map+Tile+Mirroring.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public typealias Mirroring = Map.Tile.Mirroring

public protocol Flippable {
    var mirroring: Mirroring { get }
}

public extension Map.Tile {
    /// The mirroring of road, river, and terrain surface tiles.
    struct Mirroring: Hashable, CustomDebugStringConvertible, CaseIterable {
        public let flipVertical: Bool
        public let flipHorizontal: Bool
        
        public init(
            flipVertical: Bool,
            flipHorizontal: Bool
        ) {
            self.flipVertical = flipVertical
            self.flipHorizontal = flipHorizontal
        }
        
        public static let none: Self = .init(flipVertical: false, flipHorizontal: false)
        public static let veritcal: Self = .init(flipVertical: true, flipHorizontal: false)
        public static let horizontal: Self = .init(flipVertical: false, flipHorizontal: true)
        public static let both: Self = .init(flipVertical: true, flipHorizontal: true)
        public typealias AllCases = [Self]
        public static let allCases: [Self] = [.none, .veritcal, .horizontal, .both]
    }
}

public extension Mirroring {
    var debugDescription: String {
        """
        flip↕️: \(flipVertical), flip↔️: \(flipHorizontal)
        """
    }
}
