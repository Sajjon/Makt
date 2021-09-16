//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension H3M {
    
    func parseSign() throws -> Map.Sign {
        let message = try reader.readLengthOfStringAndString(assertingMaxLength: 1000)! // arbitrarily chosen
        try reader.skip(byteCount: 4)
        return .init(message: message)
    }
    
    
}
