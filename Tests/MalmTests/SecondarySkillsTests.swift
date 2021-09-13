//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-13.
//

import Foundation
import XCTest
@testable import Malm

final class SecondarySkillsTests: XCTestCase {
    func testNoDuplicatesAllowed() {
        XCTAssertThrowsError(
            try Hero.SecondarySkills(checking: [
                .init(kind: .wisdom, level: .basic),
                .init(kind: .wisdom, level: .advanced),
                .init(kind: .logistics, level: .expert)
            ]),
            "Should prevent literals containing secondary skills of same kind, literal above contains duplicate of 'Wisdom' which is not allowed."
        ) { error in
            guard let duplicateError = error as? Hero.SecondarySkills.Error else {
                XCTFail("Wrong error type")
                return
            }
            XCTAssertEqual(duplicateError, .duplicatedKeyFound(.wisdom))
        }
    }
}
