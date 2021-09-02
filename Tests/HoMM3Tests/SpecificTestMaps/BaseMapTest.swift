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
    func at(_ x: Int32, y: Int32) -> Position {
        let position = Position(x: x, y: y, inUnderworld: false)
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
