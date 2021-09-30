//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-09-29.
//

import Foundation
import XCTest
import Malm
@testable import H3M

final class FreedomTests: BaseMapTest {
    
    func test_freedom() throws {
        let mapID: Map.ID = .freedom
        Map.loader.cache.__deleteMap(by: mapID)
        let tilesExpectation = expectation(description: "Tiles")
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .armageddonsBlade) },
                onParseName: { XCTAssertEqual($0, "Freedom") },
                onParseDescription: { XCTAssertEqual($0, "For years the people of this land have been too dependent on each other.  You have finally decided that it is time to declare your freedom and become an independent nation. Unfortunately your neighbors are thinking the same thing.") },
                onParseDifficulty:  { XCTAssertEqual($0, .normal) },
                onParseSize:  { XCTAssertEqual($0, .small) }
            ),
            onParseWorld: { [self] world in
                defer { tilesExpectation.fulfill() }
                let tiles = world.above.tiles
                
                func terrainAt(
                    x: Int32,
                    y: Int32,
                    terrain expectedTerrainKind: Map.Terrain,
                    road: Map.Tile.Road.Kind? = nil,
                    river: Map.Tile.River.Kind? = nil,
                    isCostal expectTileToBeCoastal: Bool? = nil,
                    frameIndex expectedFrameIndex: Int? = nil,
                    isMirroredVertically expectTileToBeMirroredVertically: Bool? = nil,
                    isMirroredHorizontally expectTileToBeMirroredHorizontally: Bool? = nil,
                    line: UInt = #line
                ) {
                    assertTile(
                        tiles.tile(at: .init(x: x, y: y)),
                        terrain: expectedTerrainKind,
                        road: road,
                        river: river,
                        isCostal: expectTileToBeCoastal,
                        frameIndex: expectedFrameIndex,
                        isMirroredVertically: expectTileToBeMirroredVertically,
                        isMirroredHorizontally: expectTileToBeMirroredHorizontally,
                        line: line
                    )
                }
                
                let expectedRoadPositions: [Position] = [.init(x: 6, y: 1), .init(x: 6, y: 2), .init(x: 6, y: 3), .init(x: 6, y: 4), .init(x: 6, y: 5), .init(x: 2, y: 6), .init(x: 6, y: 6), .init(x: 2, y: 7), .init(x: 3, y: 7), .init(x: 4, y: 7), .init(x: 5, y: 7), .init(x: 6, y: 7), .init(x: 32, y: 7), .init(x: 32, y: 8), .init(x: 32, y: 9), .init(x: 32, y: 10), .init(x: 13, y: 11), .init(x: 32, y: 11), .init(x: 13, y: 12), .init(x: 14, y: 12), .init(x: 15, y: 12), .init(x: 16, y: 12), .init(x: 17, y: 12), .init(x: 18, y: 12), .init(x: 19, y: 12), .init(x: 20, y: 12), .init(x: 21, y: 12), .init(x: 22, y: 12), .init(x: 23, y: 12), .init(x: 32, y: 12), .init(x: 23, y: 13), .init(x: 24, y: 13), .init(x: 25, y: 13), .init(x: 26, y: 13), .init(x: 27, y: 13), .init(x: 28, y: 13), .init(x: 29, y: 13), .init(x: 30, y: 13), .init(x: 31, y: 13), .init(x: 32, y: 13)]
                
                let roadTiles = tiles.filter({ $0.road != nil })
                
                XCTAssertEqual(roadTiles.count, expectedRoadPositions.count)
                
                XCTArraysEqual(
                    roadTiles.map { $0.position },
                    expectedRoadPositions
                )

            }
        )
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
        waitForExpectations(timeout: 1)
    }
}
