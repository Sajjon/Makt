//
//  Map+Tile.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct Tile: Equatable, CustomDebugStringConvertible {
        public let position: Position
        public let terrain: Terrain
        
        public let river: River?
        public let road: Road?
        
        /// Whether tile is coastal (allows disembarking if land or block movement if water)
        public let isCoastal: Bool
        
        /// If water tile, then we might have greater speed with our boats thanks to favourable winds.
        public let hasFavourableWindEffect: Bool
    }
}

public extension Map.Tile {
    var debugDescription: String {
        let riverString = river.map({ "river: \($0)" }) ?? ""
        let roadString = road.map({ "road: \($0)" }) ?? ""
        let isCoastalString = isCoastal ? "isCostal: true" : ""
        let hasFavourableWindString = hasFavourableWindEffect ? "hasFavourableWindString: true" : ""
        return """
        position: \(position)
        terrain: \(terrain)
        \(riverString)\(roadString)\(isCoastalString)\(hasFavourableWindString)
        """
    }
}
