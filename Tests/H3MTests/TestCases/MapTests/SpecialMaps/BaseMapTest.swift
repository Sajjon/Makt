//
//  BaseMapTest.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-01.
//


import XCTest
import Foundation
import Malm
@testable import H3M

class BaseMapTest: XCTestCase {
    
    private var expectedPositions: [Position: XCTestExpectation] = [:]
    private var fulfilled = Set<Position>()
   
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
}

extension BaseMapTest {
    
    func assertTile(
        _ tile: Map.Tile,
        terrain expectedTerrainKind: Map.Terrain? = nil,
        road expectedRoadKind: Map.Tile.Road.Kind? = nil,
        river expectedRiverKind: Map.Tile.River.Kind? = nil,
        isCostal expectTileToBeCoastal: Bool? = nil,
        frameIndex expectedFrameIndex: Int? = nil,
        isMirroredVertically expectTileToBeMirroredVertically: Bool? = nil,
        isMirroredHorizontally expectTileToBeMirroredHorizontally: Bool? = nil,
        line: UInt = #line,
        file: StaticString = #file
    ) {
        
        if let expectedTerrainKind = expectedTerrainKind {
            XCTAssertEqual(tile.ground.terrain, expectedTerrainKind, file: file, line: line)
        }
       
        if let expectedRoadKind = expectedRoadKind {
            XCTAssertEqual(tile.road?.kind, expectedRoadKind, file: file, line: line)
        }
        
        if let expectedRiverKind = expectedRiverKind {
            XCTAssertEqual(tile.river?.kind, expectedRiverKind, file: file, line: line)
        }

        if let expectTileToBeCoastal = expectTileToBeCoastal {
            if expectTileToBeCoastal {
                XCTAssertTrue(tile.isCoastal, "Expected tile to be costal, but it was not.", file: file, line: line)
            } else {
                XCTAssertFalse(tile.isCoastal, "Expected tile to not be costal, but it is.", file: file, line: line)
            }
        }
        
        if let expectedFrameIndex = expectedFrameIndex {
            XCTAssertEqual(tile.ground.frameIndex, expectedFrameIndex, "Incorrect view id, expected: \(expectedFrameIndex), but got: \(tile.ground.frameIndex)", file: file, line: line)
        }
        
        if let expectTileToBeMirroredVertically = expectTileToBeMirroredVertically {
            if expectTileToBeMirroredVertically {
                XCTAssertTrue(tile.ground.mirroring.flipVertical, "Expected tile to be flipped vertically, but it was not.", file: file, line: line)
            } else {
                XCTAssertFalse(tile.ground.mirroring.flipVertical, "Expected tile to not be flipped vertically, but it is.", file: file, line: line)
            }
        }
        
        if let expectTileToBeMirroredHorizontally = expectTileToBeMirroredHorizontally {
            
            if expectTileToBeMirroredHorizontally {
                XCTAssertTrue(tile.ground.mirroring.flipHorizontal, "Expected tile to be flipped horizontally, but it was not.", file: file, line: line)
            } else {
                XCTAssertFalse(tile.ground.mirroring.flipHorizontal, "Expected tile to not be flipped horizontally, but it is.", file: file, line: line)
            }
        }
        
    }
    
    func assertObjectEvent(
        expected: Map.GeoEvent,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID, .event, file: file, line: line)
        guard case let .geoEvent(actual) = object.kind else {
            XCTFail("expected event", file: file, line: line)
            return
        }
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectResourceGenerator(
        expected: Map.ResourceGenerator,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID.stripped, .resourceGenerator, file: file, line: line)
        guard case let .resourceGenerator(actual) = object.kind else {
            XCTFail("expected resourceGenerator", file: file, line: line)
            return
        }
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectAbandonedMine(
        expected: Map.AbandonedMine,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .abandonedMine(actual) = object.kind else {
            XCTFail("expected abandoned mine", file: file, line: line)
            return
        }
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectQuestGuard(
        expected: Quest,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID.stripped, .questGuard, file: file, line: line)
        guard case let .questGuard(actual) = object.kind else {
            XCTFail("expected quest guard", file: file, line: line)
            return
        }
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectDwelling(
        expected: Map.Dwelling,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .dwelling(actual) = object.kind else {
            XCTFail("expected dwelling", file: file, line: line)
            return
        }
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectRandomDwelling(
        expected expectedRandom: Map.Dwelling.Kind.Random,
        owner: Player? = nil,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .dwelling(actual) = object.kind else {
            XCTFail("expected dwelling (random), but got: \(object)", file: file, line: line)
            return
        }
        XCTAssertEqual(.init(kind: .random(expectedRandom), owner: owner), actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectScholar(
        expected: Map.Scholar,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID.stripped, .scholar, file: file, line: line)
        guard case let .scholar(actual) = object.kind else {
            XCTFail("expected scholar", file: file, line: line)
            return
        }
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectGarrison(
        expected: Map.Garrison,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .garrison(actual) = object.kind else {
            XCTFail("expected garrison", file: file, line: line)
            return
        }
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectResource(
        expected: Map.GuardedResource,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .resource(actual) = object.kind else {
            XCTFail("expected resource", file: file, line: line)
            return
        }
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    
    func assertObjectRandomTown(
        expected: Map.Town,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID.stripped, .randomTown, file: file, line: line)
        guard case let .town(actual) = object.kind else {
            XCTFail("expected random town", file: file, line: line)
            return
        }
        
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectTown(
        expected: Map.Town,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID.stripped, .town, file: file, line: line)
        guard case let .town(actual) = object.kind else {
            XCTFail("expected town", file: file, line: line)
            return
        }
        
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectPandorasBox(
        expected: Map.PandorasBox,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID.stripped, .pandorasBox, file: file, line: line)
        guard case let .pandorasBox(actual) = object.kind else {
            XCTFail("expected pandoras box", file: file, line: line)
            return
        }
        
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectSeersHut(
        expected: Map.Seershut,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID.stripped, .seersHut, file: file, line: line)
        guard case let .seershut(actual) = object.kind else {
            XCTFail("expected seershut", file: file, line: line)
            return
        }
        
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectWitchHut(
        expected: Map.WitchHut,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID.stripped, .witchHut, file: file, line: line)
        guard case let .witchHut(actual) = object.kind else {
            XCTFail("expected witchHut", file: file, line: line)
            return
        }
        
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    
    func assertObjectArtifact(
        expected: Map.GuardedArtifact,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .artifact(actual) = object.kind else {
            XCTFail("Expected artifact, but got: \(object.kind)", file: file, line: line)
            return
        }
        XCTAssertEqual(actual, expected, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectMonster(
        expected: Map.Monster,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .monster(actual) = object.kind else {
            XCTFail("Expected monster, but got: \(object.kind)", file: file, line: line)
            return
        }
        XCTAssertEqual(actual, expected, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectSpellScroll(
        expected: Map.SpellScroll,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .spellScroll(actual) = object.kind else {
            XCTFail("Expected spellScroll, but got: \(object.kind)", file: file, line: line)
            return
        }
        XCTAssertEqual(actual, expected, file: file, line: line)
        fulfill(object: object)
    }

    
    private func assertObjectHeroOfKind(_ objectKind: Map.Object.ID, expected: Hero, actual object: Map.Object, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(object.objectID, objectKind, file: file, line: line)
        guard case let .hero(actual) = object.kind else {
            XCTFail("expected hero", file: file, line: line)
            return
        }
        XCTAssertEqual(expected, actual, file: file, line: line)
        fulfill(object: object)
    }
    
    func assertObjectPrisonHero(
        expected: Hero,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertObjectHeroOfKind(.prison, expected: expected, actual: object, file: file, line: line)
    }
    
    func assertObjectRandomHero(
        expected: Hero,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertObjectHeroOfKind(.randomHero, expected: expected, actual: object, file: file, line: line)
    }
    
    func assertObjectHero(
        `class`: Hero.Class,
        expected: Hero,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertObjectHeroOfKind(.hero(`class`), expected: expected, actual: object, file: file, line: line)
    }
    
    func at(_ x: Int32, y: Int32, inUnderworld: Bool = false) -> Position {
        let position = Position(x: x, y: y, inUnderworld: inUnderworld)
        expectObject(at: position)
        return position
    }
    
    func expectObject(at position: Position) {
        if !fulfilled.contains(position) && !expectedPositions.contains(where: { $0.key == position }) {
            let expectedObjectAt = expectation(description: "Expected object at: (x: \(position.x), y: \(position.y))")
            expectedPositions[position] = expectedObjectAt
        }
    }
    
    func fulfill(object: Map.Object) {
        let position = object.position
        guard let expectation = expectedPositions[position] else {
            return
        }
        expectation.fulfill()
        assert(!fulfilled.contains(position), "Strange to fulfill exp multiple times...")
        fulfilled.insert(position)
        expectedPositions.removeValue(forKey: position)
    }
    
    func pathForTestMap(named mapName: String) throws -> String {
        guard let path = Bundle.module.path(forResource: mapName, ofType: "h3m") else {
            throw Error.mapNotFound(named: mapName)
        }
        return path
    }
    
    
    func idOfMap(named mapName: String) throws -> Map.ID {
        let pathToMap = try pathForTestMap(named: mapName)
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: pathToMap) else {
            throw Error.failedToReadFile(atPath: pathToMap)
        }
        return Map.ID(absolutePath: pathToMap)
   
    }
    
    func loadMap(named: String, inspector: Map.Loader.Parser.Inspector) throws {
        let mapID = try idOfMap(named: named)
        try loadMap(id: mapID, inspector: inspector)
    }
    
    func loadMap(id mapID: Map.ID, inspector: Map.Loader.Parser.Inspector) throws {
        // Delete any earlier cached maps.
        Map.loader.cache.__deleteMap(by: mapID)
        XCTAssertNoThrow(try Map.load(mapID, inspector: inspector))
    }
}

// MARK: Error
extension BaseMapTest {
    enum Error: Swift.Error {
        case mapNotFound(named: String)
        case failedToReadFile(atPath: String)
    }
    
}
