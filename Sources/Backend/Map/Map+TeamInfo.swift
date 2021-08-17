//
//  Map+TeamInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Map {
    struct TeamInfo: Equatable, CustomStringConvertible {
        public let teams: [Team]?
        public struct Team: Equatable, CustomStringConvertible {
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

public extension Map.TeamInfo.Team {
    var description: String  {
        "teamID: \(id), players: \(players)"
    }
}


public extension Map.TeamInfo {
    var description: String  {
        guard let teams = teams else {
            return "No teams"
        }
        return teams.map { $0.description }.joined(separator: ", ")
    }
}
