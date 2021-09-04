//
//  EnabledArtifactsBaseMapTest.swift
//  EnabledArtifactsBaseMapTest
//
//  Created by Alexander Cyon on 2021-09-04.
//

import Foundation
import XCTest

@testable import HoMM3SwiftUI

class EnabledArtifactsBaseTests: BaseMapTest {
    
    var mapFileName: String { "OVERRIDE_THIS_FILE_NAME_PLEASE" }
    var mapName: String { "OVERRIDE_THIS_MAP_NAME_PLEASE" }
    
    func doTestEnabledArtifacts(expected: [Artifact.ID]) throws {
        XCTAssertFalse(expected.isEmpty)
        
        let expectationParseAvailableArtifacts = expectation(description: "Available Artifacts")
        let expectationParseObjectSign = expectation(description: "Parse object 'Sign'")
        let expectationRumor = expectation(description: "Parse rumor")
        let expectationGlobalTimedEvent = expectation(description: "Parse timed event")
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: { XCTAssertEqual($0, .shadowOfDeath) },
                onParseName: { XCTAssertEqual($0, self.mapName) },
                onParseDescription: { XCTAssertEqual($0, "") },
                onParseDifficulty: { XCTAssertEqual($0, .normal) },
                onParseSize: { XCTAssertEqual($0, .small) },
                onFinishedParsingBasicInfo: { XCTAssertFalse($0.hasTwoLevels) }
            ),
            additionalInformationInspector: Map.Loader.Parser.Inspector.AdditionalInfoInspector(
                onParseAvailableArtifacts: { availableArtifacts in
                    expectationParseAvailableArtifacts.fulfill()
                    guard let actual = availableArtifacts?.artifacts else {
                        XCTFail("Expected to have parsed available artifacts.")
                        return
                    }
                    XCTAssertEqual(actual, expected)
                },
                onParseRumors: { rumors in
                    defer { expectationRumor.fulfill() }
                    guard let rumor = rumors.rumors.first else {
                        XCTFail("Expected exact one rumor.")
                        return
                    }
                    XCTAssertEqual(rumor.name, "Marker rumor.")
                    XCTAssertEqual(rumor.text, "This only rumor is used as a shared marker for all maps we are testing. If we successfully parse this message we know that we are at the correct offset at the end of 'Additional Info'/'Map Specifications' struct, and the relevant information we are testing are before this part (rumors).")
                }
            ),
            onParseAllObjects: { objects in
                defer { expectationParseObjectSign.fulfill() }
                guard let object = objects.objects.first else {
                    XCTFail("Expected exact one object.")
                    return
                }
                guard case let .sign(sign) = object.kind else {
                    XCTFail("Expected a sign, but got: \(object.kind)")
                    return
                }
                XCTAssertEqual(sign.message, "Check \"Map Specifications\" to see what this map tests. Not objects.")
            },
            onParseEvents: { timedGlobalEvents in
                defer { expectationGlobalTimedEvent.fulfill() }
                guard let event = timedGlobalEvents.events.first else {
                    XCTFail("Expected exact one event.")
                    return
                }
                XCTAssertEqual(event.name, "Marker event.")
                XCTAssertEqual(event.message, "This only event is used as a shared marker for all maps we are testing. If we successfully parse this message we know that we are at the correct offset at the end of the whole map. This gives some indication that we at least are parsing the correct amount of bytes. This test will assert the contents of the relevant parts we are testing, that comes before this message.")
                XCTAssertEqual(event.resources, .init(resources: [
                    .init(kind: .ore, amount: 237),
                    .init(kind: .sulfur, amount: -1337)
                ]))
            }
        )
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension EnabledArtifactsBaseTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: mapFileName, inspector: inspector)
    }
}
