//
//  Map+TeamInfo.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation

public extension Map {
    enum TeamInfo: Hashable, CustomDebugStringConvertible, Codable {
       case teams([Team])
        case noTeams
        
    }
}

// MARK: Team
public extension Map.TeamInfo {
    struct Team: Hashable, CustomDebugStringConvertible, Codable {
        public let id: Int
        public let players: [Player]
        
        public init(
            id: Int,
            players: [Player]
        ) {
            self.id = id
            self.players = players
        }
    }
}

// MARK: ExpressibleByArrayLiteral
extension Map.TeamInfo: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Array<Player>
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        let teams: [Team] = elements.enumerated().map({
            Map.TeamInfo.Team.init(id: $0.offset, players: $0.element)
        })
        
        if teams.isEmpty {
            self = .noTeams
        } else {
            self = .teams(teams)
        }
    }
}

public extension Map.TeamInfo.Team {
    var debugDescription: String  {
        "teamID: \(id), players: \(players)"
    }
}


public extension Map.TeamInfo {
    var debugDescription: String  {
        switch self {
        case .noTeams: return "no teams"
        case .teams(let teams): return teams.map { $0.debugDescription }.joined(separator: ", ")
        }
    }
}
