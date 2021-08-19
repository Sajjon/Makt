//
//  Map+Tile+River.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map.Tile {
    struct River: Equatable, CustomDebugStringConvertible {
        public let kind: Kind
        
        /// The direction of the river's "mouth" (three split smaller rivers). Not to be confused with `rotation` of image.
        public let direction: Direction
        
        /// Rotation of the image
        public let rotation: Rotation
    }
}

public extension Map.Tile.River {
    var debugDescription: String {
        """
        kind: \(kind)
        direction: \(direction)
        rotation: \(rotation)
        """
    }
}

// MARK: Direction
public extension Map.Tile.River {
    
    /// River properties controlling direction of the rivers "mouth", this is an identifier for which "frame" (image) to use.
    ///
    ///                                              ┌───┐
    ///     00, 01, 02, 03 - 4 variations of segment │ ╔═╡
    ///                              ┌─╥─┐           └─╨─┘
    ///     04             - segment ╞═╬═╡
    ///                              └─╨─┘           ┌───┐
    ///     05, 06         - 2 variations of segment ╞═╦═╡
    ///                                              └─╨─┘
    ///                                              ┌─╥─┐
    ///     07, 08         - 2 variations of segment │ ╠═╡
    ///                                              └─╨─┘
    ///                                              ┌─╥─┐
    ///     09, 0A         - 2 variations of segment │ ║ │
    ///                                              └─╨─┘
    ///                                              ┌───┐
    ///     0B, 0C         - 2 variations of segment ╞═══╡
    ///                                              └───┘
    ///
    /// More info: https://github.com/Sajjon/HoMM3SwiftUI/blob/main/H3M.md#river-properties
    ///
    struct Direction: Equatable {
        public typealias RawValue = UInt8
        public let frameID: RawValue
        
        // 13 different configurations, see: https://github.com/Sajjon/HoMM3SwiftUI/blob/main/H3M.md#river-properties
        public static let max: RawValue = 13
        
        public enum Error: Swift.Error {
            case valueTooLarge(mustAtMostBe: RawValue, butGot: RawValue)
        }
        public init(_ rawValue: RawValue) throws {
            guard rawValue <= Self.max else { throw Error.valueTooLarge(mustAtMostBe: Self.max, butGot: rawValue) }
            self.frameID = rawValue
        }
    }
}


// MARK: Kind
public extension Map.Tile.River {
    enum Kind: UInt8, Equatable, CaseIterable, CustomDebugStringConvertible {
        // 0 means "no river", but we model it as `Optional<River>.none` instead of River.Kind having a specific case for it...
        case clear = 1, icy, muddy, lava
    }
}

public extension Map.Tile.River.Kind {
    var debugDescription: String {
        switch self {
        case .clear: return "clear"
        case .icy: return "icy"
        case .muddy: return "muddy"
        case .lava: return "lava"
        }
    }
}
