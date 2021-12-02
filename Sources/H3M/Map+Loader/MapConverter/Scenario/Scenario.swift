//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-18.
//

import Foundation
import Malm

public typealias Model = Hashable & Codable
public typealias River = Map.Tile.River
public typealias Road = Map.Tile.Road
public typealias Ground = Map.Tile.Ground
public typealias Terrain = Map.Terrain
public typealias GuardedResource = Map.GuardedResource

/// NOT USED (yet)
/// Here follows some ides on how to more effectively represent a map, here called "Scenario"
/// in JSON format. The idea is that we want to avoid DUPLICATION of long arrays with sparse objects
/// in Map format parse from H3M (Malm.Map) we have store ObjectAttributes twice, and we store separate arrays for
/// World.Tiles and ObjectDetails. Down below we put the the ObjectDetails inside the tile(s). And of
/// course we use the very efficient optimization of not encoding position in tiles, but rather
/// derive it from the tile's index inside the tile array. The solution is just a POC but seems promising
/// and the model is more attractive than the Malm.Map one.
public struct Scenario: Model {
    
    /// All information relating to this scenario, e.g. name, description, map
    /// size, teams, player info and win/loss conditions.
    public let info: Info
    
    /// All information needed to render the map, as an array of tiles, with
    /// surface terrain ("ground"), river, road and object(s), if any. In case
    /// of large objects - covering multiple tiles - they are only stored in the
    /// origin tile (lower right if I'm correct, TBD if we change this to upper
    /// right instead, we probably wanna do that.)
    public let map: Map
}
