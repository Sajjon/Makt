//
//  Integers+RepeatNTimes.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension FixedWidthInteger {
    func nTimes<R>(repeat closure: () throws -> R) rethrows -> [R] {
        guard self > 0 else { return [] }
        return try (0..<Int(self)).map { _ in
            try closure()
        }
    }
}
