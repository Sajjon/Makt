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
        fullfill(object: object)
    }
    
    func assertObjectTown(
        expected: Map.Town,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(object.objectID, .town(.castle), file: file, line: line)
        guard case let .town(actual) = object.kind else {
            XCTFail("expected town", file: file, line: line)
            return
        }
        
        XCTAssertEqual(expected, actual, file: file, line: line)
        fullfill(object: object)
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
        fullfill(object: object)
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
        fullfill(object: object)
    }
    
//    func assertCreature(
//        _ creatureID: Creature.ID,
//        quantity: Quantity = .random,
//        grows: Bool = true,
//        disposition: Map.Monster.Disposition = .aggressive,
//        mayFlee: Bool = true,
//        message: String? = nil,
//        treasure: Map.Monster.Bounty? = nil,
//        _ line: UInt = #line
//    ) {
//        assertMonster(
//            kind: .specific(creatureID: creatureID),
//            quantity: quantity,
//            grows: grows,
//            disposition: disposition,
//            mayFlee: mayFlee,
//            message: message,
//            treasure: treasure, line
//        )
//    }
//    
//    func assertRandomMonster(
//        level: Creature.Level? = .any,
//        quantity: Quantity = .random,
//        grows: Bool = true,
//        disposition: Map.Monster.Disposition = .aggressive,
//        mayFlee: Bool = true,
//        message: String? = nil,
//        treasure: Map.Monster.Bounty? = nil,
//        _ line: UInt = #line
//    ) {
//        assertMonster(
//            kind: .random(level: level),
//            quantity: quantity,
//            grows: grows,
//            disposition: disposition,
//            mayFlee: mayFlee,
//            message: message,
//            treasure: treasure, line
//        )
//    }
    
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
        fullfill(object: object)
    }

    
    private func assertObjectHeroOfKind(_ objectKind: Map.Object.ID, expected: Hero, actual object: Map.Object, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(object.objectID, objectKind, file: file, line: line)
        guard case let .hero(actual) = object.kind else {
            XCTFail("expected hero", file: file, line: line)
            return
        }
        XCTAssertEqual(expected, actual, file: file, line: line)
        fullfill(object: object)
    }
    
    func assertObjectPrisonHero(
        expected: Hero,
        actual object: Map.Object,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertObjectHeroOfKind(.prison, expected: expected, actual: object, file: file, line: line)
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
    
    func fullfill(object: Map.Object) {
        let position = object.position
        guard let expectation = expectedPositions[position] else {
            return
        }
        print("fulfilling expectation: \(expectation)")
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
