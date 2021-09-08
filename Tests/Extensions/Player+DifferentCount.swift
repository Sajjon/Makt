//
//  Player+DifferentCount.swift
//  Tests
//
//  Created by Alexander Cyon on 2021-09-08.
//

import Foundation

import XCTest
import Foundation
@testable import HoMM3SwiftUI
    
protocol FromPlayer: Equatable, RawRepresentable where RawValue == UInt8 {
    init?(player: Player)
}

extension FromPlayer {
    init?(player: Player) {
        self.init(rawValue: player.rawValue)
    }
}

func XCTArraysEqual<S: Sequence>(_ lhsArray: S, _ rhsArray: S, file: StaticString = #file, line: UInt = #line) where S.Element: Hashable {
    let lhs = Set(lhsArray)
    let rhs = Set(rhsArray)
    if lhs != rhs {
        let diff = lhs.symmetricDifference(rhs)
        let lhsOnly = lhs.subtracting(rhs)
        let rhsOnly = rhs.subtracting(lhs)
        
        let lhsOnlyString = lhsOnly.isEmpty ? "" : "The following elements were found only in LHS sequence: \(lhsOnly)"
        let rhsOnlyString = rhsOnly.isEmpty ? "" : "The following elements were found only in RHS sequence: \(rhsOnly)"
        
        XCTAssertTrue(
            diff.isEmpty,
            ["Expected sequences to contain same elements, but they did not.", lhsOnlyString, rhsOnlyString].joined(separator: "\n"),
            file: file, line: line
        )
        
    } else {
        XCTAssert(true, "Ignoring order, the arrays equal each other.", file: file, line: line)
    }
}
enum TwoPlayer: UInt8, FromPlayer {
    case playerOne, playerTwo
}

enum ThreePlayer: UInt8, FromPlayer {
    case playerOne, playerTwo, playerThree
}

enum FivePlayer: UInt8, FromPlayer {
    case playerOne, playerTwo, playerThree, playerFour, playerFive
}

enum SixPlayer: UInt8, FromPlayer {
    case playerOne, playerTwo, playerThree, playerFour, playerFive, playerSix
}


func twoPlayer(_ player: Player) throws -> TwoPlayer {
    try XCTUnwrap(TwoPlayer(player: player), "Expected only player Red and playerTwo, but got: \(player)")
}

func threePlayers(_ player: Player) throws -> ThreePlayer {
    try XCTUnwrap(ThreePlayer(player: player), "Expected only player Red, Blue and Tan, but got: \(player)")
}

func fivePlayers(_ player: Player) throws -> FivePlayer {
    try XCTUnwrap(FivePlayer(player: player), "Expected only player Red, Blue, Tan, Green and Orange, but got: \(player)")
}

func sixPlayers(_ player: Player) throws -> SixPlayer {
    try XCTUnwrap(.init(player: player), "Expected only player Red, Blue, Tan, Green, Orange and Purple, but got: \(player)")
}

extension Map.BasicInformation {
    var fileName: String { id.fileName }
}
