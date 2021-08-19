//
//  Map+Tile+Road.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map.Tile {
    
    struct Road: Equatable, CustomDebugStringConvertible {
        public let kind: Kind
        
        /// The direction of the the road. Not to be confused with `rotation` of image.
        public let direction: Direction
        
        /// Rotation of the image
        public let rotation: Rotation
    }
}

// MARK: Kind
public extension Map.Tile.Road {
    enum Kind: UInt8, Equatable, CaseIterable, CustomDebugStringConvertible {
        // 0 means "no road", but we model it as `Optional<Road>.none` instead of Road.Kind having a specific case for it...
        case dirt = 1, gravel, cobbelStone
    }
}

public extension Map.Tile.Road.Kind {
    var debugDescription: String {
        switch self {
        case .dirt: return "dirt"
        case .gravel: return "gravel"
        case .cobbelStone: return "cobbelStone"
        }
    }
}

// MARK: Direction
public extension Map.Tile.Road {
    
    /// River properties controlling direction of the road, this is an identifier for which "frame" (image) to use.
    ///
    ///                                                 ┌───┐
    ///     00,01,02,03,04,05 - 6 variations of segment │ ╔═╡
    ///                                                 └─╨─┘
    ///                                              ┌─╥─┐
    ///     06, 07         - 2 variations of segment │ ╠═╡
    ///                                              └─╨─┘
    ///                                              ┌───┐
    ///     08, 09         - 2 variations of segment ╞═╦═╡
    ///                                              └─╨─┘
    ///                                              ┌─╥─┐
    ///     0A, 0B         - 2 variations of segment │ ║ │
    ///                                              └─╨─┘
    ///                                              ┌───┐
    ///     0C, 0D         - 2 variations of segment ╞═══╡
    ///                                              └───┘
    ///                              ┌───┐
    ///     0E             - segment │ ║ │
    ///                              └─╨─┘
    ///                              ┌───┐
    ///     0F             - segment │ ══╡
    ///                              └───┘
    ///                              ┌─╥─┐
    ///     10             - segment ╞═╬═╡
    ///                              └─╨─┘
    ///
    /// More info: https://github.com/Sajjon/HoMM3SwiftUI/blob/main/H3M.md#road-properties
    ///
    struct Direction: Equatable {
        public typealias RawValue = UInt8
        public let frameID: RawValue
        
        // 17 different configurations, see: https://github.com/Sajjon/HoMM3SwiftUI/blob/main/H3M.md#road-properties
        public static let max: RawValue = 17
        
        public enum Error: Swift.Error {
            case valueTooLarge(mustAtMostBe: RawValue, butGot: RawValue)
        }
        
        public init(_ rawValue: RawValue) throws {
            guard rawValue <= Self.max else { throw Error.valueTooLarge(mustAtMostBe: Self.max, butGot: rawValue) }
            self.frameID = rawValue
        }
    }
}

public extension Map.Tile.Road {
    var debugDescription: String {
        """
        kind: \(kind)
        direction: \(direction)
        rotation: \(rotation)
        """
    }
}
