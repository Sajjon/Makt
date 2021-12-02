//
//  File.swift
//  
//
//  Created by Alexander Cyon on 2021-10-15.
//

import XCTest
import Foundation
import Malm

final class SkipEncodingIfFalsePropertyWrapperTests: XCTestCase {

    func testFalseFalse() throws {
        let model = TwoBools(foo: false, bar: false)
        let json = try model.json()
        let dict = json.dict
        XCTAssertEqual(dict[.foo], false)
        XCTAssertNil(dict[.bar])
        
        let roundtrip = try TwoBools.fromJSON(data: json.data)
        XCTAssertEqual(model, roundtrip)
    }
    
    func testTrueTrue() throws {
        let model = TwoBools(foo: true, bar: true)
        let json = try model.json()
        let dict = json.dict
        XCTAssertEqual(dict[.foo], true)
        XCTAssertEqual(dict[.bar], true)
        
        let roundtrip = try TwoBools.fromJSON(data: json.data)
        XCTAssertEqual(model, roundtrip)
    }
}

private extension String {
    static let foo = "foo"
    static let bar = "bar"
}

private struct JSON {
    let dict: [String: Bool]
    let data: Data
}

private struct TwoBools: Equatable, Codable {
    let foo: Bool
    
    static func fromJSON(data: Data) throws -> Self {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(self, from: data)
    }
    
    @SkipEncodingIfFalse
    internal private(set) var bar: Bool
    
    func json() throws -> JSON {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        let dictionary = json as! [String: Any]
        let dict: [String: Bool] = .init(uniqueKeysWithValues: dictionary.map({ k, v in (key: k, value: v as! Bool) }))
        return .init(
            dict: dict, data: data
        )
    }
}
