//
//  BaseMapTest.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-01.
//


import XCTest
import Foundation
@testable import HoMM3SwiftUI

class BaseMapTest: XCTestCase {
    
    private var expectedPositions: [Position: XCTestExpectation] = [:]
    private var fulfilled = Set<Position>()
   
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
}

extension BaseMapTest {
    
    func assertObjectEvent(
        expected: Map.GeoEvent,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID, .event, file: file, line: line)
        guard case let .geoEvent(actual) = object.kind else {
            XCTFail("expected event")
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
        if !fulfilled.contains(position) && !expectedPositions.contains(where: { $0.key == position }) {
            let expectedObjectAt = expectation(description: "Expected object at: (\(x), \(y))")
            expectedPositions[position] = expectedObjectAt
        }
        return position
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
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: mapName, ofType: "h3m") else { throw Error.mapNotFound(named: mapName) }
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
