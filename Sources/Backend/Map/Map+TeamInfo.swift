//
//  Map+TeamInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Map {
    struct TeamInfo: Equatable {
        public let teams: [Team]?
        public struct Team: Equatable {
            public let id: Int
            public let players: [PlayerColor]
        }
    }
}

// MARK: ExpressibleByArrayLiteral
extension Map.TeamInfo: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Array<PlayerColor>
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(teams: elements.enumerated().map({
            Map.TeamInfo.Team.init(id: $0.offset, players: $0.element)
        }))
    }
}
