//
//  UInt8_Extensions.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation

enum UnsignedIntegerError: Swift.Error {
    case integerLargerThanMaxValue
}

public extension FixedWidthInteger where Self: UnsignedInteger {
    

    
    init<I>(integer: I) throws where I: FixedWidthInteger {
        guard integer <= .max else {
            throw UnsignedIntegerError.integerLargerThanMaxValue
        }
        self = Self(integer)
    }
}

