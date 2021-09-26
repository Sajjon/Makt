//
//  Map+Tile+River.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map.Tile {
    struct River: Hashable, CustomDebugStringConvertible {
        public let kind: Kind
        
        /// The direction of the river's "mouth" (three split smaller rivers). Not to be confused with `mirroring` of image.
        public let direction: Direction
        
        /// Mirroring of the image
        public let mirroring: Mirroring
        
        public init(
            kind: Kind,
            direction: Direction,
            mirroring: Mirroring
        ) {
            self.kind = kind
            self.direction = direction
            self.mirroring = mirroring
        }
    }
}

public extension Map.Tile.River {
    var debugDescription: String {
        """
        kind: \(kind)
        direction: \(direction)
        mirroring: \(mirroring)
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
    ///  In Rust code base: H3MRiverTopology
    ///    (0x00, Turn1)
    ///    (0x01, Turn2)
    ///    (0x02, Turn3)
    ///    (0x03, Turn4)
    ///    (0x04, Cross)
    ///    (0x05, TVert1)
    ///    (0x06, TVert2)
    ///    (0x07, THorz1)
    ///    (0x08, THorz2)
    ///    (0x09, Vert1)
    ///    (0x0A, Vert2)
    ///    (0x0B, Horz1)
    ///    (0x0C, Horz2)
    ///
    ///
    /// 
    ///
    struct Direction: Hashable {
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
    enum Kind: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
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
