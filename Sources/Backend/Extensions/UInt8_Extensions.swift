//
//  UInt8_Extensions.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-20.
//

import Foundation


public extension UInt8 {
    
    enum Error: Swift.Error {
        case integerLargerThan255
    }
    
    init<I>(integer: I) throws where I: FixedWidthInteger {
        guard integer <= 255 else {
            throw Error.integerLargerThan255
        }
        self = UInt8(integer)
    }
}

