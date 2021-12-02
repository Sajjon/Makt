//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-17.
//

import Foundation

public enum IntegerDivisionRounding: Equatable {
    case up
    case down
}
public extension FixedWidthInteger {
    func divide(by division: Self, rounding: IntegerDivisionRounding) -> Self {
        let round: (Float) -> Float = rounding == .up ? ceil : floor
        return Self(round(Float(self)/Float(division)))
    }
}
