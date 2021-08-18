//
//  Integers+RepeatNTimes.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

extension FixedWidthInteger {
    func nTimes<R>(repeat closure: () throws -> R) rethrows -> [R] {
        try (0..<Int(self)).map { _ in
            try closure()
        }
    }
}
