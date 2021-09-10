//
//  EnabledArtifactsBaseMapTest.swift
//  EnabledArtifactsBaseMapTest
//
//  Created by Alexander Cyon on 2021-09-04.
//

import Foundation
import XCTest

import Malm
@testable import H3M

class AdditionalInfoBaseTests: BaseMapTest {
    
    var mapFileName: String { "OVERRIDE_THIS_FILE_NAME_PLEASE" }
    var mapName: String { "OVERRIDE_THIS_MAP_NAME_PLEASE" }
    
    func doTestAdidtionalInformation(
        
        onParseFormat: @escaping Map.Loader.Parser.Inspector.BasicInfoInspector.OnParseFormat,
        onParseName: @escaping Map.Loader.Parser.Inspector.BasicInfoInspector.OnParseName,
        onParseDescription: @escaping Map.Loader.Parser.Inspector.BasicInfoInspector.OnParseDescription = { XCTAssertEqual($0, "") },
        onParseDifficulty: @escaping Map.Loader.Parser.Inspector.BasicInfoInspector.OnParseDifficulty = { XCTAssertEqual($0, .normal) },
        onParseSize: @escaping Map.Loader.Parser.Inspector.BasicInfoInspector.OnParseSize = { XCTAssertEqual($0, .small) },
        onFinishedParsingBasicInfo: @escaping Map.Loader.Parser.Inspector.BasicInfoInspector.OnFinishedParsingBasicInfo = { XCTAssertFalse($0.hasTwoLevels) },
        
        onParseAvailableHeroes: Map.Loader.Parser.Inspector.AdditionalInfoInspector.OnParseAvailableHeroes? = nil,
        onParseTeamInfo: Map.Loader.Parser.Inspector.AdditionalInfoInspector.OnParseTeamInfo? = nil,
        onParseCustomHeroes: Map.Loader.Parser.Inspector.AdditionalInfoInspector.OnParseCustomHeroes? = nil,
        onParseAvailableArtifacts: Map.Loader.Parser.Inspector.AdditionalInfoInspector.OnParseAvailableArtifacts? = nil,
        onParseAvailableSpells: Map.Loader.Parser.Inspector.AdditionalInfoInspector.OnParseAvailableSpells? = nil,
        onParseAvailableSecondarySkills: Map.Loader.Parser.Inspector.AdditionalInfoInspector.OnParseAvailableSecondarySkills? = nil,
        
        onParseHeroSettings: Map.Loader.Parser.Inspector.AdditionalInfoInspector.OnParseHeroSettings? = nil
    ) throws {
   
        let expectationVictory = expectation(description: "Parse Victory")
        let expectationLoss = expectation(description: "Parse Loss")
        let expectationParseObjectSign = expectation(description: "Parse object 'Sign'")
        let expectationRumor = expectation(description: "Parse rumor")
        let expectationGlobalTimedEvent = expectation(description: "Parse timed event")
        
        let inspector = Map.Loader.Parser.Inspector(
            basicInfoInspector: .init(
                onParseFormat: onParseFormat,
                onParseName: onParseName,
                onParseDescription: onParseDescription,
                onParseDifficulty: onParseDifficulty,
                onParseSize: onParseSize,
                onFinishedParsingBasicInfo: onFinishedParsingBasicInfo
            ),
            additionalInformationInspector: Map.Loader.Parser.Inspector.AdditionalInfoInspector(
                victoryLossInspector: .init(
                    onParseVictoryConditions: { victoryConditions in
                        XCTAssertEqual(victoryConditions.map { $0.kind }, [.acquireSpecificArtifact(.vialOfLifeblood), .standard])
                        expectationVictory.fulfill()
                    },
                    onParseLossConditions: { lossConditions in
                        XCTAssertEqual(lossConditions, [.init(kind: .timeLimitMonths(9)), .standard])
                        expectationLoss.fulfill()
                    }
                ),
                onParseTeamInfo: onParseTeamInfo,
                onParseAvailableHeroes: onParseAvailableHeroes,
                onParseCustomHeroes: onParseCustomHeroes,
                onParseAvailableArtifacts: onParseAvailableArtifacts,
                onParseAvailableSpells: onParseAvailableSpells,
                onParseAvailableSecondarySkills: onParseAvailableSecondarySkills,
                onParseRumors: { rumors in
                    defer { expectationRumor.fulfill() }
                    guard let rumor = rumors.first else {
                        XCTFail("Expected exact one rumor.")
                        return
                    }
                    XCTAssertEqual(rumor.name, "Marker rumor.")
                    XCTAssertEqual(rumor.text, "This only rumor is used as a shared marker for all maps we are testing. If we successfully parse this message we know that we are at the correct offset at the end of 'Additional Info'/'Map Specifications' struct, and the relevant information we are testing are before this part (rumors).")
                },
                onParseHeroSettings: onParseHeroSettings
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
                    .init(kind: .ore, quantity: 237),
                    .init(kind: .sulfur, quantity: -1337)
                ]))
            }
        )
        try load(inspector: inspector)
        waitForExpectations(timeout: 1)
    }
}

private extension AdditionalInfoBaseTests {
    func load(inspector: Map.Loader.Parser.Inspector) throws {
        try loadMap(named: mapFileName, inspector: inspector)
    }
}
